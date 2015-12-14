Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63912 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779AbbLNMRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:13 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBECGb8g027452
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:13 -0800
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 1yswmng01n-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:13 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Shengzhen Li <szli@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 01/14] mwifiex: change ap and station interface limits
Date: Mon, 14 Dec 2015 04:15:02 -0800
Message-ID: <1450095315-19927-2-git-send-email-akarwar@marvell.com> (sfid-20151214_131753_849827_1F9D8FFB)
In-Reply-To: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
References: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

ap/station interface limit has been changed to allow
creating maximum 3 interfaces.

Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 65dd85d..47d8afd 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -26,12 +26,10 @@ module_param(reg_alpha2, charp, 0);
 
 static const struct ieee80211_iface_limit mwifiex_ap_sta_limits[] = {
 	{
-		.max = 2, .types = BIT(NL80211_IFTYPE_STATION) |
+		.max = 3, .types = BIT(NL80211_IFTYPE_STATION) |
 				   BIT(NL80211_IFTYPE_P2P_GO) |
-				   BIT(NL80211_IFTYPE_P2P_CLIENT),
-	},
-	{
-		.max = 1, .types = BIT(NL80211_IFTYPE_AP),
+				   BIT(NL80211_IFTYPE_P2P_CLIENT) |
+				   BIT(NL80211_IFTYPE_AP),
 	},
 };
 
-- 
1.8.1.4

