Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:14451 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760097AbXHABMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 21:12:50 -0400
Received: by py-out-1112.google.com with SMTP id d32so92695pye
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 18:12:49 -0700 (PDT)
Message-ID: <43e72e890707311812t3bf67684p6af4d0c21d44608e@mail.gmail.com>
Date: Tue, 31 Jul 2007 21:12:49 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>
Subject: Re: [PATCH 60] drivers/net/wireless/prism54/oid_mgt.c: kmalloc + memset conversion to kzalloc
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	"Andrew Morton" <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200707312334.51067.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	 <200707312334.51067.m.kozlowski@tuxland.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/31/07, Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Acked-by: Luis R. Rodriguez <mcgrof@gmail.com>

>  drivers/net/wireless/prism54/oid_mgt.c | 25377 -> 25297 (-80 bytes)
>  drivers/net/wireless/prism54/oid_mgt.o | 128460 -> 128284 (-176 bytes)
>
>  drivers/net/wireless/prism54/oid_mgt.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> --- linux-2.6.23-rc1-mm1-a/drivers/net/wireless/prism54/oid_mgt.c       2007-07-26 13:07:43.000000000 +0200
> +++ linux-2.6.23-rc1-mm1-b/drivers/net/wireless/prism54/oid_mgt.c       2007-07-30 00:27:44.000000000 +0200
> @@ -244,13 +244,11 @@ mgt_init(islpci_private *priv)
>         /* Alloc the cache */
>         for (i = 0; i < OID_NUM_LAST; i++) {
>                 if (isl_oid[i].flags & OID_FLAG_CACHED) {
> -                       priv->mib[i] = kmalloc(isl_oid[i].size *
> +                       priv->mib[i] = kzalloc(isl_oid[i].size *
>                                                (isl_oid[i].range + 1),
>                                                GFP_KERNEL);
>                         if (!priv->mib[i])
>                                 return -ENOMEM;
> -                       memset(priv->mib[i], 0,
> -                              isl_oid[i].size * (isl_oid[i].range + 1));
>                 } else
>                         priv->mib[i] = NULL;
>         }
>
