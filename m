Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:62694 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbYJZScj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 14:32:39 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1700082wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 26 Oct 2008 11:32:38 -0700 (PDT)
Message-ID: <40f31dec0810261132w2747d66em2a2a53ff9e1ecc04@mail.gmail.com> (sfid-20081026_193243_535103_6FA09E93)
Date: Sun, 26 Oct 2008 20:32:38 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Elias Oltmanns" <eo@nebensachen.de>
Subject: Re: [PATCH] ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Jiri Slaby" <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87abcrtfa8.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <87prlr9mna.fsf@denkblock.local>
	 <40f31dec0810251621l3d720a69mf21b5253e9135010@mail.gmail.com>
	 <87abcrtfa8.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/26 Elias Oltmanns <eo@nebensachen.de>:
>
> Let me quote from legacy-hal:
>
> ar5212/ar5212_reset.c:
> 373:            OS_REG_RMW_FIELD(ah, AR_PHY_DAG_CTRLCCK,
> 374:                    AR_PHY_DAG_CTRLCCK_RSSI_THR, 2);
>
> ah_internal.h:
> 598:    #define OS_REG_RMW_FIELD(_a, _r, _f, _v) \
> 599:        OS_REG_WRITE(_a, _r, \
> 600:            (OS_REG_READ(_a, _r) &~ _f) | (((_v) << _f##_S) & _f))
>
> Please note the last argument to OS_REG_RMW_FIELD() which is 2 in this
> case. Unless I've made a mistake, this translates into the
>
> data |= 0x00000800;
>
> in my patch.
>
> There definitely is no way for me to connect to an ap (or even get a
> list of aps) with current 2.6.27.4. Perhaps we'll hear something from
> Nils on that matter too.
>

Some lines above...

	/* Overwrite INI values for revised chipsets */
	if (AH_PRIVATE(ah)->ah_phyRev >= AR_PHY_CHIP_ID_REV_2) {

so

		/* Add barker RSSI thresh enable as disabled */
		OS_REG_CLR_BIT(ah, AR_PHY_DAG_CTRLCCK,
			AR_PHY_DAG_CTRLCCK_EN_RSSI_THR);
		OS_REG_RMW_FIELD(ah, AR_PHY_DAG_CTRLCCK,
			AR_PHY_DAG_CTRLCCK_RSSI_THR, 2);

is for phy (BB) revisions > 2 since you have RF5111 this code should
not run but (and here is our bug) instead of checking bb revision we
run this code for all AR5212 chips

		/*
		 * Write some more initial register settings
		 */
		if (ah->ah_version == AR5K_AR5212) {

> --- a/drivers/net/wireless/ath5k/initvals.c
> +++ b/drivers/net/wireless/ath5k/initvals.c
> @@ -810,6 +810,8 @@ static const struct ath5k_ini_mode ar5212_rf5111_ini_mode_end[] = {
>                { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
>        { AR5K_PHY(642),
>                { 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },
> +       { 0xa228,
> +               { 0x000001b5, 0x000001b5, 0x000001b5, 0x000001b5, 0x000001b5 } },
>        { 0xa23c,
>                { 0x13c889af, 0x13c889af, 0x13c889af, 0x13c889af, 0x13c889af } },
>  };
>

This chunk is correct

So can you please change the check on ath5k_hw_reset + add initial
rssi threshold setting and retry ?


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
