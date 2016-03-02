Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45230 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbcCBN7k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 08:59:40 -0500
Message-ID: <1456927176.2157.4.camel@sipsolutions.net> (sfid-20160302_145943_658852_1DA9DE12)
Subject: Re: [PATCH] iw: add libnl-tiny support
From: Johannes Berg <johannes@sipsolutions.net>
To: Dima Krasner <dima@dimakrasner.com>, linux-wireless@vger.kernel.org
Date: Wed, 02 Mar 2016 14:59:36 +0100
In-Reply-To: <20160223204334.4a65ab8113dbe31fbffc56ff@dimakrasner.com> (sfid-20160223_194343_135265_7B7CCCFB)
References: <20160223204334.4a65ab8113dbe31fbffc56ff@dimakrasner.com>
	 (sfid-20160223_194343_135265_7B7CCCFB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-23 at 20:43 +0200, Dima Krasner wrote:
> 
> +#ifdef CONFIG_LIBNL_TINY
> +#define nl_handle nl_sock
[...]
>  /* libnl 1.x compatibility code */
> -#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30)
> +#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30) &&
> !defined(CONFIG_LIBNL_TINY)
>  #  define nl_sock nl_handle
>  #endif


This makes no sense. Clearly, nl_sock was intended to be the struct
name used in the code, and it seems that nl-tiny implements the libnl
1.1 API, so you should work with that code instead of redefining
everything.

johannes
