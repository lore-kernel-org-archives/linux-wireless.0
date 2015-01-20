Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44074 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbbATKnZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 05:43:25 -0500
Received: by mail-wi0-f170.google.com with SMTP id em10so3801287wid.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2015 02:43:23 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: remove sw encryption for pmf
Date: Tue, 20 Jan 2015 11:42:42 +0100
Message-Id: <1421750563-15945-1-git-send-email-michal.kazior@tieto.com> (sfid-20150120_114328_474945_76CFD580)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marek Kwaczynski <marek.kwaczynski@tieto.com>

Software encryption was never necessary.
Tested with fw 636 and fw 10.x.

Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9524bc5..78834c3 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -58,10 +58,7 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_CCMP:
 		arg.key_cipher = WMI_CIPHER_AES_CCM;
-		if (arvif->vdev_type == WMI_VDEV_TYPE_AP)
-			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV_MGMT;
-		else
-			key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV_MGMT;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		arg.key_cipher = WMI_CIPHER_TKIP;
-- 
1.8.5.3

