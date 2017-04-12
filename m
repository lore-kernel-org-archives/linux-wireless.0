Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32916 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752224AbdDLNrM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 09:47:12 -0400
Received: by mail-wm0-f68.google.com with SMTP id o81so6532725wmb.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2017 06:47:12 -0700 (PDT)
Date: Wed, 12 Apr 2017 15:47:09 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>,
        David Ahern <dsa@cumulusnetworks.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH net-next v5 3/5] netlink: allow sending extended ACK with
 cookie on success
Message-ID: <20170412134709.GF1952@nanopsycho> (sfid-20170412_154717_029776_CAE42203)
References: <20170412123408.22012-1-johannes@sipsolutions.net>
 <20170412123408.22012-4-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170412123408.22012-4-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wed, Apr 12, 2017 at 02:34:06PM CEST, johannes@sipsolutions.net wrote:
>From: Johannes Berg <johannes.berg@intel.com>
>
>Now that we have extended error reporting and a new message format
>for netlink ACK messages, also extend this to be able to return
>arbitrary cookie data on success.
>
>This will allow, for example, nl80211 to not send an extra message
>for cookies identifying newly created objects, but return those
>directly in the ACK message.
>
>The cookie data size is currently limited to 20 bytes (since Jamal
>talked about using SHA1 for identifiers.)
>
>Thanks to Jamal Hadi Salim for bringing up this idea during the
>discussions.
>
>Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>

[...]

>diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
>index 7df88770e029..f86127a46cfc 100644
>--- a/include/uapi/linux/netlink.h
>+++ b/include/uapi/linux/netlink.h
>@@ -122,6 +122,9 @@ struct nlmsgerr {
>  * @NLMSGERR_ATTR_MSG: error message string (string)
>  * @NLMSGERR_ATTR_OFFS: offset of the invalid attribute in the original
>  *	 message, counting from the beginning of the header (u32)
>+ * @NLMSGERR_ATTR_COOKIE: arbitrary subsystem specific cookie to
>+ *	be used - in the success case - to identify a created
>+ *	object or operation or similar (binary)
>  * @__NLMSGERR_ATTR_MAX: number of attributes
>  * @NLMSGERR_ATTR_MAX: highest attribute number
>  */
>@@ -129,6 +132,7 @@ enum nlmsgerr_attrs {
> 	NLMSGERR_ATTR_UNUSED,
> 	NLMSGERR_ATTR_MSG,
> 	NLMSGERR_ATTR_OFFS,
>+	NLMSGERR_ATTR_COOKIE,
> 
> 	__NLMSGERR_ATTR_MAX,
> 	NLMSGERR_ATTR_MAX = __NLMSGERR_ATTR_MAX - 1
>diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
>index c1564768000e..ee841f00a6ec 100644
>--- a/net/netlink/af_netlink.c
>+++ b/net/netlink/af_netlink.c
>@@ -2311,6 +2311,10 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
> 		}
> 	} else {
> 		flags |= NLM_F_CAPPED;
>+
>+		if (nlk->flags & NETLINK_F_EXT_ACK &&
>+		    extack && extack->cookie_len)
>+			tlvlen += nla_total_size(extack->cookie_len);
> 	}
> 

Now I see why you have "if (tlvlen)" where you have it :)


> 	if (tlvlen)
