Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:51248 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbeH1NYr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 09:24:47 -0400
Message-ID: <1535448830.5895.30.camel@sipsolutions.net> (sfid-20180828_113403_164524_79202217)
Subject: Re: [PATCH 2/3] nl80211: Add support for EDMG channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Date: Tue, 28 Aug 2018 11:33:50 +0200
In-Reply-To: <1534163582-9983-3-git-send-email-ailizaro@codeaurora.org>
References: <1534163582-9983-1-git-send-email-ailizaro@codeaurora.org>
         <1534163582-9983-3-git-send-email-ailizaro@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-08-13 at 15:33 +0300, Alexei Avshalom Lazar wrote:
> 
>  /**
> + * struct ieee80211_sta_edmg_cap - EDMG capabilities
> + *
> + * This structure describes most essential parameters needed
> + * to describe 802.11ay EDMG capabilities
> + *
> + * @supported: is EDMG supported, Device may support EDMG
> + *	without supporting channel bonding. In this case
> + *	supported would be TRUE with n_channels = 0

TRUE -> %true

> + * @channels: supported ieee EDMG channel numbers

IEEE

> + * @n_channels: Number of channels in @channels
> + */
> +struct ieee80211_sta_edmg_cap {
> +	bool supported;
> +	u8 *channels;

const?

But really this is pointless - there are *two* channels here (6 and 7),
and so at most you point to a 2-byte array? Just make it

	u8 channels[2];

or something and save the whole pointering?

Ok, no, there are 9-25 or something, so I guess more than that...

Uh. Why do we bother though? Do we need the channel number anywhere? Why
not just let userspace specify the bitmap to start with?

Would there really be devices that base their support for channels on
anything other than support for the underlying DMG channels?


>   * @center_freq1: center frequency of first segment
>   * @center_freq2: center frequency of second segment
>   *	(only with 80+80 MHz)
> + * @edmg_mode: if defined, edmg supported and primary channel is EDMG
> + * @edmg_channel: the EDMG channel
>   */
>  struct cfg80211_chan_def {
>  	struct ieee80211_channel *chan;
>  	enum nl80211_chan_width width;
>  	u32 center_freq1;
>  	u32 center_freq2;
> +	bool edmg_mode;
> +	u8 edmg_channel;

This seems odd. What do you put into chan_width if it's EDMG then? What
do you put into the chan pointer?

> + * @NL80211_ATTR_WIPHY_EDMG_CHANNEL: EDMG channel to be used for AP
> + *      configuration and connect command.

u8 is intended, I assume?

But why do you need this anyhow? The EDMG channel has a frequency just
like all other channels, no? Can't we continue to use the existing
attributes?

> +static const struct edmg_chan_table {
> +	/* the edmg channel - 9,10,11... */
> +	u8 edmg_chan;
> +	/* the sub channels represented as a bitfield where the bit-index
> +	 * corresponds to the legacy channel (bit 0 not used).
> +	 */
> +	u8 sub_chans;

Uh, ok, so I guess it's more complicated?

I'm not familiar with 802.11ay ... I guess a short primer should be in
the patch set here somewhere :)

> +} cfg80211_edmg_table[] = {
> +	{9, 0x06},	/* channels 1,2 */

BIT(1) | BIT(2) ? then you don't really need the comments ...

> +	{10, 0x0c},	/* channels 2,3 */
> +	{11, 0x18},	/* channels 3,4 */
> +	{12, 0x30},	/* channels 4,5 */
> +	{13, 0x60},	/* channels 5,6 */
> +	{17, 0x0e},	/* channels 1,2,3 */
> +	{18, 0x1c},	/* channels 2,3,4 */
> +	{19, 0x38},	/* channels 3,4,5 */
> +	{20, 0x70},	/* channels 4,5,6 */

What happened to 21-24?

> +	{25, 0x1e},	/* channels 1,2,3,4 */

> +static u8 cfg80211_get_edmg_sub_chans(u8 edmg_channel)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(cfg80211_edmg_table); i++)
> +		if (cfg80211_edmg_table[i].edmg_chan == edmg_channel)
> +			return cfg80211_edmg_table[i].sub_chans;

Maybe just index the array at "edmg_channel - 9", add dummies for 21-24
and save the whole loop? I guess it doesn't matter so much though.

johannes
