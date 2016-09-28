Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50876 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932256AbcI1MuV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 08:50:21 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8SCnk2T022360
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 05:50:21 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 25r7vna8wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2016 05:50:20 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Karthik D A <karthida@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 8/8] mwifiex: fix p2p device doesn't find in scan problem
Date: Wed, 28 Sep 2016 18:18:28 +0530
Message-ID: <1475066908-11771-8-git-send-email-akarwar@marvell.com> (sfid-20160928_145024_579963_1C32E50F)
In-Reply-To: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
References: <1475066908-11771-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karthik D A <karthida@marvell.com>

Marvell p2p device disappears from the list of p2p peers on the other
p2p device after disconnection.

It happens due to a bug in driver. When interface is changed from p2p
to station, certain variables(bss_type, bss_role etc.) aren't correctly
updated. This patch corrects them to fix the issue.

Signed-off-by: Karthik D A <karthida@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index e83861f..d9f5445 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1203,6 +1203,12 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 			priv->adapter->curr_iface_comb.p2p_intf--;
 			priv->adapter->curr_iface_comb.sta_intf++;
 			dev->ieee80211_ptr->iftype = type;
+			if (mwifiex_deinit_priv_params(priv))
+				return -1;
+			if (mwifiex_init_new_priv_params(priv, dev, type))
+				return -1;
+			if (mwifiex_sta_init_cmd(priv, false, false))
+				return -1;
 			break;
 		case NL80211_IFTYPE_ADHOC:
 			if (mwifiex_cfg80211_deinit_p2p(priv))
-- 
1.9.1
