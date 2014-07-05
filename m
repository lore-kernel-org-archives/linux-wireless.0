Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:38159 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965101AbaGESYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2014 14:24:55 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so2731394wgh.35
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2014 11:24:54 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/8] staging: vt6656: vnt_tx_packet don't change power when off channel.
Date: Sat,  5 Jul 2014 19:24:23 +0100
Message-Id: <1404584667-3582-4-git-send-email-tvboxspy@gmail.com> (sfid-20140705_202459_899061_E43CA3ED)
In-Reply-To: <1404584667-3582-1-git-send-email-tvboxspy@gmail.com>
References: <1404584667-3582-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The changing channel is so fast when off channel that changing power is pointless.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index e896dfe5d..95b6cf3 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -900,7 +900,8 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	rate = ieee80211_get_tx_rate(priv->hw, info);
 
 	current_rate = rate->hw_value;
-	if (priv->wCurrentRate != current_rate) {
+	if (priv->wCurrentRate != current_rate &&
+			!(priv->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)) {
 		priv->wCurrentRate = current_rate;
 		bScheduleCommand(priv, WLAN_CMD_SETPOWER, NULL);
 	}
-- 
1.9.1

