Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33714 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbeCUJyJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 05:54:09 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Caradoc-Davies <ben@transient.nz>
Subject: [PATCH v4] mac80211: add ieee80211_hw flag for QoS NDP support
Date: Wed, 21 Mar 2018 10:54:06 +0100
Message-Id: <20180321095406.23974-1-johannes@sipsolutions.net> (sfid-20180321_105412_271010_C76AAC62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Caradoc-Davies <ben@transient.nz>

Commit 7b6ddeaf27ec ("mac80211: use QoS NDP for AP probing") added an
argument qos_ok to ieee80211_nullfunc_get to support QoS NDP. Despite
the claim in the commit log "Change all the drivers to *not* allow
QoS NDP for now, even though it looks like most of them should be OK
with that", this commit enables QoS NDP in response to beacons (see
change to mlme.c:ieee80211_send_nullfunc), causing ath9k_htc to lose
IP connectivity. See:
https://patchwork.kernel.org/patch/10241109/
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=891060

Introduce a hardware flag to allow such buggy drivers to override the
correct default behaviour of mac80211 of sending QoS NDP packets.

Signed-off-by: Ben Caradoc-Davies <ben@transient.nz>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 4 ++++
 net/mac80211/debugfs.c | 1 +
 net/mac80211/mlme.c    | 3 ++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c96511fa9198..2b581bd93812 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2063,6 +2063,9 @@ struct ieee80211_txq {
  * @IEEE80211_HW_SUPPORTS_TDLS_BUFFER_STA: Hardware supports buffer STA on
  *	TDLS links.
  *
+ * @IEEE80211_HW_DOESNT_SUPPORT_QOS_NDP: The driver (or firmware) doesn't
+ *	support QoS NDP for AP probing - that's most likely a driver bug.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2106,6 +2109,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_REPORTS_LOW_ACK,
 	IEEE80211_HW_SUPPORTS_TX_FRAG,
 	IEEE80211_HW_SUPPORTS_TDLS_BUFFER_STA,
+	IEEE80211_HW_DOESNT_SUPPORT_QOS_NDP,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 1f466d12a6bc..94c7ee9df33b 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -212,6 +212,7 @@ static const char *hw_flag_names[] = {
 	FLAG(REPORTS_LOW_ACK),
 	FLAG(SUPPORTS_TX_FRAG),
 	FLAG(SUPPORTS_TDLS_BUFFER_STA),
+	FLAG(DOESNT_SUPPORT_QOS_NDP),
 #undef FLAG
 };
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 39b660b9a908..5f303abac5ad 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -896,7 +896,8 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 	struct ieee80211_hdr_3addr *nullfunc;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif, true);
+	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif,
+		!ieee80211_hw_check(&local->hw, DOESNT_SUPPORT_QOS_NDP));
 	if (!skb)
 		return;
 
-- 
2.15.1
