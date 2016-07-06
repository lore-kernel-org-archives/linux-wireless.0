Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36098 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbcGFA3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 20:29:18 -0400
From: Masashi Honma <masashi.honma@gmail.com>
To: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-audit@redhat.com, cluster-devel@redhat.com
Cc: davem@davemloft.net, johannes@sipsolutions.net,
	pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
	dledford@redhat.com, sean.hefty@intel.com,
	hal.rosenstock@gmail.com, paul@paul-moore.com, eparis@redhat.com,
	zbr@ioremap.net, pshelar@nicira.com, ccaulfie@redhat.com,
	teigland@redhat.com, bsingharora@gmail.com,
	Masashi Honma <masashi.honma@gmail.com>
Subject: [RFC 3/7] netlink: Add allocation flag to nlmsg_unicast()
Date: Wed,  6 Jul 2016 09:28:32 +0900
Message-Id: <1467764916-4983-4-git-send-email-masashi.honma@gmail.com> (sfid-20160706_023103_250884_7F244319)
In-Reply-To: <1467764916-4983-1-git-send-email-masashi.honma@gmail.com>
References: <1467764916-4983-1-git-send-email-masashi.honma@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 crypto/crypto_user.c              |  3 ++-
 drivers/infiniband/core/netlink.c |  2 +-
 include/net/genetlink.h           |  2 +-
 include/net/netlink.h             |  6 ++++--
 net/core/rtnetlink.c              |  2 +-
 net/netfilter/nf_tables_api.c     | 10 +++++-----
 net/netlink/af_netlink.c          |  2 +-
 net/xfrm/xfrm_user.c              | 15 +++++++++------
 8 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 7097a33..f379b74 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -249,7 +249,8 @@ drop_alg:
 	if (err)
 		return err;
 
-	return nlmsg_unicast(crypto_nlsk, skb, NETLINK_CB(in_skb).portid);
+	return nlmsg_unicast(crypto_nlsk, skb, NETLINK_CB(in_skb).portid,
+			     GFP_ATOMIC);
 }
 
 static int crypto_dump_report(struct sk_buff *skb, struct netlink_callback *cb)
diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 9b8c20c..09037a9 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -229,7 +229,7 @@ static void ibnl_rcv(struct sk_buff *skb)
 int ibnl_unicast(struct sk_buff *skb, struct nlmsghdr *nlh,
 			__u32 pid)
 {
-	return nlmsg_unicast(nls, skb, pid);
+	return nlmsg_unicast(nls, skb, pid, gfp_any());
 }
 EXPORT_SYMBOL(ibnl_unicast);
 
diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 8d4608c..b107a35 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -334,7 +334,7 @@ int genlmsg_multicast_allns(struct genl_family *family,
  */
 static inline int genlmsg_unicast(struct net *net, struct sk_buff *skb, u32 portid)
 {
-	return nlmsg_unicast(net->genl_sock, skb, portid);
+	return nlmsg_unicast(net->genl_sock, skb, portid, 0);
 }
 
 /**
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 898e449..df5b533 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -585,12 +585,14 @@ static inline int nlmsg_multicast(struct sock *sk, struct sk_buff *skb,
  * @sk: netlink socket to spread message to
  * @skb: netlink message as socket buffer
  * @portid: netlink portid of the destination socket
+ * @flags: allocation flags
  */
-static inline int nlmsg_unicast(struct sock *sk, struct sk_buff *skb, u32 portid)
+static inline int nlmsg_unicast(struct sock *sk, struct sk_buff *skb,
+				u32 portid, gfp_t flags)
 {
 	int err;
 
-	err = netlink_unicast(sk, skb, portid, MSG_DONTWAIT, 0);
+	err = netlink_unicast(sk, skb, portid, MSG_DONTWAIT, flags);
 	if (err > 0)
 		err = 0;
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 3433633f..7f7927f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -657,7 +657,7 @@ int rtnl_unicast(struct sk_buff *skb, struct net *net, u32 pid)
 {
 	struct sock *rtnl = net->rtnl;
 
-	return nlmsg_unicast(rtnl, skb, pid);
+	return nlmsg_unicast(rtnl, skb, pid, gfp_any());
 }
 EXPORT_SYMBOL(rtnl_unicast);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2c88187..4afb751 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -581,7 +581,7 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
 	if (err < 0)
 		goto err;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid, GFP_KERNEL);
 
 err:
 	kfree_skb(skb2);
@@ -1144,7 +1144,7 @@ static int nf_tables_getchain(struct net *net, struct sock *nlsk,
 	if (err < 0)
 		goto err;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid, GFP_KERNEL);
 
 err:
 	kfree_skb(skb2);
@@ -1976,7 +1976,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 	if (err < 0)
 		goto err;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid, GFP_KERNEL);
 
 err:
 	kfree_skb(skb2);
