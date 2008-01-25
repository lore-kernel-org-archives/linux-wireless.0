Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbYAYPvk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 10:51:40 -0500
Subject: Re: [PATCH] libertas: fix memory alignment problems on the blackfin
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200801251415.00942.hs4233@mail.mn-solutions.de>
References: <200801251415.00942.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 10:46:57 -0500
Message-Id: <1201276017.1163.3.camel@localhost.localdomain> (sfid-20080125_155203_698636_8C1A5352)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-01-25 at 14:15 +0100, Holger Schurig wrote:
> From: Ihar Hrachyshka <ihar.hrachyshka@promwad.com>
> 
> Fixing unaligned memory access on the blackfin architecture (maybe on the 
> ARM also).
> 
> Signed-off-by: Ihar Hrachyshka <ihar.hrachyshka@promwad.com>
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> 
> Index: wireless-2.6/drivers/net/wireless/libertas/dev.h
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/dev.h	2008-01-25 10:03:29.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/dev.h	2008-01-25 14:03:00.000000000 +0100
> @@ -349,7 +349,7 @@ struct assoc_request {
>  	u8 channel;
>  	u8 band;
>  	u8 mode;
> -	u8 bssid[ETH_ALEN];
> +	u8 bssid[ETH_ALEN] __attribute__ ((aligned (2)));
>  
>  	/** WEP keys */
>  	struct enc_key wep_keys[4];
> Index: wireless-2.6/drivers/net/wireless/libertas/assoc.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/assoc.c	2008-01-25 14:03:14.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/assoc.c	2008-01-25 14:03:33.000000000 +0100
> @@ -12,8 +12,10 @@
>  #include "cmd.h"
>  
> 
> -static const u8 bssid_any[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
> -static const u8 bssid_off[ETH_ALEN] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
> +static const u8 bssid_any[ETH_ALEN]  __attribute__ ((aligned (2))) =
> +	{ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
> +static const u8 bssid_off[ETH_ALEN]  __attribute__ ((aligned (2))) =
> +	{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
>  
> 
>  static int assoc_helper_essid(struct lbs_private *priv,

