Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:33191 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321Ab0FRKsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 06:48:14 -0400
Received: by pxi12 with SMTP id 12so400740pxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jun 2010 03:48:12 -0700 (PDT)
Message-ID: <4C1B4EE7.1040907@cortland.com>
Date: Fri, 18 Jun 2010 04:48:07 -0600
From: Steve Brown <sbrown@cortland.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: OOPS in ath5k when setting coverage class
References: <4C1926E7.1070503@cortland.com> <AANLkTil-qhJ7fO3RNm4xwG1fA6uKeTkrD352ICU-z8Ab@mail.gmail.com> <4C1A6E4F.6000708@cortland.com> <20100618031635.GB18709@hash.localnet>
In-Reply-To: <20100618031635.GB18709@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/17/2010 09:16 PM, Bob Copeland wrote:
> On Thu, Jun 17, 2010 at 12:49:51PM -0600, Steve Brown wrote:
>    
>> I went a little further and tested the following patch.
>>
>> If it makes sense to you, I'll submit it.
>>      
> So I looked over the code and found a few more trouble spots.
> What about something like this instead?  It shouldn't hurt to
> use a default channel but could avoid another round or two of
> whack-a-mole...
>
> From: Bob Copeland<me@bobcopeland.com>
> Date: Thu, 17 Jun 2010 23:05:55 -0400
> Subject: [PATCH] ath5k: initialize ah->ah_current_channel
>
> ath5k assumes ah_current_channel is always a valid pointer in
> several places, but a newly created interface may not have a
> channel.  To avoid null pointer dereferences, set it up to point
> to the first available channel until later reconfigured.
>
> Signed-off-by: Bob Copeland<me@bobcopeland.com>
> ---
>   drivers/net/wireless/ath/ath5k/attach.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
> index ef2dc1d..b32e28c 100644
> --- a/drivers/net/wireless/ath/ath5k/attach.c
> +++ b/drivers/net/wireless/ath/ath5k/attach.c
> @@ -126,6 +126,7 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
>   	ah->ah_ant_mode = AR5K_ANTMODE_DEFAULT;
>   	ah->ah_noise_floor = -95;	/* until first NF calibration is run */
>   	sc->ani_state.ani_mode = ATH5K_ANI_MODE_AUTO;
> +	ah->ah_current_channel =&sc->channels[0];
>
>   	/*
>   	 * Find the mac version
>    
Applied and tested. Works.

Thanks,

Steve

