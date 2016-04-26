Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:55798 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbcDZIGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 04:06:41 -0400
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, sd@queasysnail.net, johannes@sipsolutions.net,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	jack@suse.com, linux-kernel@vger.kernel.org, pshelar@nicira.com,
	dev@openvswitch.org, jhs@mojatatu.com, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, drbd-dev@lists.linbit.com,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 3/8] fs/quota: use nla_put_u64_64bit()
Date: Tue, 26 Apr 2016 10:06:13 +0200
Message-Id: <1461657978-13360-4-git-send-email-nicolas.dichtel@6wind.com> (sfid-20160426_100935_669141_CB4A6ADF)
In-Reply-To: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
References: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 fs/quota/netlink.c         | 12 +++++++-----
 include/uapi/linux/quota.h |  1 +
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/quota/netlink.c b/fs/quota/netlink.c
index d07a2f91d858..8b252673d454 100644
--- a/fs/quota/netlink.c
+++ b/fs/quota/netlink.c
@@ -47,7 +47,7 @@ void quota_send_warning(struct kqid qid, dev_t dev,
 	void *msg_head;
 	int ret;
 	int msg_size = 4 * nla_total_size(sizeof(u32)) +
-		       2 * nla_total_size(sizeof(u64));
+		       2 * nla_total_size_64bit(sizeof(u64));
 
 	/* We have to allocate using GFP_NOFS as we are called from a
 	 * filesystem performing write and thus further recursion into
@@ -68,8 +68,9 @@ void quota_send_warning(struct kqid qid, dev_t dev,
 	ret = nla_put_u32(skb, QUOTA_NL_A_QTYPE, qid.type);
 	if (ret)
 		goto attr_err_out;
-	ret = nla_put_u64(skb, QUOTA_NL_A_EXCESS_ID,
-			  from_kqid_munged(&init_user_ns, qid));
+	ret = nla_put_u64_64bit(skb, QUOTA_NL_A_EXCESS_ID,
+				from_kqid_munged(&init_user_ns, qid),
+				QUOTA_NL_A_PAD);
 	if (ret)
 		goto attr_err_out;
 	ret = nla_put_u32(skb, QUOTA_NL_A_WARNING, warntype);
@@ -81,8 +82,9 @@ void quota_send_warning(struct kqid qid, dev_t dev,
 	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MINOR, MINOR(dev));
 	if (ret)
 		goto attr_err_out;
-	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID,
-			  from_kuid_munged(&init_user_ns, current_uid()));
+	ret = nla_put_u64_64bit(skb, QUOTA_NL_A_CAUSED_ID,
+				from_kuid_munged(&init_user_ns, current_uid()),
+				QUOTA_NL_A_PAD);
 	if (ret)
 		goto attr_err_out;
 	genlmsg_end(skb, msg_head);
diff --git a/include/uapi/linux/quota.h b/include/uapi/linux/quota.h
index 38baddb807f5..4d2489ef6f10 100644
--- a/include/uapi/linux/quota.h
+++ b/include/uapi/linux/quota.h
@@ -191,6 +191,7 @@ enum {
 	QUOTA_NL_A_DEV_MAJOR,
 	QUOTA_NL_A_DEV_MINOR,
 	QUOTA_NL_A_CAUSED_ID,
+	QUOTA_NL_A_PAD,
 	__QUOTA_NL_A_MAX,
 };
 #define QUOTA_NL_A_MAX (__QUOTA_NL_A_MAX - 1)
-- 
2.8.1

