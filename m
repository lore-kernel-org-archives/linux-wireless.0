Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61979 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1BQAiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 19:38:21 -0500
Received: by pzk35 with SMTP id 35so284867pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2011 16:38:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110215221313.498d21ed.nledovskikh@gmail.com>
References: <20110215221313.498d21ed.nledovskikh@gmail.com>
Date: Thu, 17 Feb 2011 02:38:20 +0200
Message-ID: <AANLkTinzcoAPYkq1nc--p6z79AEMXau+OEtwY5dpcy3Q@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Right channel setting for ar2317 chip
From: Nick Kossifidis <mickflemm@gmail.com>
To: Nikolay Ledovskikh <nledovskikh@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com, me@bobcopeland.com, jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/2/15 Nikolay Ledovskikh <nledovskikh@gmail.com>:
> Patch that fixes right channel setting when running ar2317 based boards.
>
> Signed-off-by: Nikolay Ledovskikh <nledovskikh@gmail.com>
> ---
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 78c26fd..c44111f 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1253,6 +1253,7 @@ static int ath5k_hw_channel(struct ath5k_hw *ah,
>        case AR5K_RF5111:
>                ret = ath5k_hw_rf5111_channel(ah, channel);
>                break;
> +       case AR5K_RF2317:
>        case AR5K_RF2425:
>                ret = ath5k_hw_rf2425_channel(ah, channel);
>                break;
>
> --
> Best regards, Nikolay Ledovskikh.
>

Thanks for catching that, I forgot to add it ;-)

Please resend with a better changelog (eg. "Use correct channel
setting function for AR2317") so that everyone is happy.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
