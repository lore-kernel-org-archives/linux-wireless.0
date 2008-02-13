Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:41343 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168AbYBMMTP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 07:19:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] WAVELAN - compile-time check for struct sizes
Date: Wed, 13 Feb 2008 13:17:45 +0100
Cc: Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk,
	deller@gmx.de, jt@hpl.hp.com, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
References: <200801131516.34567.deller@gmx.de> <20080207120238.d169a0d2.akpm@linux-foundation.org> <20080207204601.GD3025@tuxdriver.com>
In-Reply-To: <20080207204601.GD3025@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802131317.46168.rjw@sisk.pl> (sfid-20080213_121920_600161_D1E26F8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, 7 of February 2008, John W. Linville wrote:
> On Thu, Feb 07, 2008 at 12:02:38PM -0800, Andrew Morton wrote:
> > On Thu, 7 Feb 2008 14:08:42 -0500
> > "John W. Linville" <linville@tuxdriver.com> wrote:
> 
> > > Subject: [PATCH] wavelan: mark hardware interfacing structures as packed
> 
> > ha_t is still triggering with this patch.
> > 
> > This incremental patch:
> 
> <snip>
> 
> > fixes things up.  If forces `union hacs_u' to be two bytes, not four.
> 
> OK, so I'll queue this one...'salright?

Can you please tell me what the status of this patch is?

Thanks,
Rafael


> ---
> 
> From: John W. Linville <linville@tuxdriver.com>
> Subject: [PATCH] wavelan: mark hardware interfacing structures as packed
> 
> With assists from Russell King <rmk+kernel@arm.linux.org.uk> and
> Andrew Morton <akpm@linux-foundation.org>...
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/wavelan.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/wavelan.h b/drivers/net/wireless/wavelan.h
> index 27172cd..9ab3605 100644
> --- a/drivers/net/wireless/wavelan.h
> +++ b/drivers/net/wireless/wavelan.h
> @@ -85,7 +85,7 @@ union hacs_u
>  #define		HASR_MMC_INTR		0x0002	/* Interrupt request from MMC */
>  #define		HASR_MMC_BUSY		0x0004	/* MMC busy indication */
>  #define		HASR_PSA_BUSY		0x0008	/* LAN parameter storage area busy */
> -};
> +} __attribute__ ((packed));
>  
>  typedef struct ha_t	ha_t;
>  struct ha_t
> @@ -292,7 +292,7 @@ struct mmw_t
>  #define	MMW_EXT_ANT_INTERNAL	0x00	/* Internal antenna */
>  #define	MMW_EXT_ANT_EXTERNAL	0x03	/* External antenna */
>  #define	MMW_EXT_ANT_IQ_TEST	0x1C	/* IQ test pattern (set to 0) */
> -};
> +} __attribute__ ((packed));
>  
>  #define	MMW_SIZE	37
>  
> @@ -347,7 +347,7 @@ struct mmr_t
>    unsigned char	mmr_unused4[1];		/* unused */
>    unsigned char	mmr_fee_data_l;		/* Read data from EEPROM (low) */
>    unsigned char	mmr_fee_data_h;		/* Read data from EEPROM (high) */
> -};
> +} __attribute__ ((packed));
>  
>  #define	MMR_SIZE	36
>  
> -- 
> 1.5.3.3
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
