Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0055.hostedemail.com ([216.40.44.55]:50127 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932281AbbKMQZP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 11:25:15 -0500
Date: Fri, 13 Nov 2015 11:25:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Michal Marek <mmarek@suse.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC v4 5/8] mac80211: generate hw flags from include file
Message-ID: <20151113112511.7431eb34@gandalf.local.home> (sfid-20151113_172519_864104_D80A0ED8)
In-Reply-To: <1447318073-22669-6-git-send-email-johannes@sipsolutions.net>
References: <1447318073-22669-1-git-send-email-johannes@sipsolutions.net>
	<1447318073-22669-6-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 12 Nov 2015 09:47:50 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:


> +#define __DEFINE_HWFLAG(_flg, _on, _off)				\
> +	HWFLAGS_DEFSTATE_##_flg = -1 + ((_on) ^ (_off)) * (1 + _on),
> +#define DEFINE_HWFLAG(_flg)						\
> +	__DEFINE_HWFLAG(_flg,						\
> +			IS_ENABLED(CONFIG_MAC80211_HW_##_flg##_ON),	\
> +			IS_ENABLED(CONFIG_MAC80211_HW_##_flg##_OFF))
> +#include <net/mac80211-hwflags.h>
> +#undef DEFINE_HWFLAG

You learned to use the MACRO force well, young Skywalker.

-- Steve

>  };
>  
>  bool _____optimisation_missing(void);

