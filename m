Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:52516 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754750AbcE0SHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 14:07:45 -0400
Message-ID: <1464372460.3938.13.camel@perches.com> (sfid-20160527_200748_643691_F055CC2E)
Subject: Re: [PATCH] staging/wilc1000: fixes kzalloc call
From: Joe Perches <joe@perches.com>
To: Lidza Louina <lidza.louina@oracle.com>, johnny.kim@atmel.com,
	austin.shin@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Date: Fri, 27 May 2016 11:07:40 -0700
In-Reply-To: <1464371477-16965-1-git-send-email-lidza.louina@oracle.com>
References: <1464371477-16965-1-git-send-email-lidza.louina@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-05-27 at 13:51 -0400, Lidza Louina wrote:
> The wl pointer was initialized as a pointer to a struct wilc and
> assigned to a piece of memory the size of the pointer. It should be the
> size of struct wilc.

This isn't necessary.

The code in question is:

	struct wilc *wl;

	sema_init(&close_exit_sync, 0);

	wl = kzalloc(sizeof(*wl), GFP_KERNEL);
	if (!wl)
		return -ENOMEM;

	*wilc = wl;

so this isn't any real change and the generally desired form for
allocations from CodingStyle (Chapter 14: Allocating Memory) is:

The preferred form for passing a size of a struct is the following:	p = kmalloc(sizeof(*p), ...);

> diff --git a/drivers/staging/wilc1000/linux_wlan.c
[]
> @@ -1260,7 +1260,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
>  
>  	sema_init(&close_exit_sync, 0);
>  
> -	wl = kzalloc(sizeof(*wl), GFP_KERNEL);
> +	wl = kzalloc(sizeof(struct wilc), GFP_KERNEL);
>  	if (!wl)
>  		return -ENOMEM;
