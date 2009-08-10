Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35794 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZHJTBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 15:01:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH RFC] ssb: Implement the remaining rev.8 SPROM vars needed for LP-PHY
Date: Mon, 10 Aug 2009 21:01:38 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A806B9E.5010105@gmail.com>
In-Reply-To: <4A806B9E.5010105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908102101.38698.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 August 2009 20:49:02 Gábor Stefanik wrote:
> Also add a "SPEX32" macro for extracting 32-bit SPROM variables.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> I'm not quite sure that the SPEX32 macro is sane endianness-wise;
> please review it carefully. (In the future, we will probably need
> a SPEX64 macro too, to correctly extract boardflags.)
> 
>  drivers/ssb/pci.c            |   53 +++++++++++++++++++++++++++++++++-
>  include/linux/ssb/ssb.h      |   44 +++++++++++++++++++++++----
>  include/linux/ssb/ssb_regs.h |   66 +++++++++++++++++++++++++++++++++++++----
>  3 files changed, 148 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
> index 40ea417..50811e4 100644
> --- a/drivers/ssb/pci.c
> +++ b/drivers/ssb/pci.c
> @@ -169,8 +169,14 @@ err_pci:
>  /* Get the word-offset for a SSB_SPROM_XXX define. */
>  #define SPOFF(offset)	(((offset) - SSB_SPROM_BASE) / sizeof(u16))
>  /* Helper to extract some _offset, which is one of the SSB_SPROM_XXX defines. */
> -#define SPEX(_outvar, _offset, _mask, _shift)	\
> +#define SPEX16(_outvar, _offset, _mask, _shift)	\
>  	out->_outvar = ((in[SPOFF(_offset)] & (_mask)) >> (_shift))
> +#define SPEX32(_outvar, _offset, _mask, _shift)	\
> +	out->_outvar = ((((in[SPOFF((_offset)+2)] << sizeof(u16)) | \
                                                  ^^^^^^^^^^^^^^
This shifts by 2 bit. Did you want 16 bits? Just write  << 16  then.
Also, it seems you need +1 instead of +2 (it is an u16 pointer).
I also usually cast u16 values to u32 before shifting >=16 bits.
The result of shifting a 16bit variable left by 16bits is machine dependent.
It works as expected for every linux architecture, but I prefer the cast anyway.

Your macro extracts the value in littleendian format. I didn't check if this is
correct for your values. But there also are values stored in BE format.


-- 
Greetings, Michael.
