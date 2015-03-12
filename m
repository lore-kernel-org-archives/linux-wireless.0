Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30816 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209AbbCLI2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 04:28:06 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t2C8JGVW008846
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 01:27:45 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1t2q5a2hqm-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 01:27:45 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/3] mwifiex: Add support for auto ARP in mwifiex.
Date: Thu, 12 Mar 2015 00:38:39 -0700
Message-ID: <1426145920-5288-2-git-send-email-akarwar@marvell.com> (sfid-20150312_092813_059268_16B8A1E5)
In-Reply-To: <1426145920-5288-1-git-send-email-akarwar@marvell.com>
References: <1426145920-5288-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maithili Hinge <maithili@marvell.com>

This patch adds support for auto ARP feature in mwifiex.
The device will respond to ARP requests from the network
with ARP response in suspended state without waking up the host.
This feature is enabled in the driver by default.

Signed-off-by: Maithili Hinge <maithili@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 120 +++++++++++++++++++++++++-------
 drivers/net/wireless/mwifiex/fw.h       |   2 +
 drivers/net/wireless/mwifiex/main.h     |   1 +
 drivers/net/wireless/mwifiex/sta_cmd.c  |  21 ++++--
 4 files changed, 113 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 8e1f681..b0778a6 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2732,24 +2732,71 @@ mwifiex_is_pattern_supported(struct cfg80211_pkt_pattern *pat, s8 *byte_seq,
 }
 
 #ifdef CONFIG_PM
