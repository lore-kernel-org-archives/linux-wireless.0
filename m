Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62999 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab0L2Ajm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 19:39:42 -0500
Received: by yxt3 with SMTP id 3so4040424yxt.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 16:39:41 -0800 (PST)
Subject: Re: [PATCH 2/3] carl9170: reduce channel change delay
From: Felix <ic.felix@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <E1PWwiD-0003TF-Qt@debian64.daheim>
References: <E1PWwiD-0003TF-Qt@debian64.daheim>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 16:39:38 -0800
Message-ID: <1293583178.4197.21.camel@darkslate>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

in 2006 people didn't worry about bg-scan yet, so this stuff didn't get
optimized. Make it look like ath9k for ar9001. Btw I deeply appreciate
your work.

Best regards, Felix

On Sun, 2010-12-26 at 18:22 +0100, Christian Lamparter wrote:
> By removing two "safety" msleeps (and an echo nop), the
> channel change delay is effectively halved. Previously,
> the delay could be as long as 260 ms and the device
> could not go off-channel without risking to miss the
> next DTIM beacon [interval ~307 ms].
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> Hi Felix,
> 
> It seems that removing the msleeps doesn't have ANY negative effect
> on the operation. Furthermore ath9k doesn't need the 20ms+ msleeps
> in the phy codepaths either. So, I wonder if this is just some old
> "safety" buffers which survived otus and ar9170usb development
> phases, or is there some merit to them?
> 
> Regards,
> 	Chr
> ---
>  drivers/net/wireless/ath/carl9170/phy.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
> index 122e75e..b6b0de6 100644
> --- a/drivers/net/wireless/ath/carl9170/phy.c
> +++ b/drivers/net/wireless/ath/carl9170/phy.c
> @@ -1029,8 +1029,6 @@ static int carl9170_init_rf_bank4_pwr(struct ar9170 *ar, bool band5ghz,
>  	if (err)
>  		return err;
>  
> -	msleep(20);
> -
>  	return 0;
>  }
>  
> @@ -1660,12 +1658,6 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
>  			return err;
>  
>  		cmd = CARL9170_CMD_RF_INIT;
> -
> -		msleep(100);
> -
> -		err = carl9170_echo_test(ar, 0xaabbccdd);
> -		if (err)
> -			return err;
>  	} else {
>  		cmd = CARL9170_CMD_FREQUENCY;
>  	}


