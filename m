Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:55794 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbcDZIGk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 04:06:40 -0400
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, sd@queasysnail.net, johannes@sipsolutions.net,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	jack@suse.com, linux-kernel@vger.kernel.org, pshelar@nicira.com,
	dev@openvswitch.org, jhs@mojatatu.com, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, drbd-dev@lists.linbit.com,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 4/8] sock_diag: align nlattr properly when needed
Date: Tue, 26 Apr 2016 10:06:14 +0200
Message-Id: <1461657978-13360-5-git-send-email-nicolas.dichtel@6wind.com> (sfid-20160426_101112_112897_0CEBC9A7)
In-Reply-To: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
References: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I also fix the value of INET_DIAG_MAX. It's wrong since commit 8f840e47f190
which is only in net-next right now, thus I didn't make a separate patch.

Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/uapi/linux/inet_diag.h | 4 +++-
 net/core/sock_diag.c           | 2 +-
 net/ipv4/inet_diag.c           | 9 ++++++---
 net/sctp/sctp_diag.c           | 5 +++--
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index f5f3629dd553..a16643705669 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -115,9 +115,11 @@ enum {
 	INET_DIAG_SKV6ONLY,
 	INET_DIAG_LOCALS,
 	INET_DIAG_PEERS,
+	INET_DIAG_PAD,
+	__INET_DIAG_MAX,
 };
 
-#define INET_DIAG_MAX INET_DIAG_SKV6ONLY
+#define INET_DIAG_MAX (__INET_DIAG_MAX - 1)
 
 /* INET_DIAG_MEM */
 
diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index ca9e35bbe13c..6b10573cc9fa 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -120,7 +120,7 @@ static size_t sock_diag_nlmsg_size(void)
 {
 	return NLMSG_ALIGN(sizeof(struct inet_diag_msg)
 	       + nla_total_size(sizeof(u8)) /* INET_DIAG_PROTOCOL */
-	       + nla_total_size(sizeof(struct tcp_info))); /* INET_DIAG_INFO */
+	       + nla_total_size_64bit(sizeof(struct tcp_info))); /* INET_DIAG_INFO */
 }
 
 static void sock_diag_broadcast_destroy_work(struct work_struct *work)
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index ad7956fa659a..25af1243649b 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -220,8 +220,9 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 	}
 
 	if ((ext & (1 << (INET_DIAG_INFO - 1))) && handler->idiag_info_size) {
-		attr = nla_reserve(skb, INET_DIAG_INFO,
-				   handler->idiag_info_size);
+		attr = nla_reserve_64bit(skb, INET_DIAG_INFO,
+					 handler->idiag_info_size,
+					 INET_DIAG_PAD);
 		if (!attr)
 			goto errout;
 
@@ -1078,7 +1079,9 @@ int inet_diag_handler_get_info(struct sk_buff *skb, struct sock *sk)
 	}
 
 	attr = handler->idiag_info_size
-		? nla_reserve(skb, INET_DIAG_INFO, handler->idiag_info_size)
+		? nla_reserve_64bit(skb, INET_DIAG_INFO,
+				    handler->idiag_info_size,
+				    INET_DIAG_PAD)
 		: NULL;
 	if (attr)
 		info = nla_data(attr);
diff --git a/net/sctp/sctp_diag.c b/net/sctp/sctp_diag.c
index bb2d8d9608e9..84829fff3bc9 100644
--- a/net/sctp/sctp_diag.c
+++ b/net/sctp/sctp_diag.c
@@ -161,8 +161,9 @@ static int inet_sctp_diag_fill(struct sock *sk, struct sctp_association *asoc,
 	if (ext & (1 << (INET_DIAG_INFO - 1))) {
 		struct nlattr *attr;
 
-		attr = nla_reserve(skb, INET_DIAG_INFO,
-				   sizeof(struct sctp_info));
+		attr = nla_reserve_64bit(skb, INET_DIAG_INFO,
+					 sizeof(struct sctp_info),
+					 INET_DIAG_PAD);
 		if (!attr)
 			goto errout;
 
-- 
2.8.1

