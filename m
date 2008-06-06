Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:6888 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbYFFSAD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 14:00:03 -0400
Received: by py-out-1112.google.com with SMTP id p76so875712pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2008 11:00:01 -0700 (PDT)
Subject: [PATCH 7/7] mac80211: wme.c use new helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 10:51:14 -0700
Message-Id: <1212774674.6340.81.camel@brick> (sfid-20080606_200007_978847_E0C562D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/wme.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 14a9ff1..7b27613 100644
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
+	if (!ieee80211_data_has_qos(hdr->frame_control)) {
 		skb->priority = 0; /* required for correct WPA/11i MIC */
 		return ieee802_1d_to_ac[skb->priority];
 	}
-- 
1.5.6.rc1.257.gba91d

