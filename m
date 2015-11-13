Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0013.hostedemail.com ([216.40.44.13]:49835 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932676AbbKMQWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 11:22:40 -0500
Date: Fri, 13 Nov 2015 11:22:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Michal Marek <mmarek@suse.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC v4 3/8] mac80211: use static keys for hw flags
Message-ID: <20151113112236.0303675a@gandalf.local.home> (sfid-20151113_172244_276417_B2E45E3A)
In-Reply-To: <1447318073-22669-4-git-send-email-johannes@sipsolutions.net>
References: <1447318073-22669-1-git-send-email-johannes@sipsolutions.net>
	<1447318073-22669-4-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 12 Nov 2015 09:47:48 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> index 000000000000..e220c5e04406
> --- /dev/null
> +++ b/net/mac80211/hwflags.h
> @@ -0,0 +1,89 @@
> +/*
> + * Copyright 2015	Intel Deutschland GmbH
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __mac80211_hwflags_h
> +#define __mac80211_hwflags_h
> +#include <linux/jump_label.h>
> +#include <net/mac80211.h>
> +
> +extern struct static_key_false hwflags_keys[NUM_IEEE80211_HW_FLAGS];
> +
> +#ifdef CONFIG_JUMP_LABEL
> +#define _HWFLAGS_DEFSTATE(_name, _on, _off)				\
> +	HWFLAGS_DEFSTATE_##_name = -1 + ((_on) ^ (_off)) * (1 + _on)

This sure could use a comment.

 on = 0, off = 0,  -1 + (0^0) * (1 + 0) = -1
 on = 0, off = 1,  -1 + (0^1) * (1 + 0) = 0
 on = 1, off = 0,  -1 + (1^0) * (1 + 1) = 1
 on = 1, off = 1,  -1 + (1^1) * (1 + 1) = -1

The I would also state:

  -1 means to simply use if logic (no jump labels/static keys)
   0 means to use jump label to off
   1 means to use jump label to on


> +#define HWFLAGS_DEFSTATE(_name)						\
> +	_HWFLAGS_DEFSTATE(_name,					\
> +			  IS_ENABLED(CONFIG_MAC80211_HW_##_name##_ON),	\
> +			  IS_ENABLED(CONFIG_MAC80211_HW_##_name##_OFF))
> +
> +enum hwflags_defstates {
> +HWFLAGS_DEFSTATE(HAS_RATE_CONTROL),
> +HWFLAGS_DEFSTATE(RX_INCLUDES_FCS),
> +HWFLAGS_DEFSTATE(HOST_BROADCAST_PS_BUFFERING),
> +HWFLAGS_DEFSTATE(SIGNAL_UNSPEC),
> +HWFLAGS_DEFSTATE(SIGNAL_DBM),
> +HWFLAGS_DEFSTATE(NEED_DTIM_BEFORE_ASSOC),
> +HWFLAGS_DEFSTATE(SPECTRUM_MGMT),
> +HWFLAGS_DEFSTATE(AMPDU_AGGREGATION),
> +HWFLAGS_DEFSTATE(SUPPORTS_PS),
> +HWFLAGS_DEFSTATE(PS_NULLFUNC_STACK),
> +HWFLAGS_DEFSTATE(SUPPORTS_DYNAMIC_PS),
> +HWFLAGS_DEFSTATE(MFP_CAPABLE),
> +HWFLAGS_DEFSTATE(WANT_MONITOR_VIF),
> +HWFLAGS_DEFSTATE(NO_AUTO_VIF),
> +HWFLAGS_DEFSTATE(SW_CRYPTO_CONTROL),
> +HWFLAGS_DEFSTATE(SUPPORT_FAST_XMIT),
> +HWFLAGS_DEFSTATE(REPORTS_TX_ACK_STATUS),
> +HWFLAGS_DEFSTATE(CONNECTION_MONITOR),
> +HWFLAGS_DEFSTATE(QUEUE_CONTROL),
> +HWFLAGS_DEFSTATE(SUPPORTS_PER_STA_GTK),
> +HWFLAGS_DEFSTATE(AP_LINK_PS),
> +HWFLAGS_DEFSTATE(TX_AMPDU_SETUP_IN_HW),
> +HWFLAGS_DEFSTATE(SUPPORTS_RC_TABLE),
> +HWFLAGS_DEFSTATE(P2P_DEV_ADDR_FOR_INTF),
> +HWFLAGS_DEFSTATE(TIMING_BEACON_ONLY),
> +HWFLAGS_DEFSTATE(SUPPORTS_HT_CCK_RATES),
> +HWFLAGS_DEFSTATE(CHANCTX_STA_CSA),
> +HWFLAGS_DEFSTATE(SUPPORTS_CLONED_SKBS),
> +HWFLAGS_DEFSTATE(SINGLE_SCAN_ON_ALL_BANDS),
> +HWFLAGS_DEFSTATE(TDLS_WIDER_BW),
> +HWFLAGS_DEFSTATE(SUPPORTS_AMSDU_IN_AMPDU),
> +HWFLAGS_DEFSTATE(BEACON_TX_STATUS),
> +};
> +
