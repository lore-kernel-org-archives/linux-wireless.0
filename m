Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3G3UIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 16:08:32 -0400
Message-ID: <1375214899.8176.4.camel@jlt4.sipsolutions.net> (sfid-20130730_220849_379151_0B5CC1C0)
Subject: Re: Oops in nl80211_set_reg, Linux 3.10.3
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 30 Jul 2013 22:08:19 +0200
In-Reply-To: <1375211931.2664.21.camel@deadeye.wl.decadent.org.uk> (sfid-20130730_211910_708043_1782E991)
References: <1375211931.2664.21.camel@deadeye.wl.decadent.org.uk>
	 (sfid-20130730_211910_708043_1782E991)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-07-30 at 21:18 +0200, Ben Hutchings wrote:

> 	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
> 			    rem_reg_rules) {
>     f703:       49 8b 46 20             mov    0x20(%r14),%rax     info->attrs
>     f707:       45 31 e4                xor    %r12d,%r12d
>     f70a:       48 8b 80 10 01 00 00    mov    0x110(%rax),%rax    info->attrs[NL80211_ATTR_REG_RULES]
>     f711:       48 8d 68 04             lea    0x4(%rax),%rbp
> *   f715:       0f b7 00                movzwl (%rax),%eax         info->attrs[NL80211_ATTR_REG_RULES]->nla_len
> 
> So info->attrs[NL80211_ATTR_REG_RULES] == NULL.  But the function
> already checked that it wasn't!  So I don't know what's going on - could
> be a memory corruption completely unrelated to nl80211.

Hmm. Linus ran into a similar issue, but I thought that was fixed by
3a5a423bb958ad22eeccca66c533e85bf69ba10e ("nl80211: fix attrbuf access
race by allocating a separate one"), which went into 3.10.

I don't see a similar issue with the other code that uses
nl80211_fam.attrbuf, so I'm not sure what could be causing it in your
case. It seems more likely to have been something like this than random
memory corruption though.

johannes

