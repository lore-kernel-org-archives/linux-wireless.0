Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46103 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399AbbGPNa3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2015 09:30:29 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t6GDTSiH000974
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2015 06:30:29 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 1vnb4adar6-5
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2015 06:30:29 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Aniket Nagarnaik <aniketn@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/3] UPSTREAM: mwifiex: correct p2p and station interface counters
Date: Thu, 16 Jul 2015 06:27:29 -0700
Message-ID: <1437053249-18440-4-git-send-email-akarwar@marvell.com> (sfid-20150716_153032_463289_2BD195A4)
In-Reply-To: <1437053249-18440-1-git-send-email-akarwar@marvell.com>
References: <1437053249-18440-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aniket Nagarnaik <aniketn@marvell.com>

While changing interface type from p2p client or p2p go to
station, we should update counters for p2p interface and
station interface. Also calling mwifiex_cfg80211_deinit_p2p
method instead of mwifiex_cfg80211_init_p2p_client method to
deinit p2p interface.

Signed-off-by: Aniket Nagarnaik <aniketn@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index b15e4c7..b024015 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1115,8 +1115,10 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 	case NL80211_IFTYPE_P2P_GO:
 		switch (type) {
 		case NL80211_IFTYPE_STATION:
-			if (mwifiex_cfg80211_init_p2p_client(priv))
+			if (mwifiex_cfg80211_deinit_p2p(priv))
 				return -EFAULT;
+			priv->adapter->curr_iface_comb.p2p_intf--;
+			priv->adapter->curr_iface_comb.sta_intf++;
 			dev->ieee80211_ptr->iftype = type;
 			break;
 		case NL80211_IFTYPE_ADHOC:
-- 
1.8.1.4

