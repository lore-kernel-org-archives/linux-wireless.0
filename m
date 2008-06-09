Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:13312 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbYFIT2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 15:28:35 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2230439wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 12:28:35 -0700 (PDT)
Subject: [PATCHv2 7/8] mac80211: wme.c use new helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 12:28:23 -0700
Message-Id: <1213039703.5974.72.camel@brick> (sfid-20080609_212839_602294_89533935)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/wme.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 14a9ff1..d8c2f96 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -105,11 +105,8 @@ static int classify80211(struct sk_buff *skb, struct Qdisc *qd)
 {
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	unsigned short fc = le16_to_cpu(hdr->frame_control);
-	int qos;
 
-	/* see if frame is data or non data frame */
-	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)) {
+	if (!ieee80211_is_data(hdr->frame_control)) {
 		/* management frames go on AC_VO queue, but are sent
 		* without QoS control fields */
 		return 0;
@@ -119,10 +116,7 @@ static int classify80211(struct sk_buff *skb, struct Qdisc *qd)
 		/* use AC from radiotap */
 	}
 
-	/* is this a QoS frame? */
-	qos = fc & IEEE80211_STYPE_QOS_DATA;
-
-	if (!qos) {
+	if (!ieee80211_is_data_qos(hdr->frame_control)) {
 		skb->priority = 0; /* required for correct WPA/11i MIC */
 		return ieee802_1d_to_ac[skb->priority];
 	}
@@ -151,7 +145,6 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 	struct ieee80211_sched_data *q = qdisc_priv(qd);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	unsigned short fc = le16_to_cpu(hdr->frame_control);
 	struct Qdisc *qdisc;
 	struct sta_info *sta;
 	int err, queue;
@@ -185,16 +178,15 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 
 	/* now we know the 1d priority, fill in the QoS header if there is one
 	 */
-	if (WLAN_FC_IS_QOS_DATA(fc)) {
-		u8 *p = skb->data + ieee80211_get_hdrlen(fc) - 2;
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		u8 *p = ieee80211_get_qos_ctl(hdr);
 		u8 ack_policy = 0;
 		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
 		if (local->wifi_wme_noack_test)
 			ack_policy |= QOS_CONTROL_ACK_POLICY_NOACK <<
 					QOS_CONTROL_ACK_POLICY_SHIFT;
 		/* qos header is 2 bytes, second reserved */
-		*p = ack_policy | tid;
-		p++;
+		*p++ = ack_policy | tid;
 		*p = 0;
 
 		rcu_read_lock();
-- 
1.5.6.rc2.261.ga8fbe


