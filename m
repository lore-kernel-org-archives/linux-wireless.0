Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55691 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbbKCK2s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 05:28:48 -0500
Message-ID: <1446546525.29010.14.camel@sipsolutions.net> (sfid-20151103_112851_544486_BF778657)
Subject: Re: [PATCH] iw: Fix memory leak if nla_put fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Tue, 03 Nov 2015 11:28:45 +0100
In-Reply-To: <1445639592-5559-1-git-send-email-ola1olsson@gmail.com> (sfid-20151024_003338_280380_D4EE8ED5)
References: <1445639592-5559-1-git-send-email-ola1olsson@gmail.com>
	 (sfid-20151024_003338_280380_D4EE8ED5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-10-24 at 00:33 +0200, Ola Olsson wrote:
> The NLA_PUT macro will automatically goto nla_put_failure if
> the underlying nla_put fails. This will in turn leak our malloced
> memory in both the scan and wowlan commands.
> Fix that by not using the macro in the cases where we have
> allocated heap mem.
> 
Applied, thanks.

Luckily the tool just exits right away so we don't have to care all
that much :)

But of course it's still good to fix it since people can (and do) copy
it into other code.

johannes
