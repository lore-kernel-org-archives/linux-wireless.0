Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55812 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbZKNKkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 05:40:35 -0500
Received: by bwz27 with SMTP id 27so4242961bwz.21
        for <linux-wireless@vger.kernel.org>; Sat, 14 Nov 2009 02:40:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AFDFE41.9000003@openwrt.org>
References: <4AFDFE41.9000003@openwrt.org>
Date: Sat, 14 Nov 2009 11:40:40 +0100
Message-ID: <a32f33a40911140240w2cebe321mdf8b4a12b4326df6@mail.gmail.com>
Subject: Re: [RFC 1/2] mac80211: add private driver flags and ampdu length to
	tx info
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, Nov 14, 2009 at 1:48 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Some drivers may want to store a few flags of their own in the tx
> info. Also it is useful for 11n rate control to know the total number
> of aggregated frames in an AMPDU, not just the ones that were acked.
> Use two previously unused padding bytes to store those two values
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -386,6 +386,7 @@ struct ieee80211_tx_rate {
>  * @flags: transmit info flags, defined above
>  * @band: the band to transmit on (use for checking for races)
>  * @antenna_sel_tx: antenna to use, 0 for automatic diversity
> + * @driver_flags: flags for internal driver use
>  * @pad: padding, ignore
>  * @control: union for control data
>  * @status: union for status data
> @@ -404,7 +405,8 @@ struct ieee80211_tx_info {
>        u8 antenna_sel_tx;
>
>        /* 2 byte hole */
> -       u8 pad[2];
> +       u8 driver_flags;
> +       u8 ampdu_len;
>
>        union {
>                struct {

You have missed something in the comment above the structure,
you've added the fields "driver_flags" and "ampdu_len" in the structure and
removed the "pad" field. But in the comment you only add "driver_flags" and
kept the "pad" field.

Thanks,

Ivo
