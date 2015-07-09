Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33223 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbGIQEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 12:04:14 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] staging: vt6656: check ieee80211_bss_conf bssid not NULL
Date: Thu,  9 Jul 2015 17:03:57 +0100
Message-Id: <1436457837-3259-1-git-send-email-tvboxspy@gmail.com> (sfid-20150709_180418_336183_4364F454)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes bssid can go null on failed association.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v3.17+
---
 drivers/staging/vt6656/main_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index f97323f..af572d7 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -701,7 +701,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 
 	priv->current_aid = conf->aid;
 
-	if (changed & BSS_CHANGED_BSSID)
+	if (changed & BSS_CHANGED_BSSID && conf->bssid)
 		vnt_mac_set_bssid_addr(priv, (u8 *)conf->bssid);
 
 
-- 
2.1.4

