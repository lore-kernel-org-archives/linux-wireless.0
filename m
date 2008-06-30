Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757642AbYF3J1L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:11 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 16/33] mac80211: add beacon timestamp to beacon template in IBSS
Date: Mon, 30 Jun 2008 17:23:16 +0800
Message-Id: <1214817813-17639-17-git-send-email-yi.zhu@intel.com> (sfid-20080630_113812_822523_02465390)
In-Reply-To: <1214817813-17639-16-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-15-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-16-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This patch adds a beacon timestamp to the beacon template used in IBSS
mode. This way the underlying driver can update its TSF accordingly.
According the spec station should adopt the highest TSF from an incoming
beacons in the cell.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/mlme.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7b4d4d4..54228d9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2479,6 +2479,7 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
 		mgmt->u.beacon.beacon_int =
 			cpu_to_le16(local->hw.conf.beacon_int);
+		mgmt->u.beacon.timestamp = cpu_to_le64(bss->timestamp);
 		mgmt->u.beacon.capab_info = cpu_to_le16(bss->capability);
 
 		pos = skb_put(skb, 2 + ifsta->ssid_len);
-- 
1.5.3.6

