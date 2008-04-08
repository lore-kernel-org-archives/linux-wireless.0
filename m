Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51452 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbYDHI0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 04:26:05 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Alejandro Grijalba <sud@latinsud.com>
Subject: Re: [PATCH] mac80211: do not alter injected seq numbers
Date: Tue, 8 Apr 2008 10:25:39 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <47FAB829.9010304@latinsud.com>
In-Reply-To: <47FAB829.9010304@latinsud.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804081025.39645.mb@bu3sch.de> (sfid-20080408_092609_909502_698A80A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 08 April 2008 02:11:21 Alejandro Grijalba wrote:
> When injecting frames we should allow user to play with fields like
> fragment or sequence numbers. This patch prevents mac80211 from modifying
> those fields on injected frames.
> 
> Tested on 2.6.24.4 with aireplay-ng.
> 
> Signed-off-by: Alejandro Grijalba <sud@latinsud.com>
> ---
> There is still a problem with some drivers (b43) that also modify seq numbers, 
> and i cannot find there a clean way to tell whether the frame was injected.
> An alternative way would be to create a radiotap flag meaning not to modify header.
> 
> --- linux-2.6.24.4/net/mac80211/tx.c	2008-01-24 23:58:37.000000000 +0100
> +++ linux-2.6.24.4-sud/net/mac80211/tx.c	2008-04-05 16:43:19.000000000 +0200
> @@ -281,6 +281,9 @@ ieee80211_tx_h_sequence(struct ieee80211
>  {
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
>  
> +	if (unlikely(tx->flags & IEEE80211_TXRXD_TX_INJECTED))
> +		return TXRX_CONTINUE;
> +
>  	if (ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control)) >= 24)
>  		ieee80211_include_sequence(tx->sdata, hdr);
>  

This does not work, since we use injection for other types of frames. For example
management frames from hostapd. We don't want (and can't) make hostapd keep track of
sequence numbers.
You'll have to contact radiotap people and add a flag for this. This would also
solve the hardware counter problem then.

-- 
Greetings Michael.
