Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30983 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab0B0FKn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 00:10:43 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 26 Feb 2010 21:10:43 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19336.44484.226966.463482@gargle.gargle.HOWL>
Date: Sat, 27 Feb 2010 10:59:40 +0530
To: Pavel Roskin <proski@gnu.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [PATCH] ath9k_htc: Add ath9k_htc driver
In-Reply-To: <1267233595.2835.20.camel@mj>
References: <19335.43241.887933.207404@gargle.gargle.HOWL>
	<1267209201.30426.8.camel@mj>
	<43e72e891002261042s587f9fb8g9f491b1bac363582@mail.gmail.com>
	<1267233595.2835.20.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> This piece of code is almost certainly wrong (it addition to being
> longer than 80 characters:
> 
> if (AR_SREV_9271(ah) && (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) == 1)) {
>         REG_WRITE_ARRAY(&ah->iniModes_high_power_tx_gain_9271,
>                         modesIndex, regWrites);
> } else {
>         REG_WRITE_ARRAY(&ah->iniModes_normal_power_tx_gain_9271,
>                         modesIndex, regWrites);
> }
> 
> I think the right code would be
> 
> if (AR_SREV_9271(ah)) {
>         if (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) == 1))
>                 REG_WRITE_ARRAY(&ah->iniModes_high_power_tx_gain_9271,
>                                 modesIndex, regWrites);
>         else
>                 REG_WRITE_ARRAY(&ah->iniModes_normal_power_tx_gain_9271,
>                                 modesIndex, regWrites);
> }
> 
> Better yet, I would use a variable and refactor REG_WRITE_ARRAY.

Indeed. Good catch !

> This code also looks wrong:
> 
>                 val = REG_READ(ah, AR_PCU_MISC_MODE2) &
>                                (~AR_PCU_MISC_MODE2_HWWAR1);
> 
>                 if (!AR_SREV_9271(ah))
>                         val &= ~AR_PCU_MISC_MODE2_HWWAR1;
> 
> I think it should be:
> 
>                 val = REG_READ(ah, AR_PCU_MISC_MODE2);
> 
>                 if (!AR_SREV_9271(ah))
>                         val &= ~AR_PCU_MISC_MODE2_HWWAR1;

Again, great catch. ;)

> The change involving ATH_HW_INITIALIZED appears to be a serious bugfix,
> perhaps even suitable for stable kernels.

Right, I'll do that.

> The message "Running PA Calibration" would be more suitable in
> ath9k_hw_init_cal().
> 
> The original patch should be run through checkpatch.pl.  In addition to
> overly long lines, there are some other formatting issues.

I thought that the default was 106 (or 132 ?) these days ..

Sujith
