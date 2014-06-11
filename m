Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52180 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbaFKFAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 01:00:45 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so5031872wib.5
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 22:00:44 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org, mcgrof@do-not-panic.com,
	johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] cfg80211: reg: setup correct alpha2 after intersection
Date: Wed, 11 Jun 2014 07:00:35 +0200
Message-Id: <1402462835-3281-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140611_070049_521164_E0228DDE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Setup correct alfa2 in last request after intersection.
In other case after intersection we could not change/set
new country using eg. iw reg set

Failed scenario:
- insmod cfg80211.ko
- iw reg set FR
- modprobe ath10k_pci (US hint)
- intersection and country set as "98"
- no way to setup new country using iw reg set

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
@Luis I am not sure this is the best way to fix it, please review.

 net/wireless/reg.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 82948c8..8fd82b2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -271,6 +271,7 @@ static void reset_regdomains(bool full_reset,
 			     const struct ieee80211_regdomain *new_regdom)
 {
 	const struct ieee80211_regdomain *r;
+	struct regulatory_request *lr;
 
 	ASSERT_RTNL();
 
@@ -284,6 +285,12 @@ static void reset_regdomains(bool full_reset,
 	if (r == &world_regdom)
 		r = NULL;
 
+	lr = get_last_request();
+	if (lr && new_regdom) {
+		lr->alpha2[0] = new_regdom->alpha2[0];
+		lr->alpha2[1] = new_regdom->alpha2[1];
+	}
+
 	rcu_free_regdom(r);
 	rcu_free_regdom(cfg80211_world_regdom);
 
-- 
1.7.9.5

