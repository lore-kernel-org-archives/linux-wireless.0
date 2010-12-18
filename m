Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:47758 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab0LRGKy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 01:10:54 -0500
Subject: Re: [RFC][PATCH] b43: N-PHY: prepare for 2056 radio tables writing
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
In-Reply-To: <1292628161-6201-1-git-send-email-zajec5@gmail.com> (sfid-20101217_182318_257450_0DD1BC69)
References: <1292628161-6201-1-git-send-email-zajec5@gmail.com>
	 (sfid-20101217_182318_257450_0DD1BC69)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Dec 2010 07:10:47 +0100
Message-ID: <1292652647.7646.1.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-12-18 at 00:22 +0100, Rafał Miłecki wrote: 
> ---
> Here is the way I'd like to handle many different tables, 3 for every PHY rev.
> 
> This adds some helper structure, pointers and magic macro. I understand this
> but is this readable for others?
> 
> Advantage of this crazy layout is that we avoid mess like:
> b2056_find_syn_table()
> {
> 	if (phy == 3)
> 		return table_phy3;
> 	else if (phy == 4)
> 		return table_phy4;
> 	...
> 	else if (phy == 9)
> 		return table_phy9;
> }
> ... same for tx and rx.
> 
> Any objections?
> ---
>  drivers/net/wireless/b43/radio_2056.c |   82 +++++++++++++++++++++++++++++++++
>  drivers/net/wireless/b43/radio_2056.h |    3 +
>  2 files changed, 85 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/radio_2056.c b/drivers/net/wireless/b43/radio_2056.c
> index 0cdf6a4..d30c10a 100644
> --- a/drivers/net/wireless/b43/radio_2056.c
> +++ b/drivers/net/wireless/b43/radio_2056.c
> @@ -24,6 +24,47 @@
>  #include "radio_2056.h"
>  #include "phy_common.h"
>  
> +struct b2056_inittab_entry {
> +	/* Value to write if we use the 5GHz band. */
> +	u16 ghz5;
> +	/* Value to write if we use the 2.4GHz band. */
> +	u16 ghz2;
> +	/* Flags */
> +	u8 flags;
> +#define B2056_INITTAB_ENTRY_OK	0x01
> +#define B2056_INITTAB_UPLOAD	0x02
> +};
> +#define UPLOAD		.flags = B2056_INITTAB_ENTRY_OK | B2056_INITTAB_UPLOAD
> +#define NOUPLOAD	.flags = B2056_INITTAB_ENTRY_OK
> +
> +struct b2056_inittabs_pts {
> +	const struct b2056_inittab_entry *syn;
> +	unsigned int syn_length;
> +	const struct b2056_inittab_entry *tx;
> +	unsigned int tx_length;
> +	const struct b2056_inittab_entry *rx;
> +	unsigned int rx_length;
> +};
> +
> +static const struct b2056_inittab_entry b2056_inittab_rev3_syn[] = {
> +};
> +static const struct b2056_inittab_entry b2056_inittab_rev3_tx[] = {
> +};
> +static const struct b2056_inittab_entry b2056_inittab_rev3_rx[] = {
> +};
> +
> +#define INITTABSPTS(prefix) \
> +	.syn 		= prefix##_syn,			\
> +	.syn_length	= ARRAY_SIZE(prefix##_syn),	\
> +	.tx 		= prefix##_tx,			\
> +	.tx_length	= ARRAY_SIZE(prefix##_tx),	\
> +	.rx 		= prefix##_rx,			\
> +	.rx_length	= ARRAY_SIZE(prefix##_rx)
> +
> +struct b2056_inittabs_pts b2056_inittabs[] = {
> +	[3] = { INITTABSPTS(b2056_inittab_rev3) },
> +};
> +
>  #define RADIOREGS3(r00, r01, r02, r03, r04, r05, r06, r07, r08, r09, \
>  		   r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, \
>  		   r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, \
> @@ -6045,6 +6086,47 @@ static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev8[] =
>    },
>  };
>  
> +static void b2056_upload_inittab(struct b43_wldev *dev, bool ghz5,
> +				 bool ignore_uploadflag, u16 routing,
> +				 const struct b2056_inittab_entry *e,
> +				 unsigned int length)
> +{
> +	unsigned int i;
> +	u16 value;
> +
> +	for (i = 0; i < length; i++) {
> +		if (!(e->flags & B2056_INITTAB_ENTRY_OK))
> +			continue;
> +		if ((e->flags & B2056_INITTAB_UPLOAD) || ignore_uploadflag) {
> +			if (ghz5)
> +				value = e->ghz5;
> +			else
> +				value = e->ghz2;
> +			b43_radio_write(dev, routing | i, value);
> +		}
> +		e++;
> +	}
> +}
> +
> +void b2056_upload_inittabs(struct b43_wldev *dev,
> +			   bool ghz5, bool ignore_uploadflag)
> +{
> +	struct b2056_inittabs_pts *pts;
> +
> +	pts = &b2056_inittabs[dev->phy.rev];

I'm OK with this, except that this really needs more sanity checking
here. You need to check the array boundaries and check for
uninitialized (all-zero) entries and print a big fat warn-on.

> +
> +	b2056_upload_inittab(dev, ghz5, ignore_uploadflag,
> +				B2056_SYN, pts->syn, pts->syn_length);
> +	b2056_upload_inittab(dev, ghz5, ignore_uploadflag,
> +				B2056_TX0, pts->tx, pts->tx_length);
> +	b2056_upload_inittab(dev, ghz5, ignore_uploadflag,
> +				B2056_TX1, pts->tx, pts->tx_length);
> +	b2056_upload_inittab(dev, ghz5, ignore_uploadflag,
> +				B2056_RX0, pts->rx, pts->rx_length);
> +	b2056_upload_inittab(dev, ghz5, ignore_uploadflag,
> +				B2056_RX1, pts->rx, pts->rx_length);
> +}
> +
>  /* TODO: add support for rev4+ devices by searching in rev4+ tables */
>  const struct b43_nphy_channeltab_entry_rev3 *
>  b43_nphy_get_chantabent_rev3(struct b43_wldev *dev, u16 freq)
> diff --git a/drivers/net/wireless/b43/radio_2056.h b/drivers/net/wireless/b43/radio_2056.h
> index 302600c..d601f6e 100644
> --- a/drivers/net/wireless/b43/radio_2056.h
> +++ b/drivers/net/wireless/b43/radio_2056.h
> @@ -1114,4 +1114,7 @@ struct b43_nphy_channeltab_entry_rev3 {
>  	struct b43_phy_n_sfo_cfg phy_regs;
>  };
>  
> +void b2056_upload_inittabs(struct b43_wldev *dev,
> +			   bool ghz5, bool ignore_uploadflag);
> +
>  #endif /* B43_RADIO_2056_H_ */


-- 
Greetings Michael.

