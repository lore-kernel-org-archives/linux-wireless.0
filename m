Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:13808 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab3FGNgX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 09:36:23 -0400
Received: from 89-71-197-70.dynamic.chello.pl (HELO localhost.localdomain) (moorray3@[89.71.197.70])
          (envelope-sender <moorray3@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-wireless@vger.kernel.org>; 7 Jun 2013 15:36:21 +0200
From: Jakub Kicinski <moorray3@wp.pl>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	nietrywialneprzejscie@gmail.com
Subject: [RFC 4/5] mac80211: enforce address verification on monitors
Date: Fri,  7 Jun 2013 15:36:18 +0200
Message-Id: <1370612179-24385-5-git-send-email-moorray3@wp.pl> (sfid-20130607_153629_423623_95FAA740)
In-Reply-To: <1370612179-24385-1-git-send-email-moorray3@wp.pl>
References: <1370612179-24385-1-git-send-email-moorray3@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

Mac address of passive monitor have to treated
the same as address any other interface because
type of interface can be changed or monitor can
be later put into active mode.

Refusing to change interface type because of
mismatch in mac addresses would likely be
confusing to users.

This requirement only applies to hardware that
sets addr_mask and need to have all addresses
kept within it.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 net/mac80211/iface.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 1f26980..96bfafa 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -159,8 +159,7 @@ static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static int ieee80211_verify_mac(struct ieee80211_sub_if_data *sdata, u8 *addr,
-				bool check_dup)
+static int ieee80211_verify_mac(struct ieee80211_sub_if_data *sdata, u8 *addr)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sub_if_data *iter;
@@ -181,18 +180,11 @@ static int ieee80211_verify_mac(struct ieee80211_sub_if_data *sdata, u8 *addr,
 		((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
 		((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
 
-	if (!check_dup)
-		return ret;
-
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(iter, &local->interfaces, list) {
 		if (iter == sdata)
 			continue;
 
-		if (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
-		    !(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))
-			continue;
-
 		m = iter->vif.addr;
 		tmp =	((u64)m[0] << 5*8) | ((u64)m[1] << 4*8) |
 			((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
@@ -212,17 +204,12 @@ static int ieee80211_change_mac(struct net_device *dev, void *addr)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sockaddr *sa = addr;
-	bool check_dup = true;
 	int ret;
 
 	if (ieee80211_sdata_running(sdata))
 		return -EBUSY;
 
-	if (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
-	    !(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))
-		check_dup = false;
-
-	ret = ieee80211_verify_mac(sdata, sa->sa_data, check_dup);
+	ret = ieee80211_verify_mac(sdata, sa->sa_data);
 	if (ret)
 		return ret;
 
-- 
1.8.1.4

