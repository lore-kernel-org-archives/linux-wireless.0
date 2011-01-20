Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33649 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1ATWj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 17:39:27 -0500
Message-ID: <4D38B990.50406@candelatech.com>
Date: Thu, 20 Jan 2011 14:39:12 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH 1/4] ath9k: remove the virtual wiphy debugfs interface
References: <1295562349-17161-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1295562349-17161-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2011 02:25 PM, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
> ---
>   drivers/net/wireless/ath/ath9k/debug.c |  202 --------------------------------
>   1 files changed, 0 insertions(+), 202 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
> index 3586c43..73644c4 100644
> --- a/drivers/net/wireless/ath/ath9k/debug.c
> +++ b/drivers/net/wireless/ath/ath9k/debug.c
> @@ -381,204 +381,6 @@ static const struct file_operations fops_interrupt = {
>   	.llseek = default_llseek,
>   };

I think a lot of this could still be useful, even if it's named something
other than wiphy, so please don't remove all the filter debug and
similar...

Thanks,
Ben

>
> -static const char * ath_wiphy_state_str(enum ath_wiphy_state state)
> -{
> -	switch (state) {
> -	case ATH_WIPHY_INACTIVE:
> -		return "INACTIVE";
> -	case ATH_WIPHY_ACTIVE:
> -		return "ACTIVE";
> -	case ATH_WIPHY_PAUSING:
> -		return "PAUSING";
> -	case ATH_WIPHY_PAUSED:
> -		return "PAUSED";
> -	case ATH_WIPHY_SCAN:
> -		return "SCAN";
> -	}
> -	return "?";
> -}
> -
> -static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
> -			       size_t count, loff_t *ppos)
> -{
> -	struct ath_softc *sc = file->private_data;
> -	struct ath_wiphy *aphy = sc->pri_wiphy;
> -	struct ieee80211_channel *chan = aphy->hw->conf.channel;
> -	char buf[512];
> -	unsigned int len = 0;
> -	int i;
> -	u8 addr[ETH_ALEN];
> -	u32 tmp;
> -
> -	len += snprintf(buf + len, sizeof(buf) - len,
> -			"primary: %s (%s chan=%d ht=%d)\n",
> -			wiphy_name(sc->pri_wiphy->hw->wiphy),
> -			ath_wiphy_state_str(sc->pri_wiphy->state),
> -			ieee80211_frequency_to_channel(chan->center_freq),
> -			aphy->chan_is_ht);
> -
> -	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_STA_ID0), addr);
> -	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_STA_ID1)&  0xffff, addr + 4);
> -	len += snprintf(buf + len, sizeof(buf) - len,
> -			"addr: %pM\n", addr);
> -	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_BSSMSKL), addr);
> -	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_BSSMSKU)&  0xffff, addr + 4);
> -	len += snprintf(buf + len, sizeof(buf) - len,
> -			"addrmask: %pM\n", addr);
> -	tmp = ath9k_hw_getrxfilter(sc->sc_ah);
> -	len += snprintf(buf + len, sizeof(buf) - len,
> -			"rfilt: 0x%x", tmp);
> -	if (tmp&  ATH9K_RX_FILTER_UCAST)
> -		len += snprintf(buf + len, sizeof(buf) - len, " UCAST");
> -	if (tmp&  ATH9K_RX_FILTER_MCAST)
> -		len += snprintf(buf + len, sizeof(buf) - len, " MCAST");

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

