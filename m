Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:28092 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535AbZKWKok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 05:44:40 -0500
Received: by fg-out-1718.google.com with SMTP id d23so2122240fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 02:44:45 -0800 (PST)
Subject: Re: [PATCH 2.6.32] rfkill: fix miscdev ops
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1258972050.7094.140.camel@johannes.local>
References: <1258968499.3271.5.camel@maxim-laptop>
	 <1258972050.7094.140.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 12:44:42 +0200
Message-ID: <1258973082.3675.0.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-23 at 11:27 +0100, Johannes Berg wrote: 
> The /dev/rfkill ops don't refer to the module,
> so it is possible to unload the module while
> file descriptors are open. Fix this oversight.
> 
> Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
> Cc: stable@kernel.org
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/rfkill/core.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- wireless-testing.orig/net/rfkill/core.c	2009-11-23 11:11:13.000000000 +0100
> +++ wireless-testing/net/rfkill/core.c	2009-11-23 11:11:59.000000000 +0100
> @@ -1191,6 +1191,7 @@ static long rfkill_fop_ioctl(struct file
>  #endif
>  
>  static const struct file_operations rfkill_fops = {
> +	.owner		= THIS_MODULE,
>  	.open		= rfkill_fop_open,
>  	.read		= rfkill_fop_read,
>  	.write		= rfkill_fop_write,
> 
> 

Thanks for the quick patch!, works fine.

Best regards,
Maxim Levitsky

