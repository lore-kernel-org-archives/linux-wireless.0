Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:45935 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753739Ab1LLUGH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 15:06:07 -0500
Message-ID: <1323720364.19538.11.camel@joe2Laptop> (sfid-20111212_210611_786676_2E38BB1B)
Subject: Re: [PATCH] bcma: extract revision and TX power IDs from SPROM
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Date: Mon, 12 Dec 2011 12:06:04 -0800
In-Reply-To: <1323721992-3941-1-git-send-email-zajec5@gmail.com>
References: <1323721992-3941-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-12 at 21:33 +0100, Rafał Miłecki wrote:

Hi Rafał.

> diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
[]
> @@ -136,6 +139,42 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
>  
>  	bus->sprom.board_rev = sprom[SPOFF(SSB_SPROM8_BOARDREV)];
>  
> +	bus->sprom.txpid2g[0] = (sprom[SPOFF(SSB_SPROM4_TXPID2G01)] &
> +	     SSB_SPROM4_TXPID2G0) >> SSB_SPROM4_TXPID2G0_SHIFT;

This is a bit "wall of uppercase text" for my taste.

Perhaps a macro like:

#define GET_SPROM(val, mask, shift)					\
	(sprom[SPOFF(SSB_SPROM4_TXPID##val)] & SSB_SPROM4_TXPID##mask) >>\
	SSB_SPROM4_TXPID##shift##_SHIFT;


So these become:

> +	bus->sprom.txpid2g[1] = (sprom[SPOFF(SSB_SPROM4_TXPID2G01)] &
> +	     SSB_SPROM4_TXPID2G1) >> SSB_SPROM4_TXPID2G1_SHIFT;
	bus->sprom.txpid2g[1] = GET_SPROM(2G01, 2G1, 2G1);

> +	bus->sprom.txpid2g[2] = (sprom[SPOFF(SSB_SPROM4_TXPID2G23)] &
> +	     SSB_SPROM4_TXPID2G2) >> SSB_SPROM4_TXPID2G2_SHIFT;

	bus->sprom.tpid2g[2] = GET_SPROM(2G23, 2G2, 2G2);

> +	bus->sprom.txpid2g[3] = (sprom[SPOFF(SSB_SPROM4_TXPID2G23)] &
> +	     SSB_SPROM4_TXPID2G3) >> SSB_SPROM4_TXPID2G3_SHIFT;

etc.


