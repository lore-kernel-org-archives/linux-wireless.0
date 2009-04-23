Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63686 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZDWRtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 13:49:24 -0400
Received: by fxm2 with SMTP id 2so684566fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 10:49:22 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	luciano.coelho@nokia.com, Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wl12xx: third submission
References: <87ab67b9y2.fsf@litku.valot.fi>
	<1240507929.30082.258.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 23 Apr 2009 20:49:19 +0300
In-Reply-To: <1240507929.30082.258.camel@johannes.local> (Johannes Berg's message of "Thu\, 23 Apr 2009 19\:32\:09 +0200")
Message-ID: <874owf8dls.fsf@litku.valot.fi> (sfid-20090423_194927_792994_536A0F70)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Hi,

Moin,

> A couple of comments.

Thanks for the review, I appreciate this.

> It clashes with the patches that I just posted to remove
> config_interface in favour of only using bss_info_changed.

No problem, I can update wl12xx as soon as you finalise the interface.
Just let me know.

> This:
>         if (memcmp(wl->mac_addr, conf->mac_addr, ETH_ALEN)) {
>                 memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
>                 SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr); 
>
> is strange in wl12xx_op_add_interface for sure. Should at least be in
> ->start() if you can't read it before. Or is that trying to override the
> address the user assigned??

Frankly I don't even remember, that's old code :) I'll check it.

> wl12xx_op_remove_interface ought to clear the device's address to stop
> acking frames.

Will fix.

> 	wl12xx_cmd_template_set(wl, CMD_PROBE_RESP, beacon->data,
>
> hmm. mac80211 doesn't deal with probe response offload right now.

Yeah.

>
>                 /*
>                  * We enter PSM only if we're already associated.
>                  * If we're not, we'll enter it when joining an SSID,
>                  * through the bss_info_changed() hook.
>                  */
>
> Umm, mac80211 only enables CONF_PS after associating. So psm_requested
> is unnecessary.

True. Again old code.

> wl12xx_build_basic_rates and wl12xx_build_extended_rates are unnecessary
> -- use scan_req->ie and set the IE max length. Similarly
> wl12xx_build_probe_req should be reduced a lot (to just putting in the
> SSID). You could also support the channels passed in the scan request.

Ok.

>         wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
>                 IEEE80211_HW_NOISE_DBM;
>
> No powersave bits?

Again old code :) Will fix.

> MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>, "
>                 "Luciano Coelho <luciano.coelho@nokia.com>");
>
> Use multiple MODULE_AUTHOR() macros.

Ok.

>         /*
>          * The rx status timestamp is a 32 bits value while the TSF is a
>          * 64 bits one.
>          * For IBSS merging, TSF is mandatory, so we have to get it
>          * somehow, so we ask for ACX_TSF_INFO.
>          * That could be moved to the get_tsf() hook, but unfortunately,
>          * this one must be atomic, while our SPI routines can sleep.   
>          */
>         if ((wl->bss_type == BSS_TYPE_IBSS) && beacon) {
>
> If the chip supports a good filter flags set it could be useful for
> monitoring to always do this if monitor is enabled. Not really necessary
> though.

Actually I would like to get rid of that call. SPI access dead slow and
I don't want to have any extra commands in RX path. So this needs to be
reworked anyway.

>
>         status->flag |= RX_FLAG_TSFT;
>
> You should set that only when it's actually completely filled I think.
> p54 has a trick to keep track of the upper 32 bits in software, 

This would help.

> that assumes getting a frame every 2**32 us though.

But we can check that in driver and compensate, right?

>         skb = dev_alloc_skb(length);
>         if (!skb) {
>                 wl12xx_error("Couldn't allocate RX frame");
>                 return;
>         }
>
>         rx_buffer = skb_put(skb, length);
>
> how about IPv4 alignment? Could you read the packet header first,
> memmove that and then read the rest, i.e. do two wl12xx_spi_mem_read
> calls? Might or might not be more efficient...

SPI access add latency, it would be faster to read as much as possible
in one transaction.

> You need to rm wl12xx_80211.h and use linux/ieee80211.h, extending where
> necessary.

Agreed. I have been thinking about this but never took the challenge.

Is there anything which in your opinion prevents inclusion to
wireless-testing?

-- 
Kalle Valo
