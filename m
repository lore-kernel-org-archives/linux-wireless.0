Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33527 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab2KPKr3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 05:47:29 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, nabhinav3@mail.gatech.edu,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: support radiotap vendor namespace RX data
References: <1353061591-22284-1-git-send-email-johannes@sipsolutions.net>
Date: Fri, 16 Nov 2012 12:47:25 +0200
In-Reply-To: <1353061591-22284-1-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Fri, 16 Nov 2012 11:26:31 +0100")
Message-ID: <87ehjtygci.fsf@purkki.adurom.net> (sfid-20121116_114738_874292_CF92FF22)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> In some cases, in particular for experimentation, it
> can be useful to be able to add vendor namespace data
> to received frames in addition to the normal radiotap
> data.
>
> Allow doing this through mac80211 by adding fields to
> the RX status descriptor that describe the data while
> the data itself is prepended to the frame.
>
> Also add some example code to hwsim, but don't enable
> it because it doesn't use a proper OUI identifier.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

[...]

> @@ -769,6 +773,17 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
>  				(data->tsf_offset - data2->tsf_offset) +
>  				24 * 8 * 10 / txrate->bitrate);
>  
> +#if 0
> +		memcpy(skb_push(nskb, 8), "ABCDEFGH", 8);
> +		rx_status.vendor_radiotap_bitmap = BIT(0);
> +		rx_status.vendor_radiotap_len = 8;
> +		rx_status.vendor_radiotap_align = 8;
> +		rx_status.vendor_radiotap_oui[0] = 0x00;
> +		rx_status.vendor_radiotap_oui[1] = 0x00;
> +		rx_status.vendor_radiotap_oui[2] = 0x00;
> +		rx_status.vendor_radiotap_subns = 127;
> +#endif

I'm nitpicking (as usual :) but a comment would be nice here, for
example the last sentence from the commit log. Otherwise I'm sure
someone will wonder why the code is not compiled.

-- 
Kalle Valo
