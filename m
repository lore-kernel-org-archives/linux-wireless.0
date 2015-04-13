Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56634 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753548AbbDMKcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 06:32:43 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t3DATZJK018763
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2015 03:32:42 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0a-0016f401.pphosted.com with ESMTP id 1tpw03vrpe-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2015 03:32:42 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 2/2] mwifiex: fix invalid HT IE configuration in FW
Date: Mon, 13 Apr 2015 21:32:25 +0530
Message-ID: <1428940945-4123-2-git-send-email-patila@marvell.com> (sfid-20150413_123246_650508_FEFB1460)
In-Reply-To: <1428940945-4123-1-git-send-email-patila@marvell.com>
References: <1428940945-4123-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch fixes an issue where it was discovered that driver is setting
invalid HT IEs to FW. This was happening because bug in parsing HT IE.
Driver would incorrectly point to start of HT IE while FW only needs actual
HT configuration - excluding EID and length.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_cmd.c | 2 +-
 drivers/net/wireless/mwifiex/util.c    | 7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index f5c2af0..3d02811 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -167,7 +167,7 @@ mwifiex_set_ht_params(struct mwifiex_private *priv,
 	ht_ie = cfg80211_find_ie(WLAN_EID_HT_CAPABILITY, params->beacon.tail,
 				 params->beacon.tail_len);
 	if (ht_ie) {
-		memcpy(&bss_cfg->ht_cap, ht_ie,
+		memcpy(&bss_cfg->ht_cap, ht_ie + 2,
 		       sizeof(struct ieee80211_ht_cap));
 		cap_info = le16_to_cpu(bss_cfg->ht_cap.cap_info);
 		memset(&bss_cfg->ht_cap.mcs, 0,
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index b8a4587..9482d95 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -536,13 +536,16 @@ void
 mwifiex_set_sta_ht_cap(struct mwifiex_private *priv, const u8 *ies,
 		       int ies_len, struct mwifiex_sta_node *node)
 {
+	struct ieee_types_header *ht_cap_ie;
 	const struct ieee80211_ht_cap *ht_cap;
 
 	if (!ies)
 		return;
 
-	ht_cap = (void *)cfg80211_find_ie(WLAN_EID_HT_CAPABILITY, ies, ies_len);
-	if (ht_cap) {
+	ht_cap_ie = (void *)cfg80211_find_ie(WLAN_EID_HT_CAPABILITY, ies,
+					     ies_len);
+	if (ht_cap_ie) {
+		ht_cap = (void *)(ht_cap_ie + 1);
 		node->is_11n_enabled = 1;
 		node->max_amsdu = le16_to_cpu(ht_cap->cap_info) &
 				  IEEE80211_HT_CAP_MAX_AMSDU ?
-- 
1.8.1.4

