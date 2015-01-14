Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53875 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751862AbbANKq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 05:46:27 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0EAOPIw023688
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:46:26 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1rv520pv15-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:46:26 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<gaoqs@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 01/10] mwifiex: do not send regulatory update while starting AP
Date: Wed, 14 Jan 2015 21:45:29 +0530
Message-ID: <1421252138-30157-2-git-send-email-patila@marvell.com> (sfid-20150114_114629_867755_7624A662)
In-Reply-To: <1421252138-30157-1-git-send-email-patila@marvell.com>
References: <1421252138-30157-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When regulatory domain changes, cfg80211 already issues request
to change regulatory domain to driver via reg_notifier.
There is no need to set regulatory again during start_ap.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Qingshui Gao <gaoqs@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 56e50d6..85795f9 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1737,7 +1737,6 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		priv->adapter->config_bands = config_bands;
 
 	mwifiex_set_uap_rates(bss_cfg, params);
-	mwifiex_send_domain_info_cmd_fw(wiphy);
 
 	if (mwifiex_set_secure_params(priv, bss_cfg, params)) {
 		kfree(bss_cfg);
-- 
1.8.1.4

