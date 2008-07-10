Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbYGJLbQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 07:31:16 -0400
Subject: Re: [PATCH] libertas: fix memory alignment problems on the blackfin
From: Dan Williams <dcbw@redhat.com>
To: Ihar Hrachyshka <ihar.hrachyshka@promwad.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <20080709092958.72e82f25@promwad.com>
References: <20080709031850.2e7bf50f@promwad.com>
	 <1215563092.476.58.camel@brick>  <20080709092958.72e82f25@promwad.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 07:29:45 -0400
Message-Id: <1215689385.16792.19.camel@localhost.localdomain> (sfid-20080710_133118_949284_3334EB54)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-09 at 09:29 +0300, Ihar Hrachyshka wrote:
> > There's helpers for this now: get_unaligned_le16
> Ok, third pass - the first was in January... :)
> 
> Fixing unaligned memory access on the blackfin architecture (maybe on
> the ARM also).
> 
> Signed-off-by: Ihar Hrachyshka <ihar.hrachyshka@promwad.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
> 
> diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
> index 343ed38..4b27456 100644
> --- a/drivers/net/wireless/libertas/scan.c
> +++ b/drivers/net/wireless/libertas/scan.c
> @@ -567,11 +567,11 @@ static int lbs_process_bss(struct bss_descriptor *bss,
> 	pos += 8;
> 
> 	/* beacon interval is 2 bytes long */
> -	bss->beaconperiod = le16_to_cpup((void *) pos);
> +	bss->beaconperiod = get_unaligned_le16(pos);
> 	pos += 2;
> 
> 	/* capability information is 2 bytes long */
> -	bss->capability = le16_to_cpup((void *) pos);
> +	bss->capability = get_unaligned_le16(pos);
> 	lbs_deb_scan("process_bss: capabilities 0x%04x\n", bss->capability);
> 	pos += 2;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

