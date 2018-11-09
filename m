Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54467C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B86D20827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:55:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B86D20827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbeKIVfm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 16:35:42 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56830 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727662AbeKIVfm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 16:35:42 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gL5Nj-0003zV-G4; Fri, 09 Nov 2018 12:55:23 +0100
Message-ID: <f9be46875c90f00a79f03838944bbf23f05d2c0d.camel@sipsolutions.net>
Subject: Re: [PATCH 3/3] mac80211: Implement functionality to monitor
 station's signal stregnth
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 09 Nov 2018 12:55:22 +0100
In-Reply-To: <1539626250-769-4-git-send-email-tamizhr@codeaurora.org>
References: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
         <1539626250-769-4-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Oh, umm, that patch is still here ...

I guess we can combine 2 and 3 too.


> +	if (sta->rssi_low && bss_conf->enable_beacon) {
> +		int last_event =
> +			sta->last_rssi_event_value;
> +		int sig = -ewma_signal_read(&sta->rx_stats_avg.signal);
> +		int low = sta->rssi_low;
> +		int high = sta->rssi_high;

This doesn't really support a list, like in patch 2 where you store
sta_info::rssi_tholds?

> +		if (sig < low &&
> +		    (last_event == 0 || last_event >= low)) {
> +			sta->last_rssi_event_value = sig;
> +			cfg80211_sta_mon_rssi_notify(
> +				rx->sdata->dev, sta->addr,
> +				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
> +				sig, GFP_ATOMIC);
> +			rssi_cross = true;
> +		} else if (sig > high &&
> +			   (last_event == 0 || last_event <= high)) {
> +			sta->last_rssi_event_value = sig;
> +			cfg80211_sta_mon_rssi_notify(
> +				rx->sdata->dev, sta->addr,
> +				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
> +				sig, GFP_ATOMIC);
> +			rssi_cross = true;
> +		}
> +	}
> +
> +	if (rssi_cross) {
> +		ieee80211_update_rssi_config(sta);
> +		rssi_cross = false;
> +	}
> +}

Ah, but it does, just hard to understand.

However, this does mean what I suspected on the other patch is true -
you're calling ieee80211_update_rssi_config() here, and that uses the
sta->rssi_tholds array without any protection, while a concurrent change
of configuration can free the data.

You need to sort that out. I would suggest to stick all the sta->rssi_*
fields you add into a new struct (you even had an empty one), and
protect that struct using RCU. That also saves the memory in case it's
not assigned at all. Something like

struct sta_mon_rssi_config {
	struct rcu_head rcu_head;
	int n_thresholds;
	s32 low, high;
	u32 hyst;
	s32 last_value;
	s32 thresholds[];
};

then you can kfree_rcu() it, and just do a single allocation using
struct_size() for however many entries you need.

> + * @count_rx_signal: Number of data frames used in averaging station signal.
> + *	This can be used to avoid generating less reliable station rssi cross
> + *	events that would be based only on couple of received frames.
>   */
>  struct sta_info {
>  	/* General information, mostly static */
> @@ -600,6 +603,7 @@ struct sta_info {
>  	s32 rssi_high;
>  	u32 rssi_hyst;
>  	s32 last_rssi_event_value;
> +	unsigned int count_rx_signal;

I guess that would also move into the new struct.

johannes

