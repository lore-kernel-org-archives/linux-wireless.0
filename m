Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:37932 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430Ab2AXJG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 04:06:56 -0500
Received: by mail-lpp01m010-f47.google.com with SMTP id s15so2156300lag.6
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 01:06:55 -0800 (PST)
MIME-Version: 1.0
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 8/8] wl12xx: add testmode operation to read the BD_ADDR from Fuse ROM
Date: Tue, 24 Jan 2012 11:06:29 +0200
Message-Id: <1327395989-29663-9-git-send-email-coelho@ti.com> (sfid-20120124_100707_507115_8E940428)
In-Reply-To: <1327395989-29663-1-git-send-email-coelho@ti.com>
References: <1327395989-29663-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a testmode command to retrieve the BD_ADDR that is stored in the
Fuse ROM in newer PGs.  In old PGs this operation is not supported.
The caller can then derive the MAC addresses from it.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/testmode.c |   50 ++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/testmode.c b/drivers/net/wireless/wl12xx/testmode.c
index 25093c0..b2e8183 100644
--- a/drivers/net/wireless/wl12xx/testmode.c
+++ b/drivers/net/wireless/wl12xx/testmode.c
@@ -30,6 +30,7 @@
 #include "acx.h"
 #include "reg.h"
 #include "ps.h"
+#include "io.h"
 
 #define WL1271_TM_MAX_DATA_LENGTH 1024
 
@@ -41,6 +42,7 @@ enum wl1271_tm_commands {
 	WL1271_TM_CMD_NVS_PUSH,		/* Not in use. Keep to not break ABI */
 	WL1271_TM_CMD_SET_PLT_MODE,
 	WL1271_TM_CMD_RECOVER,
+	WL1271_TM_CMD_GET_MAC,
 
 	__WL1271_TM_CMD_AFTER_LAST
 };
@@ -264,6 +266,52 @@ static int wl1271_tm_cmd_recover(struct wl1271 *wl, struct nlattr *tb[])
 	return 0;
 }
 
+static int wl12xx_tm_cmd_get_mac(struct wl1271 *wl, struct nlattr *tb[])
+{
+	struct sk_buff *skb;
+	u8 mac_addr[ETH_ALEN];
+	int ret = 0;
+
+	mutex_lock(&wl->mutex);
+
+	if (wl->state != WL1271_STATE_PLT) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if(wl->fuse_oui_addr == 0 && wl->fuse_nic_addr == 0) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	mac_addr[0] = (u8)(wl->fuse_oui_addr >> 16);
+	mac_addr[1] = (u8)(wl->fuse_oui_addr >> 8);
+	mac_addr[2] = (u8) wl->fuse_oui_addr;
+	mac_addr[3] = (u8)(wl->fuse_nic_addr >> 16);
+	mac_addr[4] = (u8)(wl->fuse_nic_addr >> 8);
+	mac_addr[5] = (u8) wl->fuse_nic_addr;
+
+	skb = cfg80211_testmode_alloc_reply_skb(wl->hw->wiphy, ETH_ALEN);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	NLA_PUT(skb, WL1271_TM_ATTR_DATA, ETH_ALEN, mac_addr);
+	ret = cfg80211_testmode_reply(skb);
+	if (ret < 0)
+		goto out;
+
+out:
+	mutex_unlock(&wl->mutex);
+	return ret;
+
+nla_put_failure:
+	kfree_skb(skb);
+	ret = -EMSGSIZE;
+	goto out;
+}
+
 int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len)
 {
 	struct wl1271 *wl = hw->priv;
@@ -288,6 +336,8 @@ int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len)
 		return wl1271_tm_cmd_set_plt_mode(wl, tb);
 	case WL1271_TM_CMD_RECOVER:
 		return wl1271_tm_cmd_recover(wl, tb);
+	case WL1271_TM_CMD_GET_MAC:
+		return wl12xx_tm_cmd_get_mac(wl, tb);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
1.7.4.1

