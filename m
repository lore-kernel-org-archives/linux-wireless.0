Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51012 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2HEL4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 07:56:44 -0400
Received: by obbuo13 with SMTP id uo13so4153919obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Aug 2012 04:56:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <501E539A.9060706@net.t-labs.tu-berlin.de>
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<1343059275-49590-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<501CD9F3.4000903@net.t-labs.tu-berlin.de>
	<CAFtRNNzV+vwCcg7APcjUUA4f7zhphH4=v4KshUq5XYKWHmBdhQ@mail.gmail.com>
	<501E539A.9060706@net.t-labs.tu-berlin.de>
Date: Sun, 5 Aug 2012 14:56:43 +0300
Message-ID: <CAFtRNNyXgrzsB8Od+qqLgRSb3o_KkxD4sG3UOzu5C1Sz06-GkA@mail.gmail.com> (sfid-20120805_135723_193328_C7D6B05A)
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

2012/8/5 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
> Hi Nick,
>
>> There is nothing suspicious about it, it's what EEPROM docs say:
>>
>> a) For 11a mode there are 10 calibration peers
>
>
> As I tested AR5413, AR5414 and AR5213 there are only 8 eeprom lines for
> 802.11a that provide valid per rate target power levels. I am curious if
> this also holds for other chips.
>

Based on EEPROM docs I have it's 8 per rate target power levels for
all chips after 5210.

>> Also what do you mean wrong curve and how did you actually test your
>> card and measured the tx power ?
>>
>
>
> My first patch only changed the read iterations in function
> ath5k_eeprom_read_target_rate_pwr_info() from 10 reads to 8. Having only
> this, I measured received rssi values while changing the tx_power on a
> sender. I did not observe any changes in rssi, so I went back to the
> code to investigate.

Your patch is correct, that doesn't mean it 'll fix everything ;-)

To give you a picture not all vendors follow Atheros's refference
design, most of them focus on supporting the max power, not all power
levels, so their calibration curves don't provide much. This mostly
happens on chips that can have extrenal preamplifiers and components
so vendors have the freedom to do whatever they want. This doesn't
only happen on ath5k, in my tests with MadWiFi I also didn't see any
tx power changes (you can also see that on the TODO description on
wireless.kernel.org). So have that in mind when testing for tx power
changes.

I'm not saying the code is perfect or bugless I'm saying that you
can't be sure, maybe a cross-check with MadWiFi would help to
understand if it's our fault or vendor's choice.

> And the function ath5k_eeprom_init_11a_pcal_freq() (my hardware eeprom
> version is > 3.3) there is ath5k_eeprom_read_freq_list(..,10,..) called,
> and those 10 iterations produce 2 wrong frequency peer values. If there
> are only 8 iterations used, I am able to measure a 15 dB variation in
> rssi values at the receiver side, while changing the tx_power on the
> sender. For the chips I tested, ath5k_eeprom_read_freq_list() should
> only read 8 pears for 802.11a.
>
> With 'suspicious' I meant e.g. function
> ath5k_eeprom_init_11a_pcal_freq(), as it checks the eeprom version and
> if > 3.3 it calls
> ath5k_eeprom_init_11a_pcal_freq(..,AR5K_EEPROM_N_5GHZ_CHAN,..), in the
> else case, it reads 10 hardcoded freq.pears .. I am questioning if this
> is correct, so maybe someone has the chance to test this.
>

According to EEPROM docs there are 10 calibration piers on all chips
after 5111 for 11a but some of them are not used and the way to test
this is if frequency is zero. Now here is a bug in the EEPROM code
that might result the wrong reads you get, check this out:

on ath5k_eeprom_read_freq_list we do this

if (!freq1)
 break;

instead of this

if (!freq1)
 continue;

so maybe the offset at the end of this function is wrong, can you
please test if this change fixes your readings ?

You can also see that HAL code does the same:
#define NUM_11A_EEPROM_CHANNELS	10
#define NUM_11A_EEPROM_CHANNELS_2413    10

while (numPiers < NUM_11A_EEPROM_CHANNELS) {
	EEREAD(off++);
	if ((eeval & freqmask) == 0)
		break;
	freq[numPiers++] = fbin2freq(ee,
		eeval & freqmask);

	if (((eeval >> 8) & freqmask) == 0)
		break;
	freq[numPiers++] = fbin2freq(ee,
		(eeval>>8) & freqmask);
}

Some more infos on the EEPROM code:

Most of this code was written by rev-engineering when working on
ath_info tool a few years back when we didn't had any docs, all we had
were some EEPROM dumps posted on the internet (the output of the
eeprom tool that comes with Atheros's ART program). When we got
documentation and HAL's source some parts of this code were fixed but
we haven't done a complete review since then.

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
