Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45330 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1H1RDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 13:03:09 -0400
Received: by yie30 with SMTP id 30so2947449yie.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 10:03:08 -0700 (PDT)
Message-ID: <4E5A74C9.1050909@lwfinger.net> (sfid-20110828_190312_757205_05C47426)
Date: Sun, 28 Aug 2011 12:03:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 2/2] bcma: extract some basic info about board from SPROM
References: <1314550043-6220-1-git-send-email-zajec5@gmail.com> <1314550043-6220-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1314550043-6220-2-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/28/2011 11:47 AM, Rafał Miłecki wrote:
>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
>   drivers/bcma/sprom.c |    9 +++++++++
>   1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
> index 166ed13..d729239 100644
> --- a/drivers/bcma/sprom.c
> +++ b/drivers/bcma/sprom.c
> @@ -133,6 +133,15 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
>   		v = sprom[SPOFF(SSB_SPROM8_IL0MAC) + i];
>   		*(((__be16 *)bus->sprom.il0mac) + i) = cpu_to_be16(v);
>   	}
> +
> +	bus->sprom.board_rev = sprom[SPOFF(SSB_SPROM8_BOARDREV)];
> +
> +	bus->sprom.boardflags_lo = sprom[SPOFF(SSB_SPROM8_BFLLO)];
> +	bus->sprom.boardflags_hi = sprom[SPOFF(SSB_SPROM8_BFLHI)];
> +	bus->sprom.boardflags2_lo = sprom[SPOFF(SSB_SPROM8_BFL2LO)];
> +	bus->sprom.boardflags2_hi = sprom[SPOFF(SSB_SPROM8_BFL2HI)];
> +
> +	bus->sprom.country_code = sprom[SPOFF(SSB_SPROM8_CCODE)];
>   }
>
>   int bcma_sprom_get(struct bcma_bus *bus)

Does the card in question not need any other info from the SPROM, or is this 
just a first step? Is the usual SPROM Rev 8 code part of ssb, and is that the 
reason you don't use it here?

Larry

