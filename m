Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 203-96-159-182.paradise.net.nz ([203.96.159.182]:41751 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752381AbZAWTnz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:43:55 -0500
Message-ID: <497AD344.5080900@bluewatersys.com> (sfid-20090123_204403_394896_7E19AFA6)
Date: Sat, 24 Jan 2009 21:37:24 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	Cyril HAENEL <chaenel@free.fr>,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: fix CF firmware loading for some cards
References: <1232729733.2577.13.camel@localhost.localdomain>
In-Reply-To: <1232729733.2577.13.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
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
> 
> 

Hmmm, I posted this same patch here a couple of months ago
(http://lists.infradead.org/pipermail/libertas-dev/2008-October/002019.html),
did I get something wrong in the submission process, or did it just get
lost in the woodwork? Anyway:

Tested-by: Ryan Mallon <ryan@bluewatersys.com>
Acked-by: Ryan Mallon <ryan@bluewatersys.com>

~Ryan