-static int mwifiex_set_mef_filter(struct mwifiex_private *priv,
-				  struct cfg80211_wowlan *wowlan)
+static void mwifiex_set_auto_arp_mef_entry(struct mwifiex_private *priv,
+					   struct mwifiex_mef_entry *mef_entry)
+{
+	int i, filt_num = 0, num_ipv4 = 0;
+	struct in_device *in_dev;
+	struct in_ifaddr *ifa;
+	__be32 ips[MWIFIEX_MAX_SUPPORTED_IPADDR];
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	mef_entry->mode = MEF_MODE_HOST_SLEEP;
+	mef_entry->action = MEF_ACTION_AUTO_ARP;
+
+	/* Enable ARP offload feature */
+	memset(ips, 0, sizeof(ips));
+	for (i = 0; i < MWIFIEX_MAX_BSS_NUM; i++) {
+		if (adapter->priv[i]->netdev) {
+			in_dev = __in_dev_get_rtnl(adapter->priv[i]->netdev);
+			if (!in_dev)
+				continue;
+			ifa = in_dev->ifa_list;
+			if (!ifa || !ifa->ifa_local)
+				continue;
+			ips[i] = ifa->ifa_local;
+			num_ipv4++;
+		}
+	}
+
+	for (i = 0; i < num_ipv4; i++) {
+		if (!ips[i])
+			continue;
+		mef_entry->filter[filt_num].repeat = 1;
+		memcpy(mef_entry->filter[filt_num].byte_seq,
+		       (u8 *)&ips[i], sizeof(ips[i]));
+		mef_entry->filter[filt_num].
+			byte_seq[MWIFIEX_MEF_MAX_BYTESEQ] =
+			sizeof(ips[i]);
+		mef_entry->filter[filt_num].offset = 46;
+		mef_entry->filter[filt_num].filt_type = TYPE_EQ;
+		if (filt_num) {
+			mef_entry->filter[filt_num].filt_action =
+				TYPE_OR;
+		}
+		filt_num++;
+	}
+
+	mef_entry->filter[filt_num].repeat = 1;
+	mef_entry->filter[filt_num].byte_seq[0] = 0x08;
+	mef_entry->filter[filt_num].byte_seq[1] = 0x06;
+	mef_entry->filter[filt_num].byte_seq[MWIFIEX_MEF_MAX_BYTESEQ] = 2;
+	mef_entry->filter[filt_num].offset = 20;
+	mef_entry->filter[filt_num].filt_type = TYPE_EQ;
+	mef_entry->filter[filt_num].filt_action = TYPE_AND;
+}
+
+static int mwifiex_set_wowlan_mef_entry(struct mwifiex_private *priv,
+					struct mwifiex_ds_mef_cfg *mef_cfg,
+					struct mwifiex_mef_entry *mef_entry,
+					struct cfg80211_wowlan *wowlan)
 {
 	int i, filt_num = 0, ret = 0;
 	bool first_pat = true;
 	u8 byte_seq[MWIFIEX_MEF_MAX_BYTESEQ + 1];
 	const u8 ipv4_mc_mac[] = {0x33, 0x33};
 	const u8 ipv6_mc_mac[] = {0x01, 0x00, 0x5e};
-	struct mwifiex_ds_mef_cfg mef_cfg;
-	struct mwifiex_mef_entry *mef_entry;
-
-	mef_entry = kzalloc(sizeof(*mef_entry), GFP_KERNEL);
-	if (!mef_entry)
-		return -ENOMEM;
 
-	memset(&mef_cfg, 0, sizeof(mef_cfg));
-	mef_cfg.num_entries = 1;
-	mef_cfg.mef_entry = mef_entry;
 	mef_entry->mode = MEF_MODE_HOST_SLEEP;
 	mef_entry->action = MEF_ACTION_ALLOW_AND_WAKEUP_HOST;
 
@@ -2766,20 +2813,19 @@ static int mwifiex_set_mef_filter(struct mwifiex_private *priv,
 		if (!wowlan->patterns[i].pkt_offset) {
 			if (!(byte_seq[0] & 0x01) &&
 			    (byte_seq[MWIFIEX_MEF_MAX_BYTESEQ] == 1)) {
-				mef_cfg.criteria |= MWIFIEX_CRITERIA_UNICAST;
+				mef_cfg->criteria |= MWIFIEX_CRITERIA_UNICAST;
 				continue;
 			} else if (is_broadcast_ether_addr(byte_seq)) {
-				mef_cfg.criteria |= MWIFIEX_CRITERIA_BROADCAST;
+				mef_cfg->criteria |= MWIFIEX_CRITERIA_BROADCAST;
 				continue;
 			} else if ((!memcmp(byte_seq, ipv4_mc_mac, 2) &&
 				    (byte_seq[MWIFIEX_MEF_MAX_BYTESEQ] == 2)) ||
 				   (!memcmp(byte_seq, ipv6_mc_mac, 3) &&
 				    (byte_seq[MWIFIEX_MEF_MAX_BYTESEQ] == 3))) {
-				mef_cfg.criteria |= MWIFIEX_CRITERIA_MULTICAST;
+				mef_cfg->criteria |= MWIFIEX_CRITERIA_MULTICAST;
 				continue;
 			}
 		}
-
 		mef_entry->filter[filt_num].repeat = 1;
 		mef_entry->filter[filt_num].offset =
 			wowlan->patterns[i].pkt_offset;
@@ -2796,7 +2842,7 @@ static int mwifiex_set_mef_filter(struct mwifiex_private *priv,
 	}
 
 	if (wowlan->magic_pkt) {
-		mef_cfg.criteria |= MWIFIEX_CRITERIA_UNICAST;
+		mef_cfg->criteria |= MWIFIEX_CRITERIA_UNICAST;
 		mef_entry->filter[filt_num].repeat = 16;
 		memcpy(mef_entry->filter[filt_num].byte_seq, priv->curr_addr,
 				ETH_ALEN);
@@ -2817,6 +2863,34 @@ static int mwifiex_set_mef_filter(struct mwifiex_private *priv,
 		mef_entry->filter[filt_num].filt_type = TYPE_EQ;
 		mef_entry->filter[filt_num].filt_action = TYPE_OR;
 	}
+	return ret;
+}
+
+static int mwifiex_set_mef_filter(struct mwifiex_private *priv,
+				  struct cfg80211_wowlan *wowlan)
+{
+	int ret = 0, num_entries = 1;
+	struct mwifiex_ds_mef_cfg mef_cfg;
+	struct mwifiex_mef_entry *mef_entry;
+
+	if (wowlan->n_patterns || wowlan->magic_pkt)
+		num_entries++;
+
+	mef_entry = kcalloc(num_entries, sizeof(*mef_entry), GFP_KERNEL);
+	if (!mef_entry)
+		return -ENOMEM;
+
+	memset(&mef_cfg, 0, sizeof(mef_cfg));
+	mef_cfg.criteria |= MWIFIEX_CRITERIA_BROADCAST |
+		MWIFIEX_CRITERIA_UNICAST;
+	mef_cfg.num_entries = num_entries;
+	mef_cfg.mef_entry = mef_entry;
+
+	mwifiex_set_auto_arp_mef_entry(priv, &mef_entry[0]);
+
+	if (wowlan->n_patterns || wowlan->magic_pkt)
+		ret = mwifiex_set_wowlan_mef_entry(priv, &mef_cfg,
+						   &mef_entry[1], wowlan);
 
 	if (!mef_cfg.criteria)
 		mef_cfg.criteria = MWIFIEX_CRITERIA_BROADCAST |
@@ -2824,8 +2898,8 @@ static int mwifiex_set_mef_filter(struct mwifiex_private *priv,
 			MWIFIEX_CRITERIA_MULTICAST;
 
 	ret = mwifiex_send_cmd(priv, HostCmd_CMD_MEF_CFG,
-			HostCmd_ACT_GEN_SET, 0, &mef_cfg, true);
-
+			HostCmd_ACT_GEN_SET, 0,
+			&mef_cfg, true);
 	kfree(mef_entry);
 	return ret;
 }
@@ -2850,12 +2924,10 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 		return 0;
 	}
 
-	if (wowlan->n_patterns || wowlan->magic_pkt) {
-		ret = mwifiex_set_mef_filter(priv, wowlan);
-		if (ret) {
-			dev_err(adapter->dev, "Failed to set MEF filter\n");
-			return ret;
-		}
+	ret = mwifiex_set_mef_filter(priv, wowlan);
+	if (ret) {
+		dev_err(adapter->dev, "Failed to set MEF filter\n");
+		return ret;
 	}
 
 	if (wowlan->disconnect) {
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index df553e8..21a942fd2 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -523,9 +523,11 @@ enum P2P_MODES {
 #define TYPE_OR				(MAX_OPERAND+5)
 #define MEF_MODE_HOST_SLEEP			1
 #define MEF_ACTION_ALLOW_AND_WAKEUP_HOST	3
+#define MEF_ACTION_AUTO_ARP                    0x10
 #define MWIFIEX_CRITERIA_BROADCAST	BIT(0)
 #define MWIFIEX_CRITERIA_UNICAST	BIT(1)
 #define MWIFIEX_CRITERIA_MULTICAST	BIT(3)
+#define MWIFIEX_MAX_SUPPORTED_IPADDR              4
 
 #define ACT_TDLS_DELETE            0x00
 #define ACT_TDLS_CREATE            0x01
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 16be45e..a0908c6 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -35,6 +35,7 @@
 #include <linux/ctype.h>
 #include <linux/of.h>
 #include <linux/idr.h>
+#include <linux/inetdevice.h>
 
 #include "decl.h"
 #include "ioctl.h"
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index f7d204f..b23eaed 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1370,22 +1370,29 @@ mwifiex_cmd_mef_cfg(struct mwifiex_private *priv,
 		    struct mwifiex_ds_mef_cfg *mef)
 {
 	struct host_cmd_ds_mef_cfg *mef_cfg = &cmd->params.mef_cfg;
+	struct mwifiex_fw_mef_entry *mef_entry = NULL;
 	u8 *pos = (u8 *)mef_cfg;
+	u16 i;
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_MEF_CFG);
 
 	mef_cfg->criteria = cpu_to_le32(mef->criteria);
 	mef_cfg->num_entries = cpu_to_le16(mef->num_entries);
 	pos += sizeof(*mef_cfg);
-	mef_cfg->mef_entry->mode = mef->mef_entry->mode;
-	mef_cfg->mef_entry->action = mef->mef_entry->action;
-	pos += sizeof(*(mef_cfg->mef_entry));
 
-	if (mwifiex_cmd_append_rpn_expression(priv, mef->mef_entry, &pos))
-		return -1;
+	for (i = 0; i < mef->num_entries; i++) {
+		mef_entry = (struct mwifiex_fw_mef_entry *)pos;
+		mef_entry->mode = mef->mef_entry[i].mode;
+		mef_entry->action = mef->mef_entry[i].action;
+		pos += sizeof(*mef_cfg->mef_entry);
+
+		if (mwifiex_cmd_append_rpn_expression(priv,
+						      &mef->mef_entry[i], &pos))
+			return -1;
 
-	mef_cfg->mef_entry->exprsize =
-			cpu_to_le16(pos - mef_cfg->mef_entry->expr);
+		mef_entry->exprsize =
+			cpu_to_le16(pos - mef_entry->expr);
+	}
 	cmd->size = cpu_to_le16((u16) (pos - (u8 *)mef_cfg) + S_DS_GEN);
 
 	return 0;
-- 
1.8.1.4

