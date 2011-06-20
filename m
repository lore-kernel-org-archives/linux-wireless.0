Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37739 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1FTRvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 13:51:52 -0400
Received: by ywe9 with SMTP id 9so2175564ywe.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2011 10:51:52 -0700 (PDT)
From: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
	johannes@sipsolutions.net, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, Waldemar.Rymarkiewicz@tieto.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC][PATCH v2 1/7] netlink: advertise incomplete dumps
Date: Mon, 20 Jun 2011 14:50:06 -0300
Message-Id: <1308592212-5755-2-git-send-email-aloisio.almeida@openbossa.org> (sfid-20110620_195156_657605_85B56FC7)
In-Reply-To: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
References: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Consider the following situation:
 * a dump that would show 8 entries, four in the first
   round, and four in the second
 * between the first and second rounds, 6 entries are
   removed
 * now the second round will not show any entry, and
   even if there is a sequence/generation counter the
   application will not know

To solve this problem, add a new flag NLM_F_DUMP_INTR
to the netlink header that indicates the dump wasn't
consistent, this flag can also be set on the MSG_DONE
message that terminates the dump, and as such above
situation can be detected.

To achieve this, add a sequence counter to the netlink
callback struct. Of course, netlink code still needs
to use this new functionality. The correct way to do
that is to always set cb->seq when a dumpit callback
is invoked and call nl_dump_check_consistent() for
each new message. The core code will also call this
function for the final MSG_DONE message.

To make it usable with generic netlink, a new function
genlmsg_nlhdr() is needed to obtain the netlink header
from the genetlink user header.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/netlink.h  |    2 ++
 include/net/genetlink.h  |   32 ++++++++++++++++++++++++++++++++
 include/net/netlink.h    |   24 ++++++++++++++++++++++++
 net/netlink/af_netlink.c |    2 ++
 4 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 4c4ac3f..8d1bcec 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -48,6 +48,7 @@ struct nlmsghdr {
 #define NLM_F_MULTI		2	/* Multipart message, terminated by NLMSG_DONE */
 #define NLM_F_ACK		4	/* Reply with ack, with zero or error code */
 #define NLM_F_ECHO		8	/* Echo this request 		*/
+#define NLM_F_DUMP_INTR		16	/* Dump was inconsistent due to sequence change */
 
 /* Modifiers to GET request */
 #define NLM_F_ROOT	0x100	/* specify tree	root	*/
@@ -221,6 +222,7 @@ struct netlink_callback {
 					struct netlink_callback *cb);
 	int			(*done)(struct netlink_callback *cb);
 	int			family;
+	unsigned int		prev_seq, seq;
 	long			args[6];
 };
 
diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index d420f28..82d8d09 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -160,6 +160,38 @@ static inline void *genlmsg_put(struct sk_buff *skb, u32 pid, u32 seq,
 }
 
 /**
+ * genlmsg_nlhdr - Obtain netlink header from user specified header
+ * @user_hdr: user header as returned from genlmsg_put()
+ * @family: generic netlink family
+ *
+ * Returns pointer to netlink header.
+ */
+static inline struct nlmsghdr *genlmsg_nlhdr(void *user_hdr,
+					     struct genl_family *family)
+{
+	return (struct nlmsghdr *)((char *)user_hdr -
+				   family->hdrsize -
+				   GENL_HDRLEN -
+				   NLMSG_HDRLEN);
+}
+
+/**
+ * genl_dump_check_consistent - check if sequence is consistent and advertise if not
+ * @cb: netlink callback structure that stores the sequence number
+ * @user_hdr: user header as returned from genlmsg_put()
+ * @family: generic netlink family
+ *
+ * Cf. nl_dump_check_consistent(), this just provides a wrapper to make it
+ * simpler to use with generic netlink.
+ */
+static inline void genl_dump_check_consistent(struct netlink_callback *cb,
+					      void *user_hdr,
+					      struct genl_family *family)
+{
+	nl_dump_check_consistent(cb, genlmsg_nlhdr(user_hdr, family));
+}
+
+/**
  * genlmsg_put_reply - Add generic netlink header to a reply message
  * @skb: socket buffer holding the message
  * @info: receiver info
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 02740a9..98c1854 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -638,6 +638,30 @@ static inline int nlmsg_unicast(struct sock *sk, struct sk_buff *skb, u32 pid)
 	     nlmsg_ok(pos, rem); \
 	     pos = nlmsg_next(pos, &(rem)))
 
+/**
+ * nl_dump_check_consistent - check if sequence is consistent and advertise if not
+ * @cb: netlink callback structure that stores the sequence number
+ * @nlh: netlink message header to write the flag to
+ *
+ * This function checks if the sequence (generation) number changed during dump
+ * and if it did, advertises it in the netlink message header.
+ *
+ * The correct way to use it is to set cb->seq to the generation counter when
+ * all locks for dumping have been acquired, and then call this function for
+ * each message that is generated.
+ *
+ * Note that due to initialisation concerns, 0 is an invalid sequence number
+ * and must not be used by code that uses this functionality.
+ */
+static inline void
+nl_dump_check_consistent(struct netlink_callback *cb,
+			 struct nlmsghdr *nlh)
+{
+	if (cb->prev_seq && cb->seq != cb->prev_seq)
+		nlh->nlmsg_flags |= NLM_F_DUMP_INTR;
+	cb->prev_seq = cb->seq;
+}
+
 /**************************************************************************
  * Netlink Attributes
  **************************************************************************/
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 6ef64ad..a7ec851 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1693,6 +1693,8 @@ static int netlink_dump(struct sock *sk)
 	if (!nlh)
 		goto errout_skb;
 
+	nl_dump_check_consistent(cb, nlh);
+
 	memcpy(nlmsg_data(nlh), &len, sizeof(len));
 
 	if (sk_filter(sk, skb))
-- 
1.7.4.1

