Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:17725 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644AbYD3RAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 13:00:19 -0400
Received: by nf-out-0910.google.com with SMTP id d3so297313nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2008 10:00:17 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: putting ieee80211_tx_control into skb->cb?
Date: Wed, 30 Apr 2008 19:04:02 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Chr <chunkeey@web.de>, Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>,
	Andrea Merello <andreamrl@tiscali.it>
References: <1209570457.18659.59.camel@johannes.berg>
In-Reply-To: <1209570457.18659.59.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804301904.03670.IvDoorn@gmail.com> (sfid-20080430_190012_033529_045349D7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 April 2008, Johannes Berg wrote:
> With my patch to shrink ieee80211_tx_control, I can now put that into
> skb->cb.
> 
> Do we want to use that as the interface to drivers as well? Many drivers
> could benefit from that a lot since we could save all the extra copies
> done here.
> 
> I've grepped all drivers, currently those using skb->cb are:
>  * p54:     only needs 8 bytes
>  * rt2x00:  needs almost all the space (40 bytes)

Latest rt2x00.git needs _all_ space (48 bytes)
However I can trim it down to 40 bytes quite easily,
since mac80211 wasn't using it anyway I wasn't too conservative
about the usage. ;)
I could even trim it down further if I disable the TX/RX dumping
through debugfs as intermediate solution.

>  * adm8211: puts the 802.11 header there
>  * rtl8180: needs a single pointer to control
>  * rtl8187: usb urb, control and hw pointers
>  * zd1211:  control, hw and context pointers
> 
> Notice how four drivers here put the control information in there, which
> needs to be copied by drivers. However, mac80211 only needs the control
> flags later!

Very nice, removing the requirement to store the entire control data would
save a lot of memory for rt2x00. (Currently it has a per-entry copy of the
tx control data).

> First, we put ieee80211_tx_control into skb->cb. The first member of
> that is a 'u32 flags' which is the only thing we need later for TX
> status reporting, so we require that drivers leave that in there.
> 
> Then, we merge the TX status flags into the TX flags so that now the
> driver only needs to set a few flags in skb->cb. Also, we overlay this.
> 
> Hence, we have something like the following structure:
> 
> struct ieee80211_tx_information {
>     u32 flags;
> 
>     union {
>         struct {
>             s8 tx_rate_idx, rts_cts_rate_idx,
>                alt_retry_rate_idx, retry_limit;
>             struct ieee80211_vif *vif;
>             struct ieee80211_key_conf *hw_key;
>             enum ieee80211_band band;
>             u16 aid;
>             u8 antenna_sel_tx;
>             u8 icv_len, iv_len;
>         } txctl;
> 
>         struct {
>             u64 amdpu_ack_map;
>             int ack_signal;
>             u8 ampdu_ack_len;
>             bool excessive_retries; /* should be a flag / removed */
>             u8 retry_count;
>         } status;
> 
>         /* can be used freely by driver after its ops->tx() accepts
>          * the frame and before tx status reporting */
>         u8 drv_data[40] __attribute__((__aligned__(sizeof(void *)));
>     };
> };
> 
> This means that the drivers are free to use everything in skb->cb for
> their own use but should leave the 'u32 flags' intact, and need to make
> sure to copy out all the information they need before putting in new
> information. This fits with all the drivers, rt2x00 needs at most 32
> bytes (40 now, but one is the txcontrol pointer) while we have 44 free.
> Also, if the driver rejects the skb in ops->tx(), it must not have
> modified skb->cb.

For rt2x00 that won't be a problem, it won't touch the skb->cb anyway
until it has performed all checks for queue entry availability.

> The only thing I'm not sure yet is how to handle alignment here. skb->cb
> itself is 8-byte aligned so we probably need to reserve another four
> bytes to get things to 8-byte alignment and then we go down to 40
> available bytes, this is what I did above.

Ivo
