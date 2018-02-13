Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53072 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753829AbeBMGK3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 01:10:29 -0500
From: Xinming Hu <huxm@marvell.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: set different mac address for interfaces with same bss type
Date: Tue, 13 Feb 2018 14:10:15 +0800
Message-ID: <1518502215-18820-1-git-send-email-huxm@marvell.com> (sfid-20180213_071033_702113_B52F07B5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Multiple interfaces with same bss type could affect each other if
they are sharing the same mac address. In this patch, different
mac address is assigned to new interface which have same bss type
with exist interfaces.

Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 24 +++++++++++++++++++-----
 drivers/net/wireless/marvell/mwifiex/main.h | 13 +++++++++++++
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 3dd8584..20737f5 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -960,13 +960,26 @@ int mwifiex_set_mac_address(struct mwifiex_private *priv,
 			    struct net_device *dev)
 {
 	int ret;
-	u64 mac_addr;
+	u64 mac_addr, old_mac_addr;
 
-	if (priv->bss_type != MWIFIEX_BSS_TYPE_P2P)
-		goto done;
+	if (priv->bss_type == MWIFIEX_BSS_TYPE_ANY)
+		return -ENOTSUPP;
 
 	mac_addr = ether_addr_to_u64(priv->curr_addr);
-	mac_addr |= BIT_ULL(MWIFIEX_MAC_LOCAL_ADMIN_BIT);
+	old_mac_addr = mac_addr;
+
+	if (priv->bss_type == MWIFIEX_BSS_TYPE_P2P)
+		mac_addr |= BIT_ULL(MWIFIEX_MAC_LOCAL_ADMIN_BIT);
+
+	if (mwifiex_get_intf_num(priv->adapter, priv->bss_type) > 1) {
+		/* Set mac address based on bss_type/bss_num */
+		mac_addr ^= BIT_ULL(priv->bss_type + 8);
+		mac_addr += priv->bss_num;
+	}
+
+	if (mac_addr == old_mac_addr)
+		goto done;
+
 	u64_to_ether_addr(mac_addr, priv->curr_addr);
 
 	/* Send request to firmware */
@@ -974,13 +987,14 @@ int mwifiex_set_mac_address(struct mwifiex_private *priv,
 			       HostCmd_ACT_GEN_SET, 0, NULL, true);
 
 	if (ret) {
+		u64_to_ether_addr(old_mac_addr, priv->curr_addr);
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "set mac address failed: ret=%d\n", ret);
 		return ret;
 	}
 
 done:
-	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
+	ether_addr_copy(dev->dev_addr, priv->curr_addr);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index c4c6918..f607d0b 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1276,6 +1276,19 @@ int mwifiex_cmd_802_11_bg_scan_config(struct mwifiex_private *priv,
 	return pos;
 }
 
+/* This function return interface number with the same bss_type.
+ */
+static inline u8
+mwifiex_get_intf_num(struct mwifiex_adapter *adapter, u8 bss_type)
+{
+	u8 i, num = 0;
+
+	for (i = 0; i < adapter->priv_num; i++)
+		if (adapter->priv[i] && adapter->priv[i]->bss_type == bss_type)
+			num++;
+	return num;
+}
+
 /*
  * This function returns the correct private structure pointer based
  * upon the BSS type and BSS number.
-- 
1.9.1