@@ -2664,7 +2664,7 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
 	if (err < 0)
 		goto err;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid, GFP_KERNEL);
 
 err:
 	kfree_skb(skb2);
@@ -3798,7 +3798,7 @@ static int nf_tables_getgen(struct net *net, struct sock *nlsk,
 	if (err < 0)
 		goto err;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid, GFP_KERNEL);
 err:
 	kfree_skb(skb2);
 	return err;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index c68bf74..acc1ee6 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2328,7 +2328,7 @@ int nlmsg_notify(struct sock *sk, struct sk_buff *skb, u32 portid,
 	if (report) {
 		int err2;
 
-		err2 = nlmsg_unicast(sk, skb, portid);
+		err2 = nlmsg_unicast(sk, skb, portid, flags);
 		if (!err || err == -ESRCH)
 			err = err2;
 	}
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index d516845..4af9977 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1108,7 +1108,7 @@ static int xfrm_get_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (build_spdinfo(r_skb, net, sportid, seq, *flags) < 0)
 		BUG();
 
-	return nlmsg_unicast(net->xfrm.nlsk, r_skb, sportid);
+	return nlmsg_unicast(net->xfrm.nlsk, r_skb, sportid, GFP_ATOMIC);
 }
 
 static inline size_t xfrm_sadinfo_msgsize(void)
@@ -1166,7 +1166,7 @@ static int xfrm_get_sadinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (build_sadinfo(r_skb, net, sportid, seq, *flags) < 0)
 		BUG();
 
-	return nlmsg_unicast(net->xfrm.nlsk, r_skb, sportid);
+	return nlmsg_unicast(net->xfrm.nlsk, r_skb, sportid, GFP_ATOMIC);
 }
 
 static int xfrm_get_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -1186,7 +1186,8 @@ static int xfrm_get_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (IS_ERR(resp_skb)) {
 		err = PTR_ERR(resp_skb);
 	} else {
-		err = nlmsg_unicast(net->xfrm.nlsk, resp_skb, NETLINK_CB(skb).portid);
+		err = nlmsg_unicast(net->xfrm.nlsk, resp_skb,
+				    NETLINK_CB(skb).portid, GFP_ATOMIC);
 	}
 	xfrm_state_put(x);
 out_noput:
@@ -1244,7 +1245,8 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto out;
 	}
 
-	err = nlmsg_unicast(net->xfrm.nlsk, resp_skb, NETLINK_CB(skb).portid);
+	err = nlmsg_unicast(net->xfrm.nlsk, resp_skb, NETLINK_CB(skb).portid,
+			    GFP_ATOMIC);
 
 out:
 	xfrm_state_put(x);
@@ -1760,7 +1762,7 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 			err = PTR_ERR(resp_skb);
 		} else {
 			err = nlmsg_unicast(net->xfrm.nlsk, resp_skb,
-					    NETLINK_CB(skb).portid);
+					    NETLINK_CB(skb).portid, GFP_KERNEL);
 		}
 	} else {
 		xfrm_audit_policy_delete(xp, err ? 0 : 1, true);
@@ -1914,7 +1916,8 @@ static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	if (build_aevent(r_skb, x, &c) < 0)
 		BUG();
-	err = nlmsg_unicast(net->xfrm.nlsk, r_skb, NETLINK_CB(skb).portid);
+	err = nlmsg_unicast(net->xfrm.nlsk, r_skb, NETLINK_CB(skb).portid,
+			    GFP_ATOMIC);
 	spin_unlock_bh(&x->lock);
 	xfrm_state_put(x);
 	return err;
-- 
2.7.4

