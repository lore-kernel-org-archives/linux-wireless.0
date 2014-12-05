Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44845 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000AbaLEMYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2014 07:24:25 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 1/4] mwifiex: do not delete station entries in del_sta handler
Date: Fri, 5 Dec 2014 23:23:39 +0530
Message-ID: <1417802022-7364-1-git-send-email-patila@marvell.com> (sfid-20141205_132451_700597_19532DE6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A crash was observed while cfg80211 del_station handler is
called while stopping AP. This was happening because we were
deleting station list and Rx reorder table entries in del_sta
handler. While station entry is being deleted here, it may happen
that station deauth event from FW would also try to delete station
entry.

This patch fixes this crash by not deleting station entries in del_station
handler. Entry would be deleted while processing station deauth event; which
is triggered by del_station command to FW.

Reported by: Tim Shepard <shep@xplot.org>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index f881044..e111ff5 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1308,7 +1308,6 @@ mwifiex_cfg80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 					     HostCmd_ACT_GEN_SET, 0,
 					     sta_node->mac_addr, true))
 				return -1;
-			mwifiex_uap_del_sta_data(priv, sta_node);
 		}
 	} else {
 		wiphy_dbg(wiphy, "%s: mac address %pM\n", __func__,
@@ -1321,7 +1320,6 @@ mwifiex_cfg80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 					     HostCmd_ACT_GEN_SET, 0,
 					     sta_node->mac_addr, true))
 				return -1;
-			mwifiex_uap_del_sta_data(priv, sta_node);
 		}
 	}
 
-- 
1.8.1.4

