Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44101 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754281AbcINONE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 10:13:04 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 08/21] ath10k: make firmware text debug messages more
 verbose.
Date: Wed, 14 Sep 2016 14:12:58 +0000
Message-ID: <87sht2efiu.fsf@kamboji.qca.qualcomm.com> (sfid-20160914_161308_110493_6ECEFB14)
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
        <1462986153-16318-9-git-send-email-greearb@candelatech.com>
In-Reply-To: <1462986153-16318-9-git-send-email-greearb@candelatech.com>
        (greearb@candelatech.com's message of "Wed, 11 May 2016 10:02:20        -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> There are not many of these messages producted by the
> firmware, but they are generally fairly useful, so print
> them at info level.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless=
/ath/ath10k/wmi.c
> index 1758b4a..d9e4b77 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -4050,7 +4050,7 @@ void ath10k_wmi_event_debug_print(struct ath10k *ar=
, struct sk_buff *skb)
>  	/* the last byte is always reserved for the null character */
>  	buf[i] =3D '\0';
> =20
> -	ath10k_dbg(ar, ATH10K_DBG_WMI_PRINT, "wmi print '%s'\n", buf);
> +	ath10k_info(ar, "wmi print '%s'\n", buf);

Useful to whom and how? I understand that for firmware developers this
is very valuable information and that's why we have a special debug
level for it. But I suspect that for normal users these are just
confusing and unnecessarily spam the log.

--=20
Kalle Valo=
