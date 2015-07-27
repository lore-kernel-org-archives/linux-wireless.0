Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:33939 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbbG0TN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 15:13:29 -0400
Received: by igk11 with SMTP id 11so75779118igk.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2015 12:13:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1437554563-11712-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1437554563-11712-1-git-send-email-martin.blumenstingl@googlemail.com>
Date: Mon, 27 Jul 2015 12:13:28 -0700
Message-ID: <CAJ-Vmom5v_Jb6f1ARoa3t99Ruht4zJMYiuS85ydHxCYoKV2n5g@mail.gmail.com> (sfid-20150727_211332_907799_A8013365)
Subject: Re: [PATCH RESEND] ath9k: Fix NF CCA limits for AR9287 and AR9227
From: Adrian Chadd <adrian@freebsd.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I wonder if this is a mis-merge on my part (I'm the freebsd maintainer.)

can you log the noisefloor calibrated values before and after the
patch? I'd like to see how low it calibrrates to.


-a


On 22 July 2015 at 01:42, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> The FreeBSD driver [0] uses the same 2G values as for the AR9280 chips.
> Using the same values in ath9k results in much better throughput for me.
>
> Before this patch I had a huge amount of packet loss (sometimes up to
> 40%) and the max transfer speed was somewhere around 5Mbit/s. With this
> patch applied I have zero packet loss and ten times the throughput.
> My device uses a AR9227 which is the PCI variant of the AR9287.
>
> [0] http://bxr.su/FreeBSD/sys/dev/ath/ath_hal/ar9002/ar9287.h
>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> Patch has not changed, I am just CC'ing @linux-wireless (instead of
> @ath9k-devel only).
>
>  drivers/net/wireless/ath/ath9k/ar9002_phy.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.h b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
> index 6314ae2..9d17a53 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9002_phy.h
> +++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
> @@ -610,8 +610,8 @@
>  #define AR_PHY_CCA_MIN_GOOD_VAL_9271_2GHZ      -127
>  #define AR_PHY_CCA_MAX_GOOD_VAL_9271_2GHZ      -116
>
> -#define AR_PHY_CCA_NOM_VAL_9287_2GHZ           -120
> +#define AR_PHY_CCA_NOM_VAL_9287_2GHZ           -112
>  #define AR_PHY_CCA_MIN_GOOD_VAL_9287_2GHZ    -127
> -#define AR_PHY_CCA_MAX_GOOD_VAL_9287_2GHZ    -110
> +#define AR_PHY_CCA_MAX_GOOD_VAL_9287_2GHZ    -97
>
>  #endif
> --
> 2.4.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
