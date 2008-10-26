Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:16612 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbYJZWdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 18:33:42 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1831606rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Oct 2008 15:33:40 -0700 (PDT)
Message-ID: <40f31dec0810261533g3143bd9bue0f3eff88c6936e9@mail.gmail.com> (sfid-20081026_233404_693402_D8308473)
Date: Mon, 27 Oct 2008 00:33:40 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Elias Oltmanns" <eo@nebensachen.de>
Subject: Re: [PATCH] ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Jiri Slaby" <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87wsfvt76q.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <87prlr9mna.fsf@denkblock.local>
	 <40f31dec0810251621l3d720a69mf21b5253e9135010@mail.gmail.com>
	 <87abcrtfa8.fsf@denkblock.local>
	 <40f31dec0810261132w2747d66em2a2a53ff9e1ecc04@mail.gmail.com>
	 <87wsfvt76q.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/26 Elias Oltmanns <eo@nebensachen.de>:
>
>                /*
>                 * Write some more initial register settings
>                 */
> -               if (ah->ah_version == AR5K_AR5212) {
> +               if (ah->ah_version == AR5K_AR5212 &&
> +                   ah->ah_radio > AR5K_RF5111) {

even better: ah->ah_phy_revision > AR5K_SREV_PHY_5212

>                        ath5k_hw_reg_write(ah, 0x0002a002, 0x982c);
>
>                        if (channel->hw_value == CHANNEL_G)
> @@ -858,6 +859,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>
>                        data = ath5k_hw_reg_read(ah, 0xa228);
>                        data &= 0xfffe03ff;
> +                       data |= 0x00000800;
>                        ath5k_hw_reg_write(ah, data, 0xa228);
>                        data = 0;
>

Can you please use the macros from ath5k.h to set these parameters ?
(i got the above from decompiling binary HAL that's why i have fixed
masks -no magic values- but now that we know what's going on we must
make the code human-readable)
And also please change 0xa228 with it's name from reg.h :

2557 #define AR5K_PHY_DAG_CCK_CTL                    0xa228
2558 #define AR5K_PHY_DAG_CCK_CTL_EN_RSSI_THR        0x00000200
2559 #define AR5K_PHY_DAG_CCK_CTL_RSSI_THR           0x0001fc00
2560 #define AR5K_PHY_DAG_CCK_CTL_RSSI_THR_S         10

Normaly i'll update reset.c this week so you can always wait for a
more generic fix ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
