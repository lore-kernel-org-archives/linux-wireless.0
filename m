Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54755 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885AbbFAMcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 08:32:48 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t51CT3k9017221
	for <linux-wireless@vger.kernel.org>; Mon, 1 Jun 2015 05:32:48 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1upunhwk2c-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 05:32:47 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCHv4 02/17] mwifiex: correct bss_type assignment
Date: Mon, 1 Jun 2015 23:32:00 +0530
Message-ID: <1433181735-15712-3-git-send-email-patila@marvell.com> (sfid-20150601_143251_392084_B7C3B54C)
In-Reply-To: <1433181735-15712-1-git-send-email-patila@marvell.com>
References: <1433181735-15712-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct bss_type assignment in add_virtual_interface.
This would ensure correct operation in multiple station scenarios.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 4eeceda..3a14d3a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2518,7 +2518,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		priv->frame_type = MWIFIEX_DATA_FRAME_TYPE_ETH_II;
 		priv->bss_priority = 0;
 		priv->bss_role = MWIFIEX_BSS_ROLE_STA;
-		priv->bss_num = 0;
+		priv->bss_num = adapter->curr_iface_comb.sta_intf;
 
 		break;
 	case NL80211_IFTYPE_AP:
@@ -2544,7 +2544,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		priv->bss_priority = 0;
 		priv->bss_role = MWIFIEX_BSS_ROLE_UAP;
 		priv->bss_started = 0;
-		priv->bss_num = 0;
+		priv->bss_num = adapter->curr_iface_comb.uap_intf;
 		priv->bss_mode = type;
 
 		break;
@@ -2580,7 +2580,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		priv->bss_priority = MWIFIEX_BSS_ROLE_STA;
 		priv->bss_role = MWIFIEX_BSS_ROLE_STA;
 		priv->bss_started = 0;
-		priv->bss_num = 0;
+		priv->bss_num = adapter->curr_iface_comb.p2p_intf;
 
 		if (mwifiex_cfg80211_init_p2p_client(priv)) {
 			memset(&priv->wdev, 0, sizeof(priv->wdev));
-- 
1.8.1.4

