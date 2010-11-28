Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:51793 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab0K1Kcz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Nov 2010 05:32:55 -0500
Subject: Re: [PATCH][RFC] ssb: extract indexes for power tables
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <1290937176-13510-1-git-send-email-zajec5@gmail.com> (sfid-20101128_044002_490248_457B5471)
References: <1290937176-13510-1-git-send-email-zajec5@gmail.com>
	 (sfid-20101128_044002_490248_457B5471)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Nov 2010 11:32:47 +0100
Message-ID: <1290940367.15605.2.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-11-28 at 10:39 +0100, Rafał Miłecki wrote: 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> This patch adds a lot of similar definitions. Like masks and shifts being the
> same for every frequency. Is that OK?

Looks ok.
Acked-by: Michael Buesch <mb@bu3sch.de>

> ---
>  drivers/ssb/pci.c            |   44 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/ssb/ssb.h      |    4 +++
>  include/linux/ssb/ssb_regs.h |   40 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 88 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
> index f529663..158449e 100644
> --- a/drivers/ssb/pci.c
> +++ b/drivers/ssb/pci.c
> @@ -406,6 +406,46 @@ static void sprom_extract_r123(struct ssb_sprom *out, const u16 *in)
>  	out->antenna_gain.ghz5.a3 = gain;
>  }
>  
> +/* Revs 4 5 and 8 have partially shared layout */
> +static void sprom_extract_r458(struct ssb_sprom *out, const u16 *in)
> +{
> +	SPEX(txpid2g[0], SSB_SPROM4_TXPID2G01,
> +	     SSB_SPROM4_TXPID2G0, SSB_SPROM4_TXPID2G0_SHIFT);
> +	SPEX(txpid2g[1], SSB_SPROM4_TXPID2G01,
> +	     SSB_SPROM4_TXPID2G1, SSB_SPROM4_TXPID2G1_SHIFT);
> +	SPEX(txpid2g[2], SSB_SPROM4_TXPID2G23,
> +	     SSB_SPROM4_TXPID2G2, SSB_SPROM4_TXPID2G2_SHIFT);
> +	SPEX(txpid2g[3], SSB_SPROM4_TXPID2G23,
> +	     SSB_SPROM4_TXPID2G3, SSB_SPROM4_TXPID2G3_SHIFT);
> +
> +	SPEX(txpid5gl[0], SSB_SPROM4_TXPID5GL01,
> +	     SSB_SPROM4_TXPID5GL0, SSB_SPROM4_TXPID5GL0_SHIFT);
> +	SPEX(txpid5gl[1], SSB_SPROM4_TXPID5GL01,
> +	     SSB_SPROM4_TXPID5GL1, SSB_SPROM4_TXPID5GL1_SHIFT);
> +	SPEX(txpid5gl[2], SSB_SPROM4_TXPID5GL23,
> +	     SSB_SPROM4_TXPID5GL2, SSB_SPROM4_TXPID5GL2_SHIFT);
> +	SPEX(txpid5gl[3], SSB_SPROM4_TXPID5GL23,
> +	     SSB_SPROM4_TXPID5GL3, SSB_SPROM4_TXPID5GL3_SHIFT);
> +
> +	SPEX(txpid5g[0], SSB_SPROM4_TXPID5G01,
> +	     SSB_SPROM4_TXPID5G0, SSB_SPROM4_TXPID5G0_SHIFT);
> +	SPEX(txpid5g[1], SSB_SPROM4_TXPID5G01,
> +	     SSB_SPROM4_TXPID5G1, SSB_SPROM4_TXPID5G1_SHIFT);
> +	SPEX(txpid5g[2], SSB_SPROM4_TXPID5G23,
> +	     SSB_SPROM4_TXPID5G2, SSB_SPROM4_TXPID5G2_SHIFT);
> +	SPEX(txpid5g[3], SSB_SPROM4_TXPID5G23,
> +	     SSB_SPROM4_TXPID5G3, SSB_SPROM4_TXPID5G3_SHIFT);
> +
> +	SPEX(txpid5gh[0], SSB_SPROM4_TXPID5GH01,
> +	     SSB_SPROM4_TXPID5GH0, SSB_SPROM4_TXPID5GH0_SHIFT);
> +	SPEX(txpid5gh[1], SSB_SPROM4_TXPID5GH01,
> +	     SSB_SPROM4_TXPID5GH1, SSB_SPROM4_TXPID5GH1_SHIFT);
> +	SPEX(txpid5gh[2], SSB_SPROM4_TXPID5GH23,
> +	     SSB_SPROM4_TXPID5GH2, SSB_SPROM4_TXPID5GH2_SHIFT);
> +	SPEX(txpid5gh[3], SSB_SPROM4_TXPID5GH23,
> +	     SSB_SPROM4_TXPID5GH3, SSB_SPROM4_TXPID5GH3_SHIFT);
> +}
> +
>  static void sprom_extract_r45(struct ssb_sprom *out, const u16 *in)
>  {
>  	int i;
> @@ -471,6 +511,8 @@ static void sprom_extract_r45(struct ssb_sprom *out, const u16 *in)
>  	memcpy(&out->antenna_gain.ghz5, &out->antenna_gain.ghz24,
>  	       sizeof(out->antenna_gain.ghz5));
>  
> +	sprom_extract_r458(out, in);
> +
>  	/* TODO - get remaining rev 4 stuff needed */
>  }
>  
> @@ -561,6 +603,8 @@ static void sprom_extract_r8(struct ssb_sprom *out, const u16 *in)
>  	memcpy(&out->antenna_gain.ghz5, &out->antenna_gain.ghz24,
>  	       sizeof(out->antenna_gain.ghz5));
>  
> +	sprom_extract_r458(out, in);
> +
>  	/* TODO - get remaining rev 8 stuff needed */
>  }
>  
> diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
> index 623b704..9659eff 100644
> --- a/include/linux/ssb/ssb.h
> +++ b/include/linux/ssb/ssb.h
> @@ -55,6 +55,10 @@ struct ssb_sprom {
>  	u8 tri5gl;		/* 5.2GHz TX isolation */
>  	u8 tri5g;		/* 5.3GHz TX isolation */
>  	u8 tri5gh;		/* 5.8GHz TX isolation */
> +	u8 txpid2g[4];		/* 2GHz TX power index */
> +	u8 txpid5gl[4];		/* 4.9 - 5.1GHz TX power index */
> +	u8 txpid5g[4];		/* 5.1 - 5.5GHz TX power index */
> +	u8 txpid5gh[4];		/* 5.5 - ...GHz TX power index */
>  	u8 rxpo2g;		/* 2GHz RX power offset */
>  	u8 rxpo5g;		/* 5GHz RX power offset */
>  	u8 rssisav2g;		/* 2GHz RSSI params */
> diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
> index 11daf9c..489f7b6 100644
> --- a/include/linux/ssb/ssb_regs.h
> +++ b/include/linux/ssb/ssb_regs.h
> @@ -299,6 +299,46 @@
>  #define  SSB_SPROM4_AGAIN2_SHIFT	0
>  #define  SSB_SPROM4_AGAIN3		0xFF00	/* Antenna 3 */
>  #define  SSB_SPROM4_AGAIN3_SHIFT	8
> +#define SSB_SPROM4_TXPID2G01		0x0062 	/* TX Power Index 2GHz */
> +#define  SSB_SPROM4_TXPID2G0		0x00FF
> +#define  SSB_SPROM4_TXPID2G0_SHIFT	0
> +#define  SSB_SPROM4_TXPID2G1		0xFF00
> +#define  SSB_SPROM4_TXPID2G1_SHIFT	8
> +#define SSB_SPROM4_TXPID2G23		0x0064 	/* TX Power Index 2GHz */
> +#define  SSB_SPROM4_TXPID2G2		0x00FF
> +#define  SSB_SPROM4_TXPID2G2_SHIFT	0
> +#define  SSB_SPROM4_TXPID2G3		0xFF00
> +#define  SSB_SPROM4_TXPID2G3_SHIFT	8
> +#define SSB_SPROM4_TXPID5G01		0x0066 	/* TX Power Index 5GHz middle subband */
> +#define  SSB_SPROM4_TXPID5G0		0x00FF
> +#define  SSB_SPROM4_TXPID5G0_SHIFT	0
> +#define  SSB_SPROM4_TXPID5G1		0xFF00
> +#define  SSB_SPROM4_TXPID5G1_SHIFT	8
> +#define SSB_SPROM4_TXPID5G23		0x0068 	/* TX Power Index 5GHz middle subband */
> +#define  SSB_SPROM4_TXPID5G2		0x00FF
> +#define  SSB_SPROM4_TXPID5G2_SHIFT	0
> +#define  SSB_SPROM4_TXPID5G3		0xFF00
> +#define  SSB_SPROM4_TXPID5G3_SHIFT	8
> +#define SSB_SPROM4_TXPID5GL01		0x006A 	/* TX Power Index 5GHz low subband */
> +#define  SSB_SPROM4_TXPID5GL0		0x00FF
> +#define  SSB_SPROM4_TXPID5GL0_SHIFT	0
> +#define  SSB_SPROM4_TXPID5GL1		0xFF00
> +#define  SSB_SPROM4_TXPID5GL1_SHIFT	8
> +#define SSB_SPROM4_TXPID5GL23		0x006C 	/* TX Power Index 5GHz low subband */
> +#define  SSB_SPROM4_TXPID5GL2		0x00FF
> +#define  SSB_SPROM4_TXPID5GL2_SHIFT	0
> +#define  SSB_SPROM4_TXPID5GL3		0xFF00
> +#define  SSB_SPROM4_TXPID5GL3_SHIFT	8
> +#define SSB_SPROM4_TXPID5GH01		0x006E 	/* TX Power Index 5GHz high subband */
> +#define  SSB_SPROM4_TXPID5GH0		0x00FF
> +#define  SSB_SPROM4_TXPID5GH0_SHIFT	0
> +#define  SSB_SPROM4_TXPID5GH1		0xFF00
> +#define  SSB_SPROM4_TXPID5GH1_SHIFT	8
> +#define SSB_SPROM4_TXPID5GH23		0x0070 	/* TX Power Index 5GHz high subband */
> +#define  SSB_SPROM4_TXPID5GH2		0x00FF
> +#define  SSB_SPROM4_TXPID5GH2_SHIFT	0
> +#define  SSB_SPROM4_TXPID5GH3		0xFF00
> +#define  SSB_SPROM4_TXPID5GH3_SHIFT	8
>  #define SSB_SPROM4_MAXP_BG		0x0080  /* Max Power BG in path 1 */
>  #define  SSB_SPROM4_MAXP_BG_MASK	0x00FF  /* Mask for Max Power BG */
>  #define  SSB_SPROM4_ITSSI_BG		0xFF00	/* Mask for path 1 itssi_bg */


-- 
Greetings Michael.

