Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37174 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab2DSWvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 18:51:41 -0400
Received: by ghrr11 with SMTP id r11so4874914ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 15:51:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334869564.25074.35.camel@t41.thuisdomein>
References: <1334869564.25074.35.camel@t41.thuisdomein>
Date: Fri, 20 Apr 2012 01:51:41 +0300
Message-ID: <CAFtRNNyNg4gqu16FzERGRzYCbJv_mR00BqwLhAKOXcMtJMhmTQ@mail.gmail.com> (sfid-20120420_005148_419125_25D26BA9)
Subject: Re: [ath5k-devel] ath5k phy0: failed to warm reset the MAC Chip
From: Nick Kossifidis <mickflemm@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/4/20 Paul Bolle <pebolle@tiscali.nl>:
> 0) In the logs of a laptop I use I've found error pairs like this error
> pair:
>    <3>[13053.997856] ath5k phy0: failed to warm reset the MAC Chip
>    <3>[13053.997871] ath5k phy0: can't reset hardware (-5)
>
> The logs show it for a v3.3 based kernel and for the v3.4-rc2 kernel. I
> can't say whether or not preceding kernels also triggered it.
>
> 1) I only noticed these errors because I tend to check these logs for
> errors: I cannot link these errors to drops in (the quality of) wireless
> connectivity.

How frequently do they appear ?
You do suspend/resume on your laptop ?
Any other hw issues with your laptop ?

> 2) The call chain involved should be:
>
> drivers/net/wireless/ath/ath5k/base.c:
> 2737 ath5k_reset(...)
>     {
> 2765         ret = ath5k_hw_reset(...);
> 2766         if (ret) {
> 2767                 ATH5K_ERR(ah, "can't reset hardware (%d)\n", ret);
> 2768                 goto err;
> 2769         }
>     }

Reset is called from reset tasklet (internally, e.g. in case of bad
phy state) or from the protocol stack (e.g. in case we want to switch
channels).

> drivers/net/wireless/ath/ath5k/base.c:
> 1144 ath5k_hw_reset(...)
>     {
> 1296         ret = ath5k_hw_nic_wakeup(...);
> 1297         if (ret)
> 1298                 return ret;
>     }

This is the main reset hw routine...

>  667 ath5k_hw_nic_wakeup(...)
>     {
>  728                 ret = ath5k_hw_nic_reset(...);
>  729
>  730         if (ret) {
>  731                 ATH5K_ERR(ah, "failed to warm reset the MAC Chip\n");
>  732                 return -EIO;
>  733         }
>     }

This is called to set the reset registers and wait for the card to come back

>  395 ath5k_hw_nic_reset(...)
>     {
>  421         ret = ath5k_hw_register_timeout(...);
>     }
>
>  65 ath5k_hw_register_timeout(...)
>     {
>  80         return (i <= 0) ? -EAGAIN : 0;
>     }
>

And it seems the reset register doesn't come back in time

> Note that the -EAGAIN returned by ath5k_hw_register_timeout() and
> ath5k_hw_nic_reset() is transformed to -EIO by ath5k_hw_nic_wakeup().

Since ath5k_hw_nic_wakeup is supposed to wakeup the chip during the
main reset process we want to indicate a failure, that's why we use
-EIO because usually this is a hardware-related problem.

> 3) Do these message really indicate errors? Or can they perhaps be
> downgraded to (say) KERN_INFO level (ie, <6> prefix)?

Yup, if your card doesn't come back in time it's usually a hw error,
it can be the pci bus, the card itself or it might mean that your
pc/laptop doesn't count the time correctly (it happens e.g. because of
sleep state changes).


If you want to debug this further it'll help if you posted somewhere
(e.g. pastebin) the dmesg output and lspci output.


Thanks for your time ;-)

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
