Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35724 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbcGSKch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 06:32:37 -0400
Received: by mail-lf0-f54.google.com with SMTP id f93so10086041lfi.2
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 03:32:36 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	marek.puzyniak@tieto.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/4] ath10k: fix spurious tx/rx during boot
Date: Tue, 19 Jul 2016 12:34:12 +0200
Message-Id: <1468924452-23877-5-git-send-email-michal.kazior@tieto.com> (sfid-20160719_123241_731726_B17BD7E4)
In-Reply-To: <1468924452-23877-1-git-send-email-michal.kazior@tieto.com>
References: <1468924452-23877-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HW Rx filters and masks are not configured
properly by firmware during boot sequences. The
MAC_PCU_ADDR1 is set to 0s instead of 1s which
allows the HW to ACK any frame that passes through
MAC_PCU_RX_FILTER. The MAC_PCU_RX_FILTER itself
is misconfigured on boot as well.

The combination of these bugs ended up with the
following manifestations:
 - "no channel configured; ignoring frame(s)!"
   warnings in the driver
 - spurious ACKs (transmission) on the air during
   firmware bootup sequences

The former was a long standing and known bug
originally though mostly harmless.

However Marek recently discovered that this
problem also involves ACKing *all* frames the HW
receives (including beacons ;). Such frames
are delivered to host and generate the former
warning as well.

This could be a problem with regulatory compliance
in some rare cases (e.g. Taiwan which forbids
transmissions on channel 36 which is the default
bootup channel on 5Ghz band cards). The good news
is that it'd require someone else to violate
regulatory first to coerce our device to generate
and transmit an ACK.

The problem could be reproduced in a rather busy
environment that has a lot of APs. The likelihood
could be increased by injecting an msleep() of
5000 or longer immediately after
ath10k_htt_setup() in ath10k_core_start().

The reason why the former warnings were only
showing up seldom is because the device was either
quickly reset again (i.e. during firmware probing)
or wmi vdev was created (which fixes hw and fw
states).

It is technically possible for host driver to
override adequate hw registers however this can't
work reliably because the bug root cause lies in
incorrect firmware state on boot (internal
structure used to program MAC_PCU_ADDR1 is not
properly initialized) and only vdev create/delete
events can fix it. This is why the patch takes
dummy vdev approach.

This could be fixed in firmware as well but having
this fixed in driver is more robust, most notably
when thinking of users of older firmware such as
999.999.0.636.

Reported-by: Marek Puzyniak <marek.puzyniak@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 68 ++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index e88982921aa3..d2e255418d1b 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1705,6 +1705,55 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	return 0;
 }
 
+static int ath10k_core_reset_rx_filter(struct ath10k *ar)
+{
+	int ret;
+	int vdev_id;
+	int vdev_type;
+	int vdev_subtype;
+	const u8 *vdev_addr;
+
+	vdev_id = 0;
+	vdev_type = WMI_VDEV_TYPE_STA;
+	vdev_subtype = ath10k_wmi_get_vdev_subtype(ar, WMI_VDEV_SUBTYPE_NONE);
+	vdev_addr = ar->mac_addr;
+
+	ret = ath10k_wmi_vdev_create(ar, vdev_id, vdev_type, vdev_subtype,
+				     vdev_addr);
+	if (ret) {
+		ath10k_err(ar, "failed to create dummy vdev: %d\n", ret);
+		return ret;
+	}
+
+	ret = ath10k_wmi_vdev_delete(ar, vdev_id);
+	if (ret) {
+		ath10k_err(ar, "failed to delete dummy vdev: %d\n", ret);
+		return ret;
+	}
+
+	/* WMI and HTT may use separate HIF pipes and are not guaranteed to be
+	 * serialized properly implicitly.
+	 *
+	 * Moreover (most) WMI commands have no explicit acknowledges. It is
+	 * possible to infer it implicitly by poking firmware with echo
+	 * command - getting a reply means all preceding comments have been
+	 * (mostly) processed.
+	 *
+	 * In case of vdev create/delete this is sufficient.
+	 *
+	 * Without this it's possible to end up with a race when HTT Rx ring is
+	 * started before vdev create/delete hack is complete allowing a short
+	 * window of opportunity to receive (and Tx ACK) a bunch of frames.
+	 */
+	ret = ath10k_wmi_barrier(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to ping firmware: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		      const struct ath10k_fw_components *fw)
 {
@@ -1872,6 +1921,25 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		goto err_hif_stop;
 	}
 
+	/* Some firmware revisions do not properly set up hardware rx filter
+	 * registers.
+	 *
+	 * A known example from QCA9880 and 10.2.4 is that MAC_PCU_ADDR1_MASK
+	 * is filled with 0s instead of 1s allowing HW to respond with ACKs to
+	 * any frames that matches MAC_PCU_RX_FILTER which is also
+	 * misconfigured to accept anything.
+	 *
+	 * The ADDR1 is programmed using internal firmware structure field and
+	 * can't be (easily/sanely) reached from the driver explicitly. It is
+	 * possible to implicitly make it correct by creating a dummy vdev and
+	 * then deleting it.
+	 */
+	status = ath10k_core_reset_rx_filter(ar);
+	if (status) {
+		ath10k_err(ar, "failed to reset rx filter: %d\n", status);
+		goto err_hif_stop;
+	}
+
 	/* If firmware indicates Full Rx Reorder support it must be used in a
 	 * slightly different manner. Let HTT code know.
 	 */
-- 
2.1.4

