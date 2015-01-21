Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:59150 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbbAUH6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2015 02:58:30 -0500
Received: by mail-pd0-f181.google.com with SMTP id g10so15260413pdj.12
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2015 23:58:29 -0800 (PST)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] rtlwifi: add support to send beacon frame.
Date: Wed, 21 Jan 2015 16:58:19 +0900
Message-Id: <1421827099-17975-1-git-send-email-ap420073@gmail.com> (sfid-20150121_085834_385836_A9B724F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In AP mode, beacon frame is necessary to keep connection.
this patch adds a sending beacon frame routine in initialization routine.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index eb20316..a31a127 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -1010,6 +1010,16 @@ static int rtl_op_conf_tx(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static void send_beacon_frame(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct sk_buff *skb = ieee80211_beacon_get(hw, vif);
+
+	if (skb)
+		rtlpriv->intf_ops->adapter_tx(hw, NULL, skb, NULL);
+}
+
 static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_bss_conf *bss_conf,
@@ -1040,6 +1050,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 
 				if (rtlpriv->cfg->ops->linked_set_reg)
 					rtlpriv->cfg->ops->linked_set_reg(hw);
+				send_beacon_frame(hw, vif);
 			}
 		}
 		if ((changed & BSS_CHANGED_BEACON_ENABLED &&
-- 
1.9.1

