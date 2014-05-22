Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:52460 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaEVNfb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 09:35:31 -0400
Received: by mail-ee0-f47.google.com with SMTP id c13so2684933eek.34
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 06:35:29 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] mac80211: use csa counter offsets instead of csa_active
Date: Thu, 22 May 2014 15:28:13 +0200
Message-Id: <1400765294-14732-3-git-send-email-michal.kazior@tieto.com> (sfid-20140522_153536_190657_6803D896)
In-Reply-To: <1400765294-14732-1-git-send-email-michal.kazior@tieto.com>
References: <1400765294-14732-1-git-send-email-michal.kazior@tieto.com>
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
index 7d96a27..eeeafeb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2536,6 +2536,9 @@ bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
 		goto out;
 	}
 
+	if (!beacon->csa_counter_offset[0])
+		goto out;
+
 	if (WARN_ON_ONCE(beacon->csa_counter_offset[0] > beacon_data_len))
 		goto out;
 
@@ -2580,7 +2583,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 
 		beacon = rcu_dereference(ap->beacon);
 		if (beacon) {
-			if (sdata->vif.csa_active) {
+			if (beacon->csa_counter_offset[0]) {
 				if (!is_template)
 					ieee80211_csa_update_counter(vif);
 
@@ -2626,7 +2629,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 		if (!beacon)
 			goto out;
 
-		if (sdata->vif.csa_active) {
+		if (beacon->csa_counter_offset[0]) {
 			if (!is_template)
 				ieee80211_csa_update_counter(vif);
 
@@ -2651,7 +2654,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 		if (!beacon)
 			goto out;
 
-		if (sdata->vif.csa_active) {
+		if (beacon->csa_counter_offset[0]) {
 			if (!is_template)
 				/* TODO: For mesh csa_counter is in TU, so
 				 * decrementing it by one isn't correct, but
-- 
1.8.5.3

