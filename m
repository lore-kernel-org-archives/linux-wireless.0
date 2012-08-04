Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46590 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab2HDP2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Aug 2012 11:28:14 -0400
Received: by obbuo13 with SMTP id uo13so2831132obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 04 Aug 2012 08:28:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <501CD9F3.4000903@net.t-labs.tu-berlin.de>
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<1343059275-49590-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<501CD9F3.4000903@net.t-labs.tu-berlin.de>
Date: Sat, 4 Aug 2012 18:28:13 +0300
Message-ID: <CAFtRNNzV+vwCcg7APcjUUA4f7zhphH4=v4KshUq5XYKWHmBdhQ@mail.gmail.com> (sfid-20120804_172818_300561_CD9C54E4)
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix wrong per rate target power
 eeprom reads for AR5K_EEPROM_MODE_11A
From: Nick Kossifidis <mickflemm@gmail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: nbd@nbd.name, jirislaby@gmail.com, linux-wireless@vger.kernel.org,
	mcgrof@qca.qualcomm.com, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/8/4 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
> Hi all,
>
> After several experiments on cm9 and dcma82 cards, I figured out that
> this patch does not solve the max_power calibration problem as intended.
>
> The partly reduction to 8 with this:
> #define AR5K_EEPROM_N_5GHZ_CHAN         10
> #define AR5K_EEPROM_N_5GHZ_RATE_CHAN    8
>
> ... creates a wrong power curve on the card, as function
> ath5k_eeprom_read_freq_list() runs its while loop still 10 times, which
> results in wrong AR5K_EEPROM_READ(o++, val) readings, leading the card
> to use a very low power level over all.
> This should also be limited to 8, as I tested it.
>
> My suggestion is to just set:
> #define AR5K_EEPROM_N_5GHZ_CHAN         8
>
> .. without introducing a separate variable, it is not needed.
> I will send a v2.
>
> While I am browsing through /ath5k/eeprom.c there are several other
> suspicious places where 10 eeprom lines of chips like 5111, 5112, 2413
> depending on their EEPROM Version are read. I can not test this, as I
> have only CM9 and DCMA82 over here, but I guess those 10 line reads are
> also wrong. Can someone test this ?
>
>
> Greetings Thomas
>

There is nothing suspicious about it, it's what EEPROM docs say:

a) For 11a mode there are 10 calibration peers and for b/g there are 3
for chips < 2413 and 4 on later chips.
b) We first read the frequencies, if freq != 0 we use the calibration
info, else we ignore it.
c) We then read the power deltas for each calibration pier
d) Then we store that info for use by the channel power table calibration

Also what do you mean wrong curve and how did you actually test your
card and measured the tx power ?

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
