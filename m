Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:33335 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbXLYOXD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 09:23:03 -0500
Received: by an-out-0708.google.com with SMTP id d31so368119and.103
        for <linux-wireless@vger.kernel.org>; Tue, 25 Dec 2007 06:23:02 -0800 (PST)
Message-ID: <40f31dec0712250623yb2bfeahfa1b7024e1fb67f3@mail.gmail.com> (sfid-20071225_142316_095631_B61A6F6A)
Date: Tue, 25 Dec 2007 16:23:02 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "bruno randolf" <bruno@thinktube.com>
Subject: Re: ath5k oops (recent regression, I think)
Cc: "Andrew Lutomirski" <luto@myrealbox.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
In-Reply-To: <200712251804.13693.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <cb0375e10712241906u198c695br1e2120e6cfee3b0d@mail.gmail.com>
	 <200712251804.13693.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/12/25, bruno randolf <bruno@thinktube.com>:
> hello!
>
> i'm seeing the same oops, it seems to be a regression from
>
> commit fd640775bd16e1df50c867cc547af0787f9bd4ab
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Wed Dec 19 01:31:26 2007 +0100
>
>     mac80211: dont use interface indices in drivers
>
> seems ath5k likes to write some rate registers before vif is set up. i used
> the following as a stopgap fix. johannes, do you have any advice how to
> properly fix that?
>
> diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
> index f4478f6..2e9f5c5 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
> @@ -510,6 +510,11 @@ static inline void ath5k_hw_write_rate_duration(struct
> ath5k_hw *ah,
>         const struct ath5k_rate_table *rt;
>         unsigned int i;
>
> +       if (sc->vif == NULL) {
> +               printk("*** sc->vif NULL\n");
> +               return;
> +       }
> +
>         /* Get rate table for the current operating mode */
>         rt = ath5k_hw_get_rate_table(ah,
>                 driver_mode);
>
> bruno
>

Seems right as it doesn't break reset, i was just thinking maybe we
should pass an "initial" argument on ath5k_hw_reset to also skip some
other step (eg. saving/restoring tsf/seqnum etc). What do you think ?


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
