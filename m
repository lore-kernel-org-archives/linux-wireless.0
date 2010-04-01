Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55255 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab0DAPgx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 11:36:53 -0400
From: Michael Buesch <mb@bu3sch.de>
To: b43-dev@lists.infradead.org
Subject: Re: [RFT][PATCH] ssb: Look for SPROM at different offset on higher rev CC
Date: Thu, 1 Apr 2010 16:36:50 +0100
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1270065561-4333-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1270065561-4333-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201004011736.50440.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 31 March 2010 21:59:21 Rafał Miłecki wrote:
> Our offset handling becomes even a little more hackish now. For some reason I
> do not understand all offsets as inrelative. It assumes base offset is 0x1000
> but it will work for now as we make offsets relative anyway by removing base
> 0x1000. Should be cleaner however.
> 

What about fixing it correctly instead adding a hack?


> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/ssb/pci.c            |    9 ++++++---
>  include/linux/ssb/ssb.h      |    1 +
>  include/linux/ssb/ssb_regs.h |    3 ++-
>  3 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
> index a4b2b99..5bb1278 100644
> --- a/drivers/ssb/pci.c
> +++ b/drivers/ssb/pci.c
> @@ -167,7 +167,7 @@ err_pci:
>  }
>  
>  /* Get the word-offset for a SSB_SPROM_XXX define. */
> -#define SPOFF(offset)	(((offset) - SSB_SPROM_BASE) / sizeof(u16))
> +#define SPOFF(offset)	(((offset) - SSB_SPROM_BASE1) / sizeof(u16))
>  /* Helper to extract some _offset, which is one of the SSB_SPROM_XXX defines. */
>  #define SPEX16(_outvar, _offset, _mask, _shift)	\
>  	out->_outvar = ((in[SPOFF(_offset)] & (_mask)) >> (_shift))
> @@ -253,7 +253,7 @@ static int sprom_do_read(struct ssb_bus *bus, u16 *sprom)
>  	int i;
>  
>  	for (i = 0; i < bus->sprom_size; i++)
> -		sprom[i] = ioread16(bus->mmio + SSB_SPROM_BASE + (i * 2));
> +		sprom[i] = ioread16(bus->mmio + bus->sprom_offset + (i * 2));
>  
>  	return 0;
>  }
> @@ -284,7 +284,7 @@ static int sprom_do_write(struct ssb_bus *bus, const u16 *sprom)
>  			ssb_printk("75%%");
>  		else if (i % 2)
>  			ssb_printk(".");
> -		writew(sprom[i], bus->mmio + SSB_SPROM_BASE + (i * 2));
> +		writew(sprom[i], bus->mmio + bus->sprom_offset + (i * 2));
>  		mmiowb();
>  		msleep(20);
>  	}
> @@ -625,6 +625,9 @@ static int ssb_pci_sprom_get(struct ssb_bus *bus,
>  		return -ENODEV;
>  	}
>  
> +	bus->sprom_offset = (bus->chipco.dev->id.revision < 31) ?
> +		SSB_SPROM_BASE1 : SSB_SPROM_BASE31;
> +
>  	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
>  	if (!buf)
>  		goto out;
> diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
> index 3b4da23..a2608bf 100644
> --- a/include/linux/ssb/ssb.h
> +++ b/include/linux/ssb/ssb.h
> @@ -305,6 +305,7 @@ struct ssb_bus {
>  	/* ID information about the Chip. */
>  	u16 chip_id;
>  	u16 chip_rev;
> +	u16 sprom_offset;
>  	u16 sprom_size;		/* number of words in sprom */
>  	u8 chip_package;
>  
> diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
> index 9ae9082..b8be23c 100644
> --- a/include/linux/ssb/ssb_regs.h
> +++ b/include/linux/ssb/ssb_regs.h
> @@ -170,7 +170,8 @@
>  #define SSB_SPROMSIZE_WORDS_R4		220
>  #define SSB_SPROMSIZE_BYTES_R123	(SSB_SPROMSIZE_WORDS_R123 * sizeof(u16))
>  #define SSB_SPROMSIZE_BYTES_R4		(SSB_SPROMSIZE_WORDS_R4 * sizeof(u16))
> -#define SSB_SPROM_BASE			0x1000
> +#define SSB_SPROM_BASE1			0x1000
> +#define SSB_SPROM_BASE31		0x0800
>  #define SSB_SPROM_REVISION		0x107E
>  #define  SSB_SPROM_REVISION_REV		0x00FF	/* SPROM Revision number */
>  #define  SSB_SPROM_REVISION_CRC		0xFF00	/* SPROM CRC8 value */
> 

-- 
Greetings, Michael.
