Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43394 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbaLBQHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 11:07:51 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH v2 02/10] wil6210: introduce wil_err_ratelimited()
Date: Tue, 2 Dec 2014 18:07:46 +0200
Message-ID: <1745741.h3nTIlTg0C@lx-wigig-72> (sfid-20141202_170755_189340_4D65B24D)
In-Reply-To: <1417532867.3365.1.camel@perches.com>
References: <1417440803-26883-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1417513598-18304-3-git-send-email-qca_vkondrat@qca.qualcomm.com> <1417532867.3365.1.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, December 02, 2014 07:07:47 AM Joe Perches wrote:
> net_<foo>_ratelimited uses the same form.
> 
> include/linux/net.h:#define net_ratelimited_function(function, ...)             
> include/linux/net.h-do {                                                        
> include/linux/net.h-    if (net_ratelimit())                                    
> include/linux/net.h-            function(__VA_ARGS__);                          
> include/linux/net.h-} while (0)
> 
Yes, I see. There are representatives of both "schools". As counter example,
netdev_<foo> uses "long" way:

#define define_netdev_printk_level(func, level)			\
void func(const struct net_device *dev, const char *fmt, ...)	\
{								\
	struct va_format vaf;					\
	va_list args;						\
								\
	va_start(args, fmt);					\
								\
	vaf.fmt = fmt;						\
	vaf.va = &args;						\
								\
	__netdev_printk(level, dev, &vaf);			\
								\
	va_end(args);						\
}								\
EXPORT_SYMBOL(func);

define_netdev_printk_level(netdev_emerg, KERN_EMERG);

Problem with "short" way, it is hard to detect usage with side effect.
Example from netfilter:
		if (dst_mtu(skb_dst(skb)) <= minlen) {
			net_err_ratelimited("unknown or invalid path-MTU (%u)\n",
					    dst_mtu(skb_dst(skb)));

Now, one need to remember that dst_mtu() can't have side effects.
I agree it is bad practice to have non-trivial arguments in printk-like functions,
but it is hard to detect, specifically if one just automatically replace function with its
"ratelimited" version.
