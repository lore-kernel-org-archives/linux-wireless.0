Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50824 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752508AbdIFKgx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 06:36:53 -0400
Message-ID: <1504694211.13457.10.camel@sipsolutions.net> (sfid-20170906_123656_378824_D2319182)
Subject: Re: [PATCH] Print NL80211_BSS_LAST_SEEN_BOOTTIME and beacon tsf
From: Johannes Berg <johannes@sipsolutions.net>
To: Ningyuan Wang <nywang@google.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Sep 2017 12:36:51 +0200
In-Reply-To: <20170726000118.77660-1-nywang@google.com> (sfid-20170726_020239_886626_8A8FB83C)
References: <20170711004746.142837-1-nywang@google.com>
         <20170726000118.77660-1-nywang@google.com>
         (sfid-20170726_020239_886626_8A8FB83C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>  nl80211.h |  4 ++++

Please don't include nl80211.h changes, I'll update that as needed.

> +	if (bss[NL80211_BSS_BEACON_TSF]) {
> +		unsigned long long tsf;
> +		tsf = (unsigned long
> long)nla_get_u64(bss[NL80211_BSS_BEACON_TSF]);
> +		printf("\tBeacon TSF: %llu usec (%llud,
> %.2lld:%.2llu:%.2llu)\n",
> +			tsf, tsf/1000/1000/60/60/24,
> (tsf/1000/1000/60/60) % 24,
> +			(tsf/1000/1000/60) % 60, (tsf/1000/1000) %
> 60);
> +	}

This seems fine, but we already print the BSS_TSF - is it really
needed? Anyway, I think it's OK, just not sure there's much point.

> +	if (bss[NL80211_BSS_LAST_SEEN_BOOTTIME]) {
> +		unsigned long long last_seen_since_boot;
> +		last_seen_since_boot =
> +			(unsigned long
> long)nla_get_u64(bss[NL80211_BSS_LAST_SEEN_BOOTTIME]);
> +		printf("\tlast seen since boot time: %llu usec
> (%llud, %.2lld:%.2llu:%.2llu)\n",
> +			last_seen_since_boot, last_seen_since_boot
> /1000/1000/1000/60/60/24,
> +			(last_seen_since_boot /1000/1000/1000/60/60)
> % 24,
> +			(last_seen_since_boot/1000/1000/1000/60) %
> 60,
> +			(last_seen_since_boot/1000/1000/1000) % 60);
> +	}

This is wrong - the value isn't "last seen since boot", it's "last seen
*at* boottime X" - but "boottime" maybe some kind of strange concept,
so I don't think printing this to a user makes a lot of sense at all?

johannes
