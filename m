Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36067 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaFEM31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 08:29:27 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so3362114wib.7
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2014 05:29:26 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 2/2] mac80211: use csa counter offsets instead of csa_active
Date: Thu,  5 Jun 2014 14:21:37 +0200
Message-Id: <1401970897-21389-3-git-send-email-michal.kazior@tieto.com> (sfid-20140605_142932_664545_BDA6FBAA)
In-Reply-To: <1401970897-21389-1-git-send-email-michal.kazior@tieto.com>
References: <1401345535-22991-1-git-send-email-michal.kazior@tieto.com>
 <1401970897-21389-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vif->csa_active is protected by mutexes only. This
means it is unreliable to depend on it on codeflow
in non-sleepable beacon and CSA code. There was no
guarantee to have vif->csa_active update be
visible before beacons are updated on SMP systems.

Using csa counter offsets which are embedded in
beacon struct (and thus are protected with single
RCU assignment) is much safer.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/tx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ad5da6a..fc1da30 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2538,6 +2538,9 @@ bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
 		goto out;
 	}
 
+	if (!beacon->csa_counter_offsets[0])
+		goto out;
+
 	if (WARN_ON_ONCE(beacon->csa_counter_offsets[0] > beacon_data_len))
 		goto out;
 
@@ -2582,7 +2585,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 
 		beacon = rcu_dereference(ap->beacon);
 		if (beacon) {
-			if (sdata->vif.csa_active) {
+			if (beacon->csa_counter_offsets[0]) {
 				if (!is_template)
 					ieee80211_csa_update_counter(vif);
 
@@ -2628,7 +2631,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 		if (!beacon)
 			goto out;
 
-		if (sdata->vif.csa_active) {
+		if (beacon->csa_counter_offsets[0]) {
 			if (!is_template)
 				ieee80211_csa_update_counter(vif);
 
@@ -2653,7 +2656,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 		if (!beacon)
 			goto out;
 
-		if (sdata->vif.csa_active) {
+		if (beacon->csa_counter_offsets[0]) {
 			if (!is_template)
 				/* TODO: For mesh csa_counter is in TU, so
 				 * decrementing it by one isn't correct, but
-- 
1.8.5.3

