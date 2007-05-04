Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:14945 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767568AbXEDBES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2007 21:04:18 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH v2] mac80211: prevent a wme_qdiscop_init BUG on other devices
Date: Thu, 03 May 2007 21:02:31 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070504010231.5274.99328.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This prevents a BUG if the ieee80211 qdisc is being registered on a net dev
without ieee80211_ptr set. It also ensures the device is a mac80211 device.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/wme.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 3823f15..89ce815 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -389,10 +389,15 @@ static int wme_qdiscop_init(struct Qdisc *qd, struct rtattr *opt)
 {
 	struct ieee80211_sched_data *q = qdisc_priv(qd);
 	struct net_device *dev = qd->dev;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	int queues = local->hw.queues;
+	struct ieee80211_local *local;
+	int queues;
 	int err = 0, i;
 
+	/* check that device is a mac80211 device */
+	if (!dev->ieee80211_ptr ||
+	    dev->ieee80211_ptr->wiphy->privid != mac80211_wiphy_privid)
+		return -EINVAL;
+
 	/* check this device is an ieee80211 master type device */
 	if (dev->type != ARPHRD_IEEE80211)
 		return -EINVAL;
@@ -406,6 +411,9 @@ static int wme_qdiscop_init(struct Qdisc *qd, struct rtattr *opt)
 	if (qd->flags & TCQ_F_INGRESS)
 		return -EINVAL;
 
+	local = wdev_priv(dev->ieee80211_ptr);
+	queues = local->hw.queues;
+
 	/* if options were passed in, set them */
 	if (opt) {
 		err = wme_qdiscop_tune(qd, opt);

