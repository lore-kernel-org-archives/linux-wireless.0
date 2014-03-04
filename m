Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31846 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168AbaCDOwu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 09:52:50 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] mac80211: ignore probe response from adjacent channels
Date: Tue,  4 Mar 2014 16:50:14 +0200
Message-Id: <1393944614-4465-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140304_155254_012164_F343CB52)
In-Reply-To: <1393944614-4465-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1393944614-4465-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This logic is already implemented in ieee80211_rx_mgmt_beacon.
The purpose is to ignore probe responses that are received
on adjacent channels. This can happen in 2.4GHz since
channels overlap.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e3f71b0..d982d61 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2805,6 +2805,7 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 					 struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_if_managed *ifmgd;
 	struct ieee80211_rx_status *rx_status = (void *) skb->cb;
 	size_t baselen, len = skb->len;
@@ -2814,6 +2815,19 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 
 	sdata_assert_lock(sdata);
 
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (!chanctx_conf) {
+		rcu_read_unlock();
+		return;
+	}
+
+	if (rx_status->freq != chanctx_conf->def.chan->center_freq) {
+		rcu_read_unlock();
+		return;
+	}
+	rcu_read_unlock();
+
 	if (!ether_addr_equal(mgmt->da, sdata->vif.addr))
 		return; /* ignore ProbeResp to foreign address */
 
-- 
1.8.3.2

