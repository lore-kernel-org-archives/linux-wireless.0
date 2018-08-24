Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51116 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbeHXPVK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 11:21:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Sven Eckelmann <sven.eckelmann@openmesh.com>,
        ath10k@lists.infradead.org,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Limit available channels via DT ieee80211-freq-limit
References: <20180730153933.3771-1-sven.eckelmann@openmesh.com>
        <5B5F5DE8.9060101@broadcom.com>
Date: Fri, 24 Aug 2018 14:46:47 +0300
In-Reply-To: <5B5F5DE8.9060101@broadcom.com> (Arend van Spriel's message of
        "Mon, 30 Jul 2018 20:50:16 +0200")
Message-ID: <87lg8whtqw.fsf@kamboji.qca.qualcomm.com> (sfid-20180824_134655_281086_FC1CB627)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> + Rafa=C5=82
>
> On 7/30/2018 5:39 PM, Sven Eckelmann wrote:
>> Tri-band devices (1x 2.4GHz + 2x 5GHz) often incorporate special filters=
 in
>> the RX and TX path. These filtered channel can in theory still be used by
>> the hardware but the signal strength is reduced so much that it makes no
>> sense.
>>
>> There is already a DT property to limit the available channels but ath10k
>> has to manually call this functionality to limit the currrently set wiphy
>> channels further.
>
> Wondering whether we can call it in wiphy_register() like below. Not
> sure why we did not explore that with the introduction of it by Rafa=C5=
=82.
> Maybe he remembers. I did not find something in that direction in
> patchwork, but may have missed it. I know mt76 drops the band
> reference if it ends up with all channels disabled. Maybe that was the
> reason.
>
> Regards,
> Arend
> ---
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index a88551f..2e00cb1 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -742,6 +742,8 @@ int wiphy_register(struct wiphy *wiphy)
> 	if (res)
> 		return res;
>
> +	wiphy_read_of_freq_limits(wiphy);
> +
> 	/* sanity check supported bands/channels */
> 	for (band =3D 0; band < NUM_NL80211_BANDS; band++) {
> 		u16 types =3D 0;

Nobody commented to this, so not sure what to do. Maybe it's best to
apply Sven's patch now and we can later move the call to cfg80211 if
needed. Sounds good?

--=20
Kalle Valo
