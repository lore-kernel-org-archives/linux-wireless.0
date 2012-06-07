Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13608 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab2FGCnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 22:43:49 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <ath6kl-devel@qualcomm.com>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [RFC 2/2] mac80211: support rssi threshold scan
Date: Wed, 6 Jun 2012 19:43:16 -0700
Message-ID: <1339036996-6199-2-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120607_044353_672897_CABA159E)
In-Reply-To: <1339036996-6199-1-git-send-email-c_tpeder@qca.qualcomm.com>
References: <1339036996-6199-1-git-send-email-c_tpeder@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 net/mac80211/main.c |    3 +++
 net/mac80211/scan.c |    4 ++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index f5548e9..3f49d1b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -873,6 +873,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (local->hw.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS)
 		local->hw.wiphy->flags |= WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
 
+	if (local->hw.wiphy->signal_type == CFG80211_SIGNAL_TYPE_MBM)
+		local->hw.wiphy->flags |= WIPHY_FLAG_SUPPORTS_RSSI_SCAN;
+
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
 		goto fail_wiphy_register;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 8282284..1b92405 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -212,6 +212,10 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	if (baselen > skb->len)
 		return RX_DROP_MONITOR;
 
+	if (sdata->local->scan_req->rssi &&
+	    rx_status->signal < sdata->local->scan_req->rssi)
+		return RX_DROP_MONITOR;
+
 	ieee802_11_parse_elems(elements, skb->len - baselen, &elems);
 
 	if (elems.ds_params && elems.ds_params_len == 1)
-- 
1.7.4.1

