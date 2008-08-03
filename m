Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:15066 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbYHCLcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 07:32:08 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: filter probes in ieee80211_rx_mgmt_probe_resp
Date: Sun,  3 Aug 2008 14:32:01 +0300
Message-Id: <1217763121-9057-1-git-send-email-tomas.winkler@intel.com> (sfid-20080803_133238_538135_AD2C8C3C)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves filtering statement from ieee80211_rx_bss_info
which is called for both beacon and probe to ieee80211_rx_mgmt_probe_resp
and save few cycles in beacon parsing.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5358420..0800385 100644
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
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

