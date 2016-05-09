Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49986 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbcEIXL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 19:11:28 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 18/21] ath10k: Note limitation on beaconing vdevs.
Date: Mon,  9 May 2016 16:11:12 -0700
Message-Id: <1462835475-11079-19-git-send-email-greearb@candelatech.com> (sfid-20160510_011150_939047_3B3C0BF0)
In-Reply-To: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
References: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This only pertains to CT firmware, as standard firmware
can't do anywhere near this many vdevs anyway.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 373f2ee..f1bfb3a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1343,6 +1343,22 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif,
 	arg.channel.max_reg_power = chandef->chan->max_reg_power * 2;
 	arg.channel.max_antenna_gain = chandef->chan->max_antenna_gain * 2;
 
+	/* CT Firmware can support 32+ VDEVS, but can only support
+	 * beacon-ing devs with dev ids 0 - 31 due to firmware limitations.
+	 * Create VAPs first and all should be well...likely most people
+	 * won't ever hit this anyway, but some day the vdev ID allocation
+	 * could be made smarter to make it more likely to work no matter the
+	 * order the vdevs are created. --Ben
+	 */
+	if ((arvif->vdev_type == WMI_VDEV_TYPE_AP) ||
+	    (arvif->vdev_type == WMI_VDEV_TYPE_IBSS)) {
+		if (arg.vdev_id > 31) {
+			ath10k_warn(ar, "failed to start vdev %i  Beaconing VIFS must have IDs <= 31 to work-around firmware limitations.\n",
+				    arg.vdev_id);
+			return -EINVAL;
+		}
+	}
+
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
 		arg.ssid = arvif->u.ap.ssid;
 		arg.ssid_len = arvif->u.ap.ssid_len;
-- 
2.4.3

