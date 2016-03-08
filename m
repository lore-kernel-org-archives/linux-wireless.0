Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38160 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbcCHRAZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 12:00:25 -0500
Message-ID: <1457456420.24270.16.camel@sipsolutions.net> (sfid-20160308_180039_502798_19DDF60F)
Subject: Re: [PATCH] iw: add libnl-tiny support
From: Johannes Berg <johannes@sipsolutions.net>
To: Dima Krasner <dima@dimakrasner.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 08 Mar 2016 18:00:20 +0100
In-Reply-To: <20160305175115.4476ee00292f15f60aad4497@dimakrasner.com>
References: <20160223204334.4a65ab8113dbe31fbffc56ff@dimakrasner.com>
	 <1456927176.2157.4.camel@sipsolutions.net>
	 <20160305175115.4476ee00292f15f60aad4497@dimakrasner.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This:

> -#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30)
> +#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30) && !defined(CONFIG_LIBNL_TINY)

> -#endif /* CONFIG_LIBNL20 && CONFIG_LIBNL30 */
> +#endif /* CONFIG_LIBNL20 && CONFIG_LIBNL30 && CONFIG_LIBNL_TINY */

can be handled by just defining CONFIG_LIBNL20 for libnl-tiny.

> -/* libnl 1.x compatibility code */
> +/* libnl 1.x and libnl-tiny compatibility code */
>  #if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30)
>  #  define nl_sock nl_handle
>  #endif

Are you sure this is needed? Elsewhere you said libnl-tiny uses libnl20
compatible API, which is with nl_handle. If this is needed perhaps some
code erroneously uses nl_sock instead of nl_handle?

Perhaps we should also consider treating 2.0/3.x as the default API and
use nl_handle instead of nl_sock in the code.

johannes

