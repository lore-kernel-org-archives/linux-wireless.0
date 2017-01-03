Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f175.google.com ([209.85.210.175]:35449 "EHLO
        mail-wj0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757943AbdACNaE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 08:30:04 -0500
Received: by mail-wj0-f175.google.com with SMTP id v7so445191976wjy.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2017 05:30:03 -0800 (PST)
Subject: Re: [PATCH V4 3/2] brcmfmac: use wiphy_read_of_freq_limits to respect
 extra limits
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170103110340.23249-1-zajec5@gmail.com>
 <20170103110340.23249-3-zajec5@gmail.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d306c928-3725-f9d3-e3c5-e75a1849bd8b@broadcom.com> (sfid-20170103_150148_699650_EB81DDC9)
Date: Tue, 3 Jan 2017 14:29:59 +0100
MIME-Version: 1.0
In-Reply-To: <20170103110340.23249-3-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What is with the patch numbering, ie. 3/2?

On 3-1-2017 12:03, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> There are some devices (e.g. Netgear R8000 home router) with one chipset
> model used for different radios, some of them limited to subbands. NVRAM
> entries don't contain any extra info on such limitations and firmware
> reports full list of channels to us. We need to store extra limitation
> info on DT to support such devices properly.
> 
> This patch adds check for channel being disabled with orig_flags which
> is how this wiphy helper works.

this is the first mention about the wiphy helper. Probably need
statement here that call to wiphy_read_of_freq_limits() was added in
this patch which applies the extra limitation info read from DT.

> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> This patch should probably go through wireless-driver-next, I'm sending
> it just as a proof of concept. It was succesfully tested on SmartRG
> SR400ac with BCM43602.
> 
> V4: Respect IEEE80211_CHAN_DISABLED in orig_flags
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index ccae3bb..f95e316 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -5886,6 +5886,9 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
>  						       band->band);
>  		channel[index].hw_value = ch.control_ch_num;
>  
> +		if (channel->orig_flags & IEEE80211_CHAN_DISABLED)
> +			continue;
> +
>  		/* assuming the chanspecs order is HT20,
>  		 * HT40 upper, HT40 lower, and VHT80.
>  		 */
> @@ -6477,6 +6480,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
>  			wiphy->bands[NL80211_BAND_5GHZ] = band;
>  		}
>  	}
> +	wiphy_read_of_freq_limits(wiphy);

The return value is ignored, which I suppose is fine. So does the
function need a return value at all? Is there a scenario where the DT
info *must* be supplied?

Regards,
Arend
