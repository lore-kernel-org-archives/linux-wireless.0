Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933087Ab1JNPMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 11:12:37 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1REjR6-0001Oo-Dh
	for linux-wireless@vger.kernel.org; Fri, 14 Oct 2011 17:12:36 +0200
Message-Id: <20111014151150.362870160@sipsolutions.net> (sfid-20111014_171239_412351_91A5AE07)
Date: Fri, 14 Oct 2011 17:11:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 02/12] mac80211: fix TID for null poll response
References: <20111014151119.246288840@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The queue mapping/TID for non-QoS null data
responses to is never set, making it default
to BK. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/mac80211/sta_info.c	2011-10-07 10:43:31.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-10-13 13:16:57.000000000 +0200
@@ -1203,11 +1203,9 @@ static void ieee80211_send_null_response
 	memcpy(nullfunc->addr2, sdata->vif.addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, sdata->vif.addr, ETH_ALEN);
 
+	skb->priority = tid;
+	skb_set_queue_mapping(skb, ieee802_1d_to_ac[tid]);
 	if (qos) {
-		skb->priority = tid;
-
-		skb_set_queue_mapping(skb, ieee802_1d_to_ac[tid]);
-
 		nullfunc->qos_ctrl = cpu_to_le16(tid);
 
 		if (reason == IEEE80211_FRAME_RELEASE_UAPSD)


