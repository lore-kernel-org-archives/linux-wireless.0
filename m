Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14143 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965057AbbA1Eyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 23:54:49 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0S4o6ZW024539
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:54:48 -0800
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1s50eqxb50-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:54:48 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <gaoqs@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 01/10] mwifiex: do not send regulatory update while starting AP
Date: Wed, 28 Jan 2015 15:54:16 +0530
Message-ID: <1422440665-3940-2-git-send-email-patila@marvell.com> (sfid-20150128_055454_349953_E7226672)
In-Reply-To: <1422440665-3940-1-git-send-email-patila@marvell.com>
References: <1422440665-3940-1-git-send-email-patila@marvell.com>
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
index 30ea94a..1acccc5 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1739,7 +1739,6 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		priv->adapter->config_bands = config_bands;
 
 	mwifiex_set_uap_rates(bss_cfg, params);
-	mwifiex_send_domain_info_cmd_fw(wiphy);
 
 	if (mwifiex_set_secure_params(priv, bss_cfg, params)) {
 		kfree(bss_cfg);
-- 
1.8.1.4

