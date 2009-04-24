Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbZDXNiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 09:38:06 -0400
Subject: [PATCH] mac80211: fix probe response processing
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>
Content-Type: text/plain
Date: Fri, 24 Apr 2009 15:15:25 +0200
Message-Id: <1240578925.18031.37.camel@johannes.local> (sfid-20090424_153809_964238_E82B0EB1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to the use of a _REQ_DIRECT_PROBE bit, which is
unnecessary (and I wonder why it was done that way),
an interesting situation can arise:
 1) we try to probe an access point
 2) the AP doesn't response in time
 3) we tell userspace that we gave up
 4) the AP suddenly responds
 5) we auth/assoc with the AP

I've seen 4) happen in testing with hostapd SIGSTOPped,
and when SIGCONTinued it processes the probe requests
that came in and send responses. But 5) is not supposed
to happen after we tell everybody we've given up on the
AP.

To fix this, remove the _REQ_DIRECT_PROBE request bit,
and process probe responses when we're in the relevant
MLME state, namely IEEE80211_STA_MLME_DIRECT_PROBE.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    5 ++---
 net/mac80211/mlme.c        |    5 +----
 2 files changed, 3 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-24 14:56:54.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-24 14:57:10.000000000 +0200
@@ -915,8 +915,6 @@ static void ieee80211_direct_probe(struc
 
 	ifmgd->state = IEEE80211_STA_MLME_DIRECT_PROBE;
 
-	set_bit(IEEE80211_STA_REQ_DIRECT_PROBE, &ifmgd->request);
-
 	/* Direct probe is sent to broadcast address as some APs
 	 * will not answer to direct packet in unassociated state.
 	 */
@@ -1738,8 +1736,7 @@ static void ieee80211_rx_mgmt_probe_resp
 	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, false);
 
 	/* direct probe may be part of the association flow */
-	if (test_and_clear_bit(IEEE80211_STA_REQ_DIRECT_PROBE,
-			       &ifmgd->request)) {
+	if (ifmgd->state == IEEE80211_STA_MLME_DIRECT_PROBE) {
 		printk(KERN_DEBUG "%s direct probe responded\n",
 		       sdata->dev->name);
 		ieee80211_authenticate(sdata);
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-04-24 14:56:54.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-04-24 14:57:10.000000000 +0200
@@ -248,9 +248,8 @@ struct mesh_preq_queue {
 #define IEEE80211_STA_EXT_SME		BIT(17)
 /* flags for MLME request */
 #define IEEE80211_STA_REQ_SCAN 0
-#define IEEE80211_STA_REQ_DIRECT_PROBE 1
-#define IEEE80211_STA_REQ_AUTH 2
-#define IEEE80211_STA_REQ_RUN  3
+#define IEEE80211_STA_REQ_AUTH 1
+#define IEEE80211_STA_REQ_RUN  2
 
 /* bitfield of allowed auth algs */
 #define IEEE80211_AUTH_ALG_OPEN BIT(0)


