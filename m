Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:60574 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759653AbZDRSxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 14:53:31 -0400
Date: Sat, 18 Apr 2009 21:53:15 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Make nl80211_send_mlme_event() atomic
Message-ID: <20090418185315.GA2334@jm.kir.nu> (sfid-20090418_205350_438971_35AD06B5)
References: <20090417200448.GA24430@jm.kir.nu> <20090417202752.GA27686@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090417202752.GA27686@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One of the code paths sending deauth/disassoc events ends up calling
this function with rcu_read_lock held, so we must use GFP_ATOMIC in
allocation routines.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/wireless/nl80211.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

(patch managed to modify incorrect function with some pending patches,
so there is some extra context here to make sure these changes end up
in nl80211_send_mlme_event() regardless of whether the other patches
are applied or not since this fix is needed for both 2.6.30 and
current wireless-testing.git)

--- uml.orig/net/wireless/nl80211.c	2009-04-17 23:05:47.000000000 +0300
+++ uml/net/wireless/nl80211.c	2009-04-18 21:38:40.000000000 +0300
@@ -3483,17 +3483,17 @@ nla_put_failure:
 static void nl80211_send_mlme_event(struct cfg80211_registered_device *rdev,
 				    struct net_device *netdev,
 				    const u8 *buf, size_t len,
 				    enum nl80211_commands cmd)
 {
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!msg)
 		return;
 
 	hdr = nl80211hdr_put(msg, 0, 0, 0, cmd);
 	if (!hdr) {
 		nlmsg_free(msg);
 		return;
 	}
@@ -3502,17 +3502,17 @@ static void nl80211_send_mlme_event(stru
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
 	NLA_PUT(msg, NL80211_ATTR_FRAME, len, buf);
 
 	if (genlmsg_end(msg, hdr) < 0) {
 		nlmsg_free(msg);
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, GFP_KERNEL);
+	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, GFP_ATOMIC);
 	return;
 
  nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 	nlmsg_free(msg);
 }
 
 void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,

-- 
Jouni Malinen                                            PGP id EFC895FA
