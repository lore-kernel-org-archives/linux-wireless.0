Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50162 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752716AbeBSMfS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 07:35:18 -0500
Message-ID: <1519043716.16723.1.camel@sipsolutions.net> (sfid-20180219_133522_210273_53B3A800)
Subject: Re: [PATCH] mac80211: inform wireless layer when frame RSSI is
 invalid
From: Johannes Berg <johannes@sipsolutions.net>
To: Jean Pierre TOSONI <jp.tosoni@acksys.fr>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 19 Feb 2018 13:35:16 +0100
In-Reply-To: <AM4PR0101MB2305288C51F159AE69BD78CCE4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
References: <AM4PR0101MB2305288C51F159AE69BD78CCE4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-02-14 at 13:51 +0000, Jean Pierre TOSONI wrote:
> When the low-level driver returns an invalid RSSI indication,
> set the signal value to 0 as an indication to the upper layer.
> 
> Also, skip average level computation if signal is invalid.

Thanks for the patch!

>  	/* Track average RSSI from the Beacon frames of the current AP */
> +	if (rx_status->flag & RX_FLAG_NO_SIGNAL_VAL)
> +		goto skip_signal_processing;
>  	if (ifmgd->flags & IEEE80211_STA_RESET_SIGNAL_AVE) {
>  		ifmgd->flags &= ~IEEE80211_STA_RESET_SIGNAL_AVE;
>  		ewma_beacon_signal_init(&ifmgd->ave_beacon_signal);
> @@ -3454,6 +3456,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
>  				sig, GFP_KERNEL);
>  		}
>  	}
> +skip_signal_processing:

Can't say I like this - how about we pull out the actual processing
into a helper function, and then abort that function early if the
NO_SIGNAL_VAL flag is set.

johannes
