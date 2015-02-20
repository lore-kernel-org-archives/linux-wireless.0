Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:42633 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbbBTOMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 09:12:15 -0500
Received: by wesw62 with SMTP id w62so5785732wes.9
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2015 06:12:14 -0800 (PST)
From: Sven Eckelmann <sven@open-mesh.com>
To: Felix Fietkau <nbd@openwrt.org>, simon@open-mesh.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	marek@open-mesh.com, Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [PATCH v6 2/3] mac80211/minstrel_ht: use the new rate control API
Date: Fri, 20 Feb 2015 15:12:10 +0100
Message-ID: <2670025.E9NWYu3f4D@bentobox> (sfid-20150220_151218_990325_E48C8D50)
In-Reply-To: <1366640083-1054-2-git-send-email-nbd@openwrt.org>
References: <1366640083-1054-1-git-send-email-nbd@openwrt.org> <1366640083-1054-2-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>  static void
> @@ -846,6 +857,8 @@ minstrel_ht_update_caps(void *priv, struct
> ieee80211_supported_band *sband,
> 
>  	msp->is_ht = true;
>  	memset(mi, 0, sizeof(*mi));
> +
> +	mi->sta = sta;
>  	mi->stats_update = jiffies;

minstrel_ht_update_caps can be called on init and on different other changes
(rate_control_rate_update).

Which lock protects mi from following scenario?

context 1: memset(mi, 0, sizeof(*mi)); // mi->sta is now NULL
context 2: minstrel_ht_update_rates -> rate_control_set_rates(mp->hw, mi->sta, rates)
context 2: rate_control_set_rates dereferences pubsta->rates (mi->sta + 0x48) -> Kernel Oops
context 1: mi->sta = sta

The first context is from one of the many rate_control_rate_update in mac80211
and the second context is from ieee80211_tx_status.

The question came up when discovering the OpenWrt bug report
 https://dev.openwrt.org/ticket/18388 (minstrel_ht_update_caps
the thing most likely behind minstrel_remove_sta_debugfs+0xe8c/0x1674 - at least
EPC is pointing inside this function for a build from this revision)

Kind regards,
	Sven Eckelmann
