Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbYHOCEu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 22:04:50 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 07/15] mac80211: filter probes in ieee80211_rx_mgmt_probe_resp
Date: Fri, 15 Aug 2008 10:01:12 +0800
Message-Id: <1218765680-8378-8-git-send-email-yi.zhu@intel.com> (sfid-20080815_040454_272850_F29BD062)
In-Reply-To: <1218765680-8378-7-git-send-email-yi.zhu@intel.com>
References: <1218765680-8378-1-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-2-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-3-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-4-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-5-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-6-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves filtering statement from ieee80211_rx_bss_info
which is called for both beacon and probe to
ieee80211_rx_mgmt_probe_resp and save few cycles in beacon parsing.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/mlme.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e1d11c9..af61416 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2570,9 +2570,6 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
 
-	if (!beacon && memcmp(mgmt->da, dev->dev_addr, ETH_ALEN))
-		return; /* ignore ProbeResp to foreign address */
-
 	beacon_timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif) && elems->mesh_id &&
@@ -2890,6 +2887,9 @@ static void ieee80211_rx_mgmt_probe_resp(struct net_device *dev,
 	size_t baselen;
 	struct ieee802_11_elems elems;
 
+	if (memcmp(mgmt->da, dev->dev_addr, ETH_ALEN))
+		return; /* ignore ProbeResp to foreign address */
+
 	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
 	if (baselen > len)
 		return;
-- 
1.5.3.6

