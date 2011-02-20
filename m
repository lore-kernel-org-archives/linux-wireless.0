Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61745 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab1BTM6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 07:58:08 -0500
Received: by ewy6 with SMTP id 6so85097ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 04:58:06 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/8] rt2x00: Minor optimization for devices with RTS/CTS offload
Date: Sun, 20 Feb 2011 13:55:46 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201102201354.53379.IvDoorn@gmail.com> <201102201355.26260.IvDoorn@gmail.com>
In-Reply-To: <201102201355.26260.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201102201355.47592.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Only devices that don't have RTS/CTS offload need to check for
IEEE80211_TX_RC_USE_RTS_CTS and IEEE80211_TX_RC_USE_CTS_PROTECT.

By swapping both conditions we keep the same number of needed conditionals
for devices without RTS/CTS offload but save one conditional on devices
with RTS/CTS offload.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 6a66021..1b3edef 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -139,9 +139,9 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * either RTS or CTS-to-self frame and handles everything
 	 * inside the hardware.
 	 */
-	if ((tx_info->control.rates[0].flags & (IEEE80211_TX_RC_USE_RTS_CTS |
-						IEEE80211_TX_RC_USE_CTS_PROTECT)) &&
-	    !rt2x00dev->ops->hw->set_rts_threshold) {
+	if (!rt2x00dev->ops->hw->set_rts_threshold &&
+	    (tx_info->control.rates[0].flags & (IEEE80211_TX_RC_USE_RTS_CTS |
+						IEEE80211_TX_RC_USE_CTS_PROTECT))) {
 		if (rt2x00queue_available(queue) <= 1)
 			goto exit_fail;
 
-- 
1.7.2.3

