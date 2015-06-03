Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43191 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbbFCHyR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:54:17 -0400
Message-ID: <1433318054.2274.8.camel@sipsolutions.net> (sfid-20150603_095420_806021_F30E9184)
Subject: Re: Cannot disable transmission retry
From: Johannes Berg <johannes@sipsolutions.net>
To: "Hodaszi, Robert" <robert.hodaszi@digi.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ujjal Roy <royujjal@gmail.com>
Date: Wed, 03 Jun 2015 09:54:14 +0200
In-Reply-To: <1433262583.7119.5.camel@A1-HR-PC> (sfid-20150602_183644_259067_2D8B7637)
References: <1433262583.7119.5.camel@A1-HR-PC>
	 (sfid-20150602_183644_259067_2D8B7637)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+patch author

> - if (retry->disabled ||
> + if (retry->disabled || retry->value < 1 || retry->value > 255 ||
> (retry->flags & IW_RETRY_TYPE) != IW_RETRY_LIMIT)
> return -EINVAL;
> 
> 
> 
> I'm wondering, is the 'retry->value < 1' is necessary? I would write
> 'retry->value < 0' instead, to make possible to disable the retries.
> Should I send a patch?

I think this is likely some confusion over what "retry" means. Some
places in the code used to take it as "# of transmission attempts",
others (imho more correctly) interpret it as "# of retries".

I think it's probably fine to change to < 0.

johannes

