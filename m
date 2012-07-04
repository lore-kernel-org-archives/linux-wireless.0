Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:46803 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab2GDNAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 09:00:05 -0400
Message-ID: <4FF43E53.6050805@lri.fr> (sfid-20120704_150010_618907_9CAA29E1)
Date: Wed, 04 Jul 2012 15:00:03 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH v2] mac80211: tx: do not drop non-robust mgmt to non-MFP
 stas.
References: <1341393221-5396-1-git-send-email-cavallar@lri.fr>  <1341394528.4482.4.camel@jlt3.sipsolutions.net> <4FF414D9.4060509@lri.fr> <1341396753.4482.13.camel@jlt3.sipsolutions.net>
In-Reply-To: <1341396753.4482.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/07/2012 12:12, Johannes Berg wrote:
> Can you review it? :)
> 

> +	else if (ieee80211_is_robust_mgmt_frame(hdr) &&
> +		 (!ieee80211_is_action(hdr->frame_control) ||
> +		  !tx->sta || !test_sta_flag(tx->sta, WLAN_STA_MFP)))
> +		tx->key = NULL;

I would have written that more like

is_robust_mgmt && !(is_action && tx->sta && test_sta_flag(mfp))

So it's more clear that we drop action frames to mfp stas, as per the spec.

> +	else {
> +
>  		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
>  		return TX_DROP;

is that blank line needed ?

>> Do you want to apply it yourself ? or should i include it in a series ?
> 
> Then ... probably easiest for you to include it so you can work on top.
> Here's a version with commit log:
> http://p.sipsolutions.net/17ea0ebece544a59.txt
> 

Ok. will send a series with this patch modified once i test it and my
new patch version.

>>> The whole drop_unencrypted seems strange to start with though...
>>
>> what to you find strange ? that it is not used in a ESS, or how it works
>> ? or both ?
> 
> The way it's used/works/isn't used.

>From what i understand, data frames to unauthorized stations are dropped
well before selecting the encryption key. as stations are authorized
after or at the same time their encryption key are set, it somewhat
works. But for MFP, i'm not sure. I think that drop_unencrypted is
mistaken for "drop_unencrypted_management" there.
But i'm not an MFP expert.

I'm not sure if we should just add a separate
drop_unencrypted_management, or just replace drop_unencrypted with
drop_unencrypted_management. But in a IBSS with RSN, if wpa_supplicant
isn't recent enough, stations are always authorized by default. so
drop_encrypted is required in this case.
