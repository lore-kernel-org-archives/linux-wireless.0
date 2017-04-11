Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36386 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbdDKHTD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 03:19:03 -0400
Received: by mail-wm0-f67.google.com with SMTP id q125so13244870wmd.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Apr 2017 00:19:02 -0700 (PDT)
Date: Tue, 11 Apr 2017 09:19:00 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>,
        David Ahern <dsa@cumulusnetworks.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH net-next v4 1/5] netlink: extended ACK reporting
Message-ID: <20170411071900.GC1976@nanopsycho> (sfid-20170411_091939_954599_978F59E1)
References: <20170411065700.2623-1-johannes@sipsolutions.net>
 <20170411065700.2623-2-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170411065700.2623-2-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tue, Apr 11, 2017 at 08:56:56AM CEST, johannes@sipsolutions.net wrote:
>From: Johannes Berg <johannes.berg@intel.com>
>
>Add the base infrastructure and UAPI for netlink
>extended ACK reporting. All "manual" calls to
>netlink_ack() pass NULL for now and thus don't
>get extended ACK reporting.
>
>Big thanks goes to Pablo Neira Ayuso for not only
>bringing up the whole topic at netconf (again) but
>also coming up with the nlattr passing trick and
>various other ideads.
>
>Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>---

[...]


>+/**
>+ * enum nlmsgerr_attrs - nlmsgerr attributes
>+ * @NLMSGERR_ATTR_UNUSED: unused
>+ * @NLMSGERR_ATTR_MSG: error message string (string)
>+ * @NLMSGERR_ATTR_OFFS: offset of the invalid attribute in the original
>+ *	 message, counting from the beginning of the header (u32)
>+ * @NUM_NLMSGERR_ATTRS: number of attributes
>+ * @NLMSGERR_ATTR_MAX: highest attribute number
>+ */
>+enum nlmsgerr_attrs {
>+	NLMSGERR_ATTR_UNUSED,
>+	NLMSGERR_ATTR_MSG,
>+	NLMSGERR_ATTR_OFFS,
>+
>+	NUM_NLMSGERR_ATTRS,

According to the rest of the uapi, this should be rather named:
	__NLMSGERR_ATTR_MAX


>+	NLMSGERR_ATTR_MAX = NUM_NLMSGERR_ATTRS - 1
> };
> 
> #define NETLINK_ADD_MEMBERSHIP		1
>@@ -115,6 +146,7 @@ struct nlmsgerr {
> #define NETLINK_LISTEN_ALL_NSID		8
> #define NETLINK_LIST_MEMBERSHIPS	9
> #define NETLINK_CAP_ACK			10
>+#define NETLINK_EXT_ACK			11
> 
> struct nl_pktinfo {
> 	__u32	group;
>diff --git a/kernel/audit.c b/kernel/audit.c
>index 2f4964cfde0b..d54bf5932374 100644
>--- a/kernel/audit.c
>+++ b/kernel/audit.c
>@@ -1402,7 +1402,7 @@ static void audit_receive_skb(struct sk_buff *skb)
> 		err = audit_receive_msg(skb, nlh);
> 		/* if err or if this message says it wants a response */
> 		if (err || (nlh->nlmsg_flags & NLM_F_ACK))
>-			netlink_ack(skb, nlh, err);
>+			netlink_ack(skb, nlh, err, NULL);

Wouldn't it make sense to leave netlink_ack as is and add
netlink_ack_ext for those who need to pass non-null?


> 
> 		nlh = nlmsg_next(nlh, &len);
> 	}
