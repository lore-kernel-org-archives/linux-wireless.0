Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35632 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752249AbbANKqr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 05:46:47 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0EAOBUv027959
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:46:47 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1rwj838p1h-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:46:46 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<gaoqs@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 03/10] mwifiex: update IEs after AP has started
Date: Wed, 14 Jan 2015 21:45:31 +0530
Message-ID: <1421252138-30157-4-git-send-email-patila@marvell.com> (sfid-20150114_114650_117765_7895E766)
In-Reply-To: <1421252138-30157-1-git-send-email-patila@marvell.com>
References: <1421252138-30157-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves IE management routine to end of start_ap handler.
IEs now would be updated after AP has started.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Qingshui Gao <gaoqs@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 9dde975..6143625 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1679,8 +1679,6 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 
 	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_UAP)
 		return -1;
-	if (mwifiex_set_mgmt_ies(priv, &params->beacon))
-		return -1;
 
 	bss_cfg = kzalloc(sizeof(struct mwifiex_uap_bss_param), GFP_KERNEL);
 	if (!bss_cfg)
@@ -1781,6 +1779,9 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		return -1;
 	}
 
+	if (mwifiex_set_mgmt_ies(priv, &params->beacon))
+		return -1;
+
 	memcpy(&priv->bss_cfg, bss_cfg, sizeof(priv->bss_cfg));
 	kfree(bss_cfg);
 
-- 
1.8.1.4

