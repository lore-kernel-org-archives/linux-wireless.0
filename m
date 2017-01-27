Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0211.hostedemail.com ([216.40.44.211]:34887 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750825AbdA0Tso (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 14:48:44 -0500
Message-ID: <1485546515.12563.138.camel@perches.com> (sfid-20170127_204904_039581_317673A6)
Subject: Re: [PATCH] cfg80211 debugfs: Cleanup some checkpatch issues
From: Joe Perches <joe@perches.com>
To: Pichugin Dmitry <smokeman85@gmail.com>, johannes@sipsolutions.net,
        davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Jan 2017 11:48:35 -0800
In-Reply-To: <20170127192603.GA13522@gmail.com>
References: <20170127192603.GA13522@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-01-27 at 22:26 +0300, Pichugin Dmitry wrote:
> This fixes the checkpatch.pl warnings:
> * Macros should not use a trailing semicolon.
> * Spaces required around that '='.
> * Symbolic permissions 'S_IRUGO' are not preferred.

OK

> * Macro argument reuse 'buflen' - possible side-effects

Not all checkpatch messages need fixing.
This is one of them.

> diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
[]
> @@ -17,11 +17,12 @@
>  static ssize_t name## _read(struct file *file, char __user *userbuf,	\
>  			    size_t count, loff_t *ppos)			\
>  {									\
> -	struct wiphy *wiphy= file->private_data;		\
> -	char buf[buflen];						\
> +	struct wiphy *wiphy = file->private_data;			\
> +	int __buflen = __builtin_constant_p(buflen) ? buflen : -1;	\
> +	char buf[__buflen];						\

That's rather an odd change too
