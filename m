Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28795 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754104AbbE1O2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 10:28:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4SEPMjd010930
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 07:28:30 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1unvy5s4p3-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 07:28:30 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCHv2 14/17] mwifiex: advertise PS ON by default support to cfg80211
Date: Fri, 29 May 2015 01:24:55 +0530
Message-ID: <1432842898-3219-15-git-send-email-patila@marvell.com> (sfid-20150528_162835_418699_CF31E27E)
In-Reply-To: <1432842898-3219-1-git-send-email-patila@marvell.com>
References: <1432842898-3219-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This would enable driver to enter powersave as soon as connected.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 1226555..3d3794f 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -3685,7 +3685,8 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
 			WIPHY_FLAG_AP_UAPSD |
 			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-			WIPHY_FLAG_HAS_CHANNEL_SWITCH;
+			WIPHY_FLAG_HAS_CHANNEL_SWITCH |
+			WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	if (ISSUPP_TDLS_ENABLED(adapter->fw_cap_info))
 		wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
-- 
1.8.1.4

