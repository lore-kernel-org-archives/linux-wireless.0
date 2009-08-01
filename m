Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:61281 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZHAIT3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 04:19:29 -0400
Received: by bwz19 with SMTP id 19so1566713bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2009 01:19:28 -0700 (PDT)
Message-ID: <4A73FA8D.5030804@gmail.com>
Date: Sat, 01 Aug 2009 10:19:25 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, proski@gnu.org
Subject: Re: [PATCH 4/4] ath5k: Use SWI to trigger calibration
References: <20090731181020.GE7963@makis> <20090801054649.GA8390@makis>
In-Reply-To: <20090801054649.GA8390@makis>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/01/2009 07:46 AM, Nick Kossifidis wrote:
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1104,6 +1104,26 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
>    PHY calibration
>  \*****************/
>  
> +void
> +ath5k_hw_calibration_poll(struct ath5k_hw *ah)
> +{
> +	u32 current_time = (jiffies / HZ);

jiffies are long. And they start from negative to catch such issues. You
were lucky and/or tested after 5 minutes of uptime ;).

> +	u32 cal_intval = ah->ah_cal_intval;
> +
> +	if (!ah->ah_cal_tstamp)
> +		ah->ah_cal_tstamp = current_time;
> +
> +	/* For now we always do full calibration
> +	 * Mark software interrupt mask and fire software
> +	 * interrupt (bit gets auto-cleared) */
> +	if ((current_time - ah->ah_cal_tstamp) >= cal_intval) {

Aiee, this should be converted to time_after(). You don't count with a
wrap here. (The same as above.)

> +		ah->ah_cal_tstamp = current_time;
> +		ah->ah_swi_mask = AR5K_SWI_FULL_CALIBRATION;
> +		AR5K_REG_ENABLE_BITS(ah, AR5K_CR, AR5K_CR_SWI);
> +	}
> +
> +}

