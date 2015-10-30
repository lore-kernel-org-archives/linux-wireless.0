Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51784 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637AbbJ3If5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 04:35:57 -0400
Date: Fri, 30 Oct 2015 11:35:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Glen Lee <glen.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 17/17] staging: wilc1000: wilc_netdev_init: use wilc
 instead of g_linux_wlan
Message-ID: <20151030083544.GD18797@mwanda> (sfid-20151030_093604_456992_344E27FD)
References: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
 <1446174642-28570-17-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446174642-28570-17-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 30, 2015 at 12:10:42PM +0900, Glen Lee wrote:
>  	/*create the common structure*/
> -	g_linux_wlan = kzalloc(sizeof(*g_linux_wlan), GFP_KERNEL);
> -	if (!g_linux_wlan)
> +	wl = kzalloc(sizeof(struct wilc), GFP_KERNEL);

This introduces a checkpatch.pl warning.  The prefered style is:

	wl = kzalloc(sizeof(*wl), GFP_KERNEL);

But the larger point is that please use checkpatch.pl.

regards,
dan carpenter

