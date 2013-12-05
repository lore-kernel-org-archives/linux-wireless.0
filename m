Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:50695 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3LEF5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 00:57:21 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so11199749eaj.12
        for <linux-wireless@vger.kernel.org>; Wed, 04 Dec 2013 21:57:20 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix WEP Shared authentication
Date: Thu,  5 Dec 2013 06:53:41 +0100
Message-Id: <1386222821-3062-1-git-send-email-michal.kazior@tieto.com> (sfid-20131205_065725_028373_ED0F7CCD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frames received from FW were treated incorrectly.
This led to stations being unable to associate to
WEP Shared ath10k AP. This was indicated by a
bizarre hostapd message:

  Unsupported authentication algorithm (36088)

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c654137..ce6475a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -937,7 +937,11 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = le16_to_cpu(hdr->frame_control);
 
-	if (fc & IEEE80211_FCTL_PROTECTED) {
+	/* FW delivers WEP Shared Auth frame with Protected Bit set and
+	 * encrypted payload. However in case of PMF it delivers decrypted
+	 * frames with Protected Bit set. */
+	if (ieee80211_has_protected(hdr->frame_control) &&
+	    !ieee80211_is_auth(hdr->frame_control)) {
 		status->flag |= RX_FLAG_DECRYPTED | RX_FLAG_IV_STRIPPED |
 				RX_FLAG_MMIC_STRIPPED;
 		hdr->frame_control = __cpu_to_le16(fc &
-- 
1.8.4.rc3

