Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34242 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbZHFBqq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 21:46:46 -0400
Subject: Re: [PATCH] nl80211: fix attrtype and value for
 NL80211_ATTR_SUPPORTED_COMMANDS
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1249486901.6902.6.camel@johannes.local>
References: <1249464510-21539-1-git-send-email-yi.zhu@intel.com>
	 <1249486901.6902.6.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 09:46:46 +0800
Message-Id: <1249523206.4069.146.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-08-05 at 23:41 +0800, Johannes Berg wrote: 
> On Wed, 2009-08-05 at 17:28 +0800, Zhu Yi wrote:
> > The patch fixes the misuse between attrtype and value for the
> > CMD list nested in NL80211_ATTR_SUPPORTED_COMMANDS attribute.
> 
> No? It was this way intentionally.
> 
> > --- a/net/wireless/nl80211.c
> > +++ b/net/wireless/nl80211.c
> > @@ -520,7 +520,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
> >  	 do {							\
> >  		if (dev->ops->op) {				\
> >  			i++;					\
> > -			NLA_PUT_U32(msg, i, NL80211_CMD_ ## n);	\
> > +			NLA_PUT_U32(msg, NL80211_CMD_ ## n, i);	\
> 
> This is an array, the index doesn't matter, and the value is the
> supported command. You parse it with nla_for_each_nested()

I'm trying to find if a command (i.e. NL80211_CMD_CONNECT) is supported
or not. I think I can use nla_find_nested() if the command is an
attribute. But I can also do the find myself if it is an array like now.
So, never mind.

Thanks,
-yi

