Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36027 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750816AbcIIO4n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 10:56:43 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u89EtA03027843
        for <linux-wireless@vger.kernel.org>; Fri, 9 Sep 2016 07:56:41 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 25bd9g5ust-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Fri, 09 Sep 2016 07:56:41 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: correction in Rx STBC field of htcapinfo
Date: Fri, 9 Sep 2016 20:26:19 +0530
Message-ID: <1473432979-16554-1-git-send-email-akarwar@marvell.com> (sfid-20160909_165704_685169_6FECEB6B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently Rx STBC in assoc request frame is advertised as 3. It should
be 2, as our chipsets support two spatial streams.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 33e7a74..7a9b431 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2756,7 +2756,7 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 		ht_info->cap &= ~IEEE80211_HT_CAP_SGI_40;
 
 	if (adapter->user_dev_mcs_support == HT_STREAM_2X2)
-		ht_info->cap |= 3 << IEEE80211_HT_CAP_RX_STBC_SHIFT;
+		ht_info->cap |= 2 << IEEE80211_HT_CAP_RX_STBC_SHIFT;
 	else
 		ht_info->cap |= 1 << IEEE80211_HT_CAP_RX_STBC_SHIFT;
 
-- 
1.9.1
