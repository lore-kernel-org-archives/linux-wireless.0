Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:48961 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbYJNRL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 13:11:59 -0400
Received: by yx-out-2324.google.com with SMTP id 8so529669yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Oct 2008 10:11:58 -0700 (PDT)
Message-ID: <40f31dec0810141011y265275a8nc083764889d699f1@mail.gmail.com> (sfid-20081014_191203_836485_AB7A5BBB)
Date: Tue, 14 Oct 2008 20:11:57 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Elias Oltmanns" <eo@nebensachen.de>
Subject: Re: [PATCH] ath5k: Does not connect reliably on 2.6.27
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87iqrvgm7b.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <87iqrvgm7b.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/14 Elias Oltmanns <eo@nebensachen.de>:
> Hi all,
>
> after a cold boot into 2.6.27, ath5k doesn't work on my machine. The
> sequence
>
> # ifconfig ath0 up
> # iwlist ath0 ap
>
> results in a message informing me that no list of APs is available for
> that device. I have identified the following commit as the guilty one:
>
> commit 2203d6be7ed17af81a1dc35a0af9806086743b02
> Author: Nick Kossifidis <mick@madwifi.org>
> Date:   Sun Jul 20 06:36:52 2008 +0300
>
>    ath5k: Misc hw_reset updates
>
>     * Update hw_reset to calculate some of the values we were using as
>       static
>     * Increase activation to rx delay
>
>    Changes-licensed-under: ISC
>    Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> The minimal patch to fix the issue for me is attached. However, I am
> wondering whether the preceding writes to register 0xa228 should be
> dropped or at least adjusted somehow. Perhaps those of you who know the
> recently released HAL from Atheros can throw some light on the matter.
>
> Regards,
>
> Elias
> ---
> diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
> index dc51b84..b1cec2a 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
> @@ -862,7 +862,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>                        data = 0;
>
>                        /* Just write 0x9b5 ? */
> -                       /* ath5k_hw_reg_write(ah, 0x000009b5, 0xa228); */
> +                       ath5k_hw_reg_write(ah, 0x000009b5, 0xa228);
>                        ath5k_hw_reg_write(ah, 0x0000000f, AR5K_SEQ_MASK);
>                        ath5k_hw_reg_write(ah, 0x00000000, 0xa254);
>                        ath5k_hw_reg_write(ah, 0x0000000e, AR5K_PHY_SCAL);
>

I think i've fixed that (it's a buggy mask some lines above) on an
earlier patch (the one that introduced AR2425 support) but i'll look
into it again ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
