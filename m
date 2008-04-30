Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764299AbYD3UZ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 16:25:57 -0400
Subject: Re: [PATCH] libertas: fix use-before-check violation
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200804291007.56406.hs4233@mail.mn-solutions.de>
References: <200804291007.56406.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 16:21:46 -0400
Message-Id: <1209586906.16194.8.camel@localhost.localdomain> (sfid-20080430_222608_657300_3CA9EFFF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-04-29 at 10:07 +0200, Holger Schurig wrote:
> [PATCH] fix use-before-check violation
> 
> According to Coverity (kudo's to Adrian Bunk), we had one use-before-check
> bug in libe libertas driver. This patch fixes this issue.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-testing/drivers/net/wireless/libertas/scan.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/scan.c	2008-04-29 09:07:19.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/scan.c	2008-04-29 09:07:39.000000000 +0200
> @@ -298,7 +298,8 @@ static int lbs_do_scan(struct lbs_privat
>  	uint8_t *tlv;	/* pointer into our current, growing TLV storage area */
>  
>  	lbs_deb_enter_args(LBS_DEB_SCAN, "bsstype %d, chanlist[].chan %d, chan_count %d",
> -			   bsstype, chan_list[0].channumber, chan_count);
> +		bsstype, chan_list ? chan_list[0].channumber : -1,
> +		chan_count);
>  
>  	/* create the fixed part for scan command */
>  	scan_cmd = kzalloc(MAX_SCAN_CFG_ALLOC, GFP_KERNEL);

