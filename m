Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35194 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933745AbbDUVda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2015 17:33:30 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 3/3] staging: vt6655: lock MACvWriteBSSIDAddress.
Date: Tue, 21 Apr 2015 22:33:02 +0100
Message-Id: <1429651982-4352-3-git-send-email-tvboxspy@gmail.com> (sfid-20150421_233335_563343_00E67D82)
In-Reply-To: <1429651982-4352-1-git-send-email-tvboxspy@gmail.com>
References: <1429651982-4352-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function selects page 1 and cause intermittent problems on
interrupt handler.

lock call with spin_lock_irqsave.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org> # v3.19+
---
 drivers/staging/vt6655/device_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 26a6f67..8f96cc9 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1412,9 +1412,16 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 
 	priv->current_aid = conf->aid;
 
-	if (changed & BSS_CHANGED_BSSID)
+	if (changed & BSS_CHANGED_BSSID) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&priv->lock, flags);
+
 		MACvWriteBSSIDAddress(priv->PortOffset, (u8 *)conf->bssid);
 
+		spin_unlock_irqrestore(&priv->lock, flags);
+	}
+
 	if (changed & BSS_CHANGED_BASIC_RATES) {
 		priv->basic_rates = conf->basic_rates;
 
-- 
2.1.4

