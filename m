Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48955 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511AbbFCGAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 02:00:49 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t535xbHX028287
	for <linux-wireless@vger.kernel.org>; Tue, 2 Jun 2015 23:00:48 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1usqkvgguf-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2015 23:00:48 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCHv5 05/17] mwifiex: reset 11h active flag when chandef does not require dfs
Date: Wed, 3 Jun 2015 16:59:35 +0530
Message-ID: <1433330987-6808-6-git-send-email-patila@marvell.com> (sfid-20150603_080052_363550_AEEF1757)
In-Reply-To: <1433330987-6808-1-git-send-email-patila@marvell.com>
References: <1433330987-6808-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes an issue where we were still setting 11h_active
flag to true for channel defs where DFS is not required.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index d47799a..fb93e13 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1820,7 +1820,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 				    "Failed to disable 11h extensions!!");
 			return -1;
 		}
-		priv->state_11h.is_11h_active = true;
+		priv->state_11h.is_11h_active = false;
 	}
 
 	if (mwifiex_config_start_uap(priv, bss_cfg)) {
-- 
1.8.1.4

