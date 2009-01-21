Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:31515 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbZAUUVh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 15:21:37 -0500
Subject: Re: [Orinoco-devel] [PATCH] orinoco: trivial cleanup in
 alloc_orinocodev
From: Pavel Roskin <proski@gnu.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <200901212155.32754.arvidjaar@mail.ru>
References: <200901212155.32754.arvidjaar@mail.ru>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 15:21:32 -0500
Message-Id: <1232569292.10843.13.camel@dv> (sfid-20090121_212142_096686_62B8CC73)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-01-21 at 21:55 +0300, Andrey Borzenkov wrote:
> Subject: [PATCH] orinoco: trivial cleanup in alloc_orinocodev
> From: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> Remove extra space; remove redundant cast
> 
> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

Signed-off-by: Pavel Roskin <proski@gnu.org>

> -	if (! dev)
> +	if (!dev)

There are 41 occurrences of "(! " in drivers/net/wireless, all in
drivers/net/wireless/orinoco.  Care to fix them all?

By the way, I made a patch that adds all C sources in
drivers/net/wireless/orinoco and ran it through checkpatch.pl.  There
were 226 errors and 174 warnings.  That includes those spaces, trailing
whitespace, excessively long lines and so on.  It would be great if you
fix at least some of that.  Actually, long lines are justified in many
cases, so please don't overdo it.

> -	dev->wireless_handlers = (struct iw_handler_def *)&orinoco_handler_def;
> +	dev->wireless_handlers = &orinoco_handler_def;

That's fine.

-- 
Regards,
Pavel Roskin
