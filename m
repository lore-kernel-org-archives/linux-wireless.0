Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:54472 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab1BIH7Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 02:59:24 -0500
Subject: Re: [PATCH] ssb: extract boardflags2 for SPROMs rev 4 and 5
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <1297204337-7932-1-git-send-email-zajec5@gmail.com> (sfid-20110208_233235_389809_FFFFFFFFB9A7C8CA)
References: <1297204337-7932-1-git-send-email-zajec5@gmail.com>
	 (sfid-20110208_233235_389809_FFFFFFFFB9A7C8CA)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 08:59:18 +0100
Message-ID: <1297238358.9734.0.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-08 at 23:32 +0100, Rafał Miłecki wrote: 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

ack. John, please take this one through your tree.

> ---
>  drivers/ssb/pci.c            |    4 ++++
>  include/linux/ssb/ssb_regs.h |    4 ++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
> index 158449e..5b33b3b 100644
> --- a/drivers/ssb/pci.c
> +++ b/drivers/ssb/pci.c
> @@ -468,10 +468,14 @@ static void sprom_extract_r45(struct ssb_sprom *out, const u16 *in)
>  		SPEX(country_code, SSB_SPROM4_CCODE, 0xFFFF, 0);
>  		SPEX(boardflags_lo, SSB_SPROM4_BFLLO, 0xFFFF, 0);
>  		SPEX(boardflags_hi, SSB_SPROM4_BFLHI, 0xFFFF, 0);
> +		SPEX(boardflags2_lo, SSB_SPROM4_BFL2LO, 0xFFFF, 0);
> +		SPEX(boardflags2_hi, SSB_SPROM4_BFL2HI, 0xFFFF, 0);
>  	} else {
>  		SPEX(country_code, SSB_SPROM5_CCODE, 0xFFFF, 0);
>  		SPEX(boardflags_lo, SSB_SPROM5_BFLLO, 0xFFFF, 0);
>  		SPEX(boardflags_hi, SSB_SPROM5_BFLHI, 0xFFFF, 0);
> +		SPEX(boardflags2_lo, SSB_SPROM5_BFL2LO, 0xFFFF, 0);
> +		SPEX(boardflags2_hi, SSB_SPROM5_BFL2HI, 0xFFFF, 0);
>  	}
>  	SPEX(ant_available_a, SSB_SPROM4_ANTAVAIL, SSB_SPROM4_ANTAVAIL_A,
>  	     SSB_SPROM4_ANTAVAIL_A_SHIFT);
> diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
> index 489f7b6..df9211a 100644
> --- a/include/linux/ssb/ssb_regs.h
> +++ b/include/linux/ssb/ssb_regs.h
> @@ -268,6 +268,8 @@
>  /* SPROM Revision 4 */
>  #define SSB_SPROM4_BFLLO		0x0044	/* Boardflags (low 16 bits) */
>  #define SSB_SPROM4_BFLHI		0x0046  /* Board Flags Hi */
> +#define SSB_SPROM4_BFL2LO		0x0048	/* Board flags 2 (low 16 bits) */
> +#define SSB_SPROM4_BFL2HI		0x004A	/* Board flags 2 Hi */
>  #define SSB_SPROM4_IL0MAC		0x004C	/* 6 byte MAC address for a/b/g/n */
>  #define SSB_SPROM4_CCODE		0x0052	/* Country Code (2 bytes) */
>  #define SSB_SPROM4_GPIOA		0x0056	/* Gen. Purpose IO # 0 and 1 */
> @@ -358,6 +360,8 @@
>  #define SSB_SPROM5_CCODE		0x0044	/* Country Code (2 bytes) */
>  #define SSB_SPROM5_BFLLO		0x004A	/* Boardflags (low 16 bits) */
>  #define SSB_SPROM5_BFLHI		0x004C  /* Board Flags Hi */
> +#define SSB_SPROM5_BFL2LO		0x004E	/* Board flags 2 (low 16 bits) */
> +#define SSB_SPROM5_BFL2HI		0x0050	/* Board flags 2 Hi */
>  #define SSB_SPROM5_IL0MAC		0x0052	/* 6 byte MAC address for a/b/g/n */
>  #define SSB_SPROM5_GPIOA		0x0076	/* Gen. Purpose IO # 0 and 1 */
>  #define  SSB_SPROM5_GPIOA_P0		0x00FF	/* Pin 0 */


-- 
Greetings Michael.

