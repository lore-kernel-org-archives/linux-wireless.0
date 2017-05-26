Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35097 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163744AbdEZG5U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 02:57:20 -0400
Received: by mail-pf0-f195.google.com with SMTP id u26so757216pfd.2
        for <linux-wireless@vger.kernel.org>; Thu, 25 May 2017 23:57:20 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: uap: process remain on channel expired event
Date: Fri, 26 May 2017 06:57:13 +0000
Message-Id: <1495781833-25585-1-git-send-email-huxinming820@gmail.com> (sfid-20170526_085832_972025_366F424C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

AP interface need process remain-on-channel firmware event and notify
cfg80211, this will be used in the listen-stage of p2p find procedure.

Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/uap_event.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/uap_event.c b/drivers/net/wireless/marvell/mwifiex/uap_event.c
index e10b2a5..e8c8728 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_event.c
@@ -312,6 +312,17 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 					    adapter->event_skb->len -
 					    sizeof(eventcause));
 		break;
+
+	case EVENT_REMAIN_ON_CHAN_EXPIRED:
+		mwifiex_dbg(adapter, EVENT,
+			    "event: uap: Remain on channel expired\n");
+		cfg80211_remain_on_channel_expired(&priv->wdev,
+						   priv->roc_cfg.cookie,
+						   &priv->roc_cfg.chan,
+						   GFP_ATOMIC);
+		memset(&priv->roc_cfg, 0x00, sizeof(struct mwifiex_roc_cfg));
+		break;
+
 	default:
 		mwifiex_dbg(adapter, EVENT,
 			    "event: unknown event id: %#x\n", eventcause);
-- 
1.9.1
