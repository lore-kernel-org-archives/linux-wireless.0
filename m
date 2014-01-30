Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48384 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaA3QSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 11:18:33 -0500
Message-ID: <1391098706.4323.15.camel@jlt4.sipsolutions.net> (sfid-20140130_171837_167309_69535D07)
Subject: Re: [PATCH 3.13.1 1/9] rsi: Add RS9113 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Jahnavi <jahnavi.meher@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 30 Jan 2014 17:18:26 +0100
In-Reply-To: <52EA7584.4040508@redpinesignals.com> (sfid-20140130_165938_444207_B3C8ACC3)
References: <52EA7584.4040508@redpinesignals.com>
	 (sfid-20140130_165938_444207_B3C8ACC3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-30 at 21:23 +0530, Jahnavi wrote:
> From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
> 
> This driver supports the RS9113 chipset from Redpine Signals Inc. This
> chipset supports the 802.11a/b/g/n standards, but this driver currently
> supports only b/g/n. Both SDIO and USB interfaces are supported. Can be
> upgraded to 91x quite easily. More information can be found at:
> http://www.redpinesignals.com/Technologies_&_Chipsets/Chipsets/RS9113.php

You should probably propose it for staging... let me take a few minutes
and make a quick review pass.

> +/**
> + * @file rsi_device_ops.h
> + * @author
> + * @version 1.0
> + *
> + * @section LICENSE

Those lines are all useless

> + * Copyright (c) 2013 Redpine Signals Inc.

It's 2014 now, surely you want to claim copyright this year?

> + * @section DESCRIPTION

That's unnecessary.

> + * This file contians the data structures and variables/ macros commonly

contains

> +#define RSI_HEADER_SIZE                 18

That should probably be some struct, and the define doing sizeof()?

> +static inline unsigned int rsi_get_queueno(unsigned char *addr,
> +					   unsigned short offset)
> +{
> +	return (le16_to_cpu(*(unsigned short *)&addr[offset]) & 0x7000) >> 12;

> +static inline unsigned int rsi_get_length(unsigned char *addr,
> +					  unsigned short offset)

> +static inline unsigned char rsi_get_extended_desc(unsigned char *addr,
> +						  unsigned short offset)

> +static inline unsigned char rsi_get_rssi(unsigned char *addr)

> +static inline unsigned char rsi_get_channel(unsigned char *addr)

These seem like they should then just be replaced by

	some_struct_ptr->rssi

and similar?

> +int rsi_send_ampdu_indication_frame(struct rsi_common *common,
> +				    unsigned short tid,
> +				    unsigned short ssn, unsigned char buf_size,
> +				    unsigned char event);

what are "A-MPDU indication frame[s]"?

> +#ifdef USE_USB_INTF

Shouldn't that be just CONFIG_RSI_SOMETHING?

> +typedef void (*SD_INTERRUPT)(void *pcontext);

no typedefs please

> +#define SDIO_BLOCK_SIZE                         256

Seems like there should be a define for that already?


> +++ b/drivers/net/wireless/rsi/include/rsi_mac80211.h	2014-01-30 16:01:00.194777922 +0530

> +static const struct ieee80211_channel rsi_2ghz_channels[] = {

> +static const struct ieee80211_channel rsi_5ghz_channels[] = {

> +static struct ieee80211_rate rsi_rates[] = {

> +static const unsigned short rsi_mcsrates[] = {

None of this belongs into a header file.

> + * This file contians the os dependent( Linux) specific function prototypes
> + * and macros

That kind of thing is generally frowned upon.

> +void rsi_print(int zone, unsigned char *vdata, int len);

Unless it's more than just a simple printk wrapper?

> +struct module_ps_config {
> +	unsigned int not_in_use:1;
> +	unsigned int clock_gate:1;
> +	unsigned int logical_prgm:1;
> +	unsigned int logical_poweroff:1;
> +	unsigned int power_off:1;
> +	unsigned int resvd:27;
> +};

Uh, no, you can't use bitfields in hardware/firmware communication
structs. They also need to be __packed, in most cases.

> +struct rsi_mac_frame {

All those unions seem a bit ... overblown? Probably better to define
separate structs for different usages and cast appropriately.

johannes

