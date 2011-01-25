Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:7406 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750960Ab1AYFXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 00:23:38 -0500
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0236763013
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 14:23:36 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 2/2] ath5k: correct endianness of frame duration
Date: Tue, 25 Jan 2011 14:23:31 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, jirislaby@gmail.com, lrodriguez@atheros.com
References: <1295929904-11806-1-git-send-email-me@bobcopeland.com> <1295929904-11806-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1295929904-11806-2-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201101251423.32008.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue January 25 2011 13:31:44 Bob Copeland wrote:
> The ath5k version of ieee80211_generic_frame_duration() returns
> an __le16 for standard modes but a cpu-endian int for turbo/half/
> quarter rates.  Make it always return cpu-endian values.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath/ath5k/pcu.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/pcu.c
> b/drivers/net/wireless/ath/ath5k/pcu.c index e5f2b96..a702817 100644
> --- a/drivers/net/wireless/ath/ath5k/pcu.c
> +++ b/drivers/net/wireless/ath/ath5k/pcu.c
> @@ -86,7 +86,7 @@ int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
>  	if (!ah->ah_bwmode) {
>  		dur = ieee80211_generic_frame_duration(sc->hw,
>  						NULL, len, rate);
> -		return dur;
> +		return le16_to_cpu(dur);
>  	}
> 
>  	bitrate = rate->bitrate;
> @@ -265,8 +265,6 @@ static inline void ath5k_hw_write_rate_duration(struct
> ath5k_hw *ah) * what rate we should choose to TX ACKs. */
>  		tx_time = ath5k_hw_get_frame_duration(ah, 10, rate);
> 
> -		tx_time = le16_to_cpu(tx_time);
> -
>  		ath5k_hw_reg_write(ah, tx_time, reg);
> 
>  		if (!(rate->flags & IEEE80211_RATE_SHORT_PREAMBLE))

I wonder what effect this has in ath5k_hw_set_ifs_intervals() where 
ack_tx_time was little endian before...

But the change makes sense.

Acked-by: Bruno Randolf <br1@einfach.org>
