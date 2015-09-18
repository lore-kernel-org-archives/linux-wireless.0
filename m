Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5774 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474AbbIRNcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:32:46 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8IDPaEx031584
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:32:45 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 1wy3qm7eps-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:32:45 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 01/16] mwifiex: fix typo in del_virtual_intf() function
Date: Fri, 18 Sep 2015 06:32:03 -0700
Message-ID: <1442583138-2979-2-git-send-email-akarwar@marvell.com> (sfid-20150918_153248_929701_BC88B4E3)
In-Reply-To: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
References: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Interface counters should be incremented in add_virtual_intf()
and decremented in del_virtual_intf() function. This patch
corrects it.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 7e71dd7..4e06e98 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2862,14 +2862,14 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
-		adapter->curr_iface_comb.sta_intf++;
+		adapter->curr_iface_comb.sta_intf--;
 		break;
 	case NL80211_IFTYPE_AP:
-		adapter->curr_iface_comb.uap_intf++;
+		adapter->curr_iface_comb.uap_intf--;
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
-		adapter->curr_iface_comb.p2p_intf++;
+		adapter->curr_iface_comb.p2p_intf--;
 		break;
 	default:
 		mwifiex_dbg(adapter, ERROR,
-- 
1.8.1.4

