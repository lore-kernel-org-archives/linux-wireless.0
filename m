Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19642 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752879AbbLNMR0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:26 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBECGeuj027459
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:26 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 1yswmng02a-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:26 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	chunfan chen <jeffc@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 11/14] mwifiex: fix wake on disconnect feature
Date: Mon, 14 Dec 2015 04:15:12 -0800
Message-ID: <1450095315-19927-12-git-send-email-akarwar@marvell.com> (sfid-20151214_131743_243203_7160F993)
In-Reply-To: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
References: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: chunfan chen <jeffc@marvell.com>

Default gpio and gap is downloaded to firmware while
configuring host sleep for wake on disconnect. We may
have gpio and gap modified by user.

This patch fixes the problem.

Signed-off-by: chunfan chen <jeffc@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index f7c26d6..e7adef7 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3159,8 +3159,8 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 		memset(&hs_cfg, 0, sizeof(hs_cfg));
 		hs_cfg.is_invoke_hostcmd = false;
 		hs_cfg.conditions = HS_CFG_COND_MAC_EVENT;
-		hs_cfg.gpio = HS_CFG_GPIO_DEF;
-		hs_cfg.gap = HS_CFG_GAP_DEF;
+		hs_cfg.gpio = adapter->hs_cfg.gpio;
+		hs_cfg.gap = adapter->hs_cfg.gap;
 		ret = mwifiex_set_hs_params(priv, HostCmd_ACT_GEN_SET,
 					    MWIFIEX_SYNC_CMD, &hs_cfg);
 		if (ret) {
-- 
1.8.1.4

