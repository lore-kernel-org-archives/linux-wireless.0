Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60260 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaCEKtW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 05:49:22 -0500
Message-ID: <1394016556.5275.5.camel@jlt4.sipsolutions.net> (sfid-20140305_114940_758906_F6FDCDB6)
Subject: Re: [PATCH 3.14.0-rc5 v3 1/10] rsi: Adding RS9113 driver files
From: Johannes Berg <johannes@sipsolutions.net>
To: Fariya Fatima <fariya.f@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Mar 2014 11:49:16 +0100
In-Reply-To: <5314357A.8090205@redpinesignals.com> (sfid-20140303_085748_342821_9E04171F)
References: <5314357A.8090205@redpinesignals.com>
	 (sfid-20140303_085748_342821_9E04171F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-03 at 13:25 +0530, Fariya Fatima wrote:

> +config RSI_91x

Convention would be to use RSI_91X.

> +	tristate "Redpine Signals Inc 91x WLAN driver support"
> +	depends on MAC80211
> +	default m

Please don't add a default, the driver is probably useless for almost
everyone running 'make oldconfig' and similar.

> +config RSI_DEBUGFS
> +	bool "Redpine Signals Inc debug support"
> +	depends on RSI_91x
> +	default y

This on the other hand is fine since it depends on RSI_91x

> +#ifndef __RSI_DEBUGFS_H__
> +#define __RSI_DEBUGFS_H__
> +
> +#include "rsi_main.h"
> +#include <linux/debugfs.h>
> +
> +#define FOPS(fopen) { \
> +	.owner = THIS_MODULE, \
> +	.open = (fopen), \
> +	.read = seq_read, \
> +	.llseek = seq_lseek, \
> +}

I'm not sure these should be in a header file? Seems only the debugfs
implemnetation would need them.

> +#define TID_TO_WME_AC(_tid) (      \
> +	((_tid) == 0 || (_tid) == 3) ? BE_Q : \
> +	((_tid) < 3) ? BK_Q : \
> +	((_tid) < 6) ? VI_Q : \
> +	VO_Q)
> +
> +#define WME_AC(_q) (    \
> +	((_q) == BK_Q) ? IEEE80211_AC_BK : \
> +	((_q) == BE_Q) ? IEEE80211_AC_BE : \
> +	((_q) == VI_Q) ? IEEE80211_AC_VI : \
> +	IEEE80211_AC_VO)

What are those "BE_Q" constants? Those seem a tad short to me.

> +enum EDCA_QUEUE {

Ah, here they are. enums should typically not be uppercase though.

> +struct rsi_event {
> +	atomic_t event_condition;
> +	wait_queue_head_t event_queue;
> +};
> +
> +struct rsi_thread {
> +	void (*thread_function)(void *);
> +	struct completion completion;
> +	struct task_struct *task;
> +	struct rsi_event event;
> +	atomic_t thread_done;
> +};

These seem odd ... maybe they should at least come with comments about
how generic kernel functionality can't be used and why it needs another
abstraction layer?

> +	/* Generic */
> +	u8 channel;
> +	u8 *rx_data_pkt;

That seems rather odd, how can you have one rx_data_pkt in the global
struct?

> +#ifdef CONFIG_RSI_DEBUGFS
> +	struct rsi_debugfs *dfsentry;
> +	u8 num_debugfs_entries;
> +#endif

What do you need num_entries for?

johannes

