Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58667 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746Ab3BEWFj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 17:05:39 -0500
Message-ID: <5111822B.9050309@openwrt.org> (sfid-20130205_230542_629834_997B0B09)
Date: Tue, 05 Feb 2013 23:05:31 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Bernhard Urban <lewurm@gmail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	c_manoha@qca.qualcomm.com, Sujith.Manoharan@atheros.com,
	linville@tuxdriver.com, m.sujith@gmail.com,
	shafi.wireless@gmail.com, markus@indoo.rs
Subject: Re: [PATCH] ath9k_htc: update RSSI values only when the device is
 associated
References: <1359723012-9488-1-git-send-email-lewurm@gmail.com>
In-Reply-To: <1359723012-9488-1-git-send-email-lewurm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-01 1:50 PM, Bernhard Urban wrote:
> add an if-guard, otherwise iw(8) reports weird signal strengths.
> 
> The behaviour was fine before this commit:
> 	7c277349ecbd66e19fad3d949fa6ef6c131a3b62
> Therefore, this patch is a partially revert of it.
I think your commit message is a bit misleading. The main problem with
signal strength reporting is not that it's missing some checks for if
the device is associated, or if the received frame is a local beacon.

The main problem is in these lines below:
> +		if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER)) {
> +			s8 rssi = ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
> +			rxbuf->rxstatus.rs_rssi = rssi;
> +		}
It does not make any sense to update the per-frame RSSI value with any
sort of average. ath9k filters out invalid RSSI values by ignoring rssi
for ANI when rx_stats->rs_moreaggr is set. In that case it also sets the
RX_FLAG_NO_SIGNAL_VAL flag to tell mac80211 to ignore the value for its
own signal strength averages.

- Felix

