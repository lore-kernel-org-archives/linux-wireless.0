Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46164 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751376AbdJPO5w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 10:57:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: "Eric W . Biederman" <ebiederman@twitter.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] netlink: use NETLINK_CB(in_skb).sk instead of looking it up
Date: Mon, 16 Oct 2017 16:57:49 +0200
Message-Id: <20171016145749.31793-1-johannes@sipsolutions.net> (sfid-20171016_165759_627527_3313888C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When netlink_ack() reports an allocation error to the sending
socket, there's no need to look up the sending socket since
it's available in the SKB's CB. Use that instead of going to
the trouble of looking it up.

Note that the pointer is only available since Eric Biederman's
commit 3fbc290540a1 ("netlink: Make the sending netlink socket availabe in NETLINK_CB")
which is far newer than the original lookup code (Oct 2003)
(though the field was called 'ssk' in that commit and only got
renamed to 'sk' later, I'd actually argue 'ssk' was better - or
perhaps it should've been 'source_sk' - since there are so many
different 'sk's involved.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/netlink/af_netlink.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index f34750691c5c..336d9c6dcad9 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2336,16 +2336,8 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 
 	skb = nlmsg_new(payload + tlvlen, GFP_KERNEL);
 	if (!skb) {
-		struct sock *sk;
-
-		sk = netlink_lookup(sock_net(in_skb->sk),
-				    in_skb->sk->sk_protocol,
-				    NETLINK_CB(in_skb).portid);
-		if (sk) {
-			sk->sk_err = ENOBUFS;
-			sk->sk_error_report(sk);
-			sock_put(sk);
-		}
+		NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
+		NETLINK_CB(in_skb).sk->sk_error_report(NETLINK_CB(in_skb).sk);
 		return;
 	}
 
-- 
2.14.2
