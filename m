Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53056 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbZAWRCQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 12:02:16 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] libertas: fix CF firmware loading for some cards
Date: Fri, 23 Jan 2009 18:01:19 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	ryan@bluewatersys.com,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	Cyril HAENEL <chaenel@free.fr>
References: <1232729733.2577.13.camel@localhost.localdomain>
In-Reply-To: <1232729733.2577.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901231801.19570.mb@bu3sch.de> (sfid-20090123_180221_677021_BB14FC6F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 January 2009 17:55:33 Dan Williams wrote:
> if_cs_poll_while_fw_download() returned the number of iterations
> remaining on success, which in turn got returned as the value from
> if_cs_prog_real() and if_cs_prog_helper().  But since if_cs_probe()
> interprets non-zero return values from firmware load functions as an
> error, this sometimes caused spurious firmware load failures.
> 
> Signed-off-by: Dan Williams <dcbw@redhat.com>
> ---
> 
> diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
> index 842a08d..8f8934a 100644
> --- a/drivers/net/wireless/libertas/if_cs.c
> +++ b/drivers/net/wireless/libertas/if_cs.c
> @@ -151,7 +151,7 @@ static int if_cs_poll_while_fw_download(struct if_cs_card *card, uint addr, u8 r
>  	for (i = 0; i < 100000; i++) {
>  		u8 val = if_cs_read8(card, addr);
>  		if (val == reg)
> -			return i;
> +			return 0;
>  		udelay(5);
>  	}
>  	return -ETIME;

This is an incredibly expensive loop, btw. Even for init it's really painful to
hog the CPU for more than half a second. Especially on UP.
Any chance for msleep()?

-- 
Greetings, Michael.
