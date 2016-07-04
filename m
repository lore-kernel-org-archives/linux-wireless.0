Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33541 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbcGDLJ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2016 07:09:26 -0400
Received: by mail-wm0-f68.google.com with SMTP id r201so20822086wme.0
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2016 04:09:25 -0700 (PDT)
From: lemagoup@gmail.com
To: kvalo@qca.qualcomm.com
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	jmassot@aldebaran.com,
	Pierre Le Magourou <plemagourou@aldebaran.com>
Subject: [PATCH v2 1/3] ath6kl: Fix WLAN tethering authentication problem.
Date: Mon,  4 Jul 2016 13:07:17 +0200
Message-Id: <20160704110719.7694-2-plemagourou@aldebaran.com> (sfid-20160704_130946_151030_58F75BC2)
In-Reply-To: <20160704110719.7694-1-plemagourou@aldebaran.com>
References: <20160704110719.7694-1-plemagourou@aldebaran.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pierre Le Magourou <plemagourou@aldebaran.com>

When enabling WLAN tethering, a new AP is visible and a STA could
connect to it. When the STA tries to authenticate to the newly created
AP, the WPA authentication mechanism is stuck in the 1/4 msg of 4-Way
Handshake.

In ath6kl_rx(), the ath6kl_find_sta() function is looking for the
h_source field of the Ethernet frame header received by the STA. The
datap pointer that points to the Ethernet frame header is incorrect,
and was pointing at the wrong offset in the buffer.

This commit adds a pad_before_data_start offset to set the datap pointer
to the Ethernet frame header. datap->h_source parameter is now really
pointing to the source ethernet address and the authentication process
can continue.

Signed-off-by: Pierre Le Magourou <plemagourou@aldebaran.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 40432fe..9df41d5 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1401,6 +1401,10 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		return;
 	}
 
+	pad_before_data_start =
+		(le16_to_cpu(dhdr->info3) >> WMI_DATA_HDR_PAD_BEFORE_DATA_SHIFT)
+			& WMI_DATA_HDR_PAD_BEFORE_DATA_MASK;
+
 	/* Get the Power save state of the STA */
 	if (vif->nw_type == AP_NETWORK) {
 		meta_type = wmi_data_hdr_get_meta(dhdr);
@@ -1408,7 +1412,7 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		ps_state = !!((dhdr->info >> WMI_DATA_HDR_PS_SHIFT) &
 			      WMI_DATA_HDR_PS_MASK);
 
-		offset = sizeof(struct wmi_data_hdr);
+		offset = sizeof(struct wmi_data_hdr) + pad_before_data_start;
 		trig_state = !!(le16_to_cpu(dhdr->info3) & WMI_DATA_HDR_TRIG);
 
 		switch (meta_type) {
@@ -1523,9 +1527,6 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	seq_no = wmi_data_hdr_get_seqno(dhdr);
 	meta_type = wmi_data_hdr_get_meta(dhdr);
 	dot11_hdr = wmi_data_hdr_get_dot11(dhdr);
-	pad_before_data_start =
-		(le16_to_cpu(dhdr->info3) >> WMI_DATA_HDR_PAD_BEFORE_DATA_SHIFT)
-			& WMI_DATA_HDR_PAD_BEFORE_DATA_MASK;
 
 	skb_pull(skb, sizeof(struct wmi_data_hdr));
 
-- 
2.9.0

