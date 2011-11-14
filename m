Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63110 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab1KNXNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 18:13:33 -0500
Received: by ggnb2 with SMTP id b2so6738226ggn.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2011 15:13:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111114172324.511d676a@mj>
References: <CADxqDgFoO63RG67McnxUJSmxZ9ZPPnE7obKkn+MZAsoJ4UMQtg@mail.gmail.com>
	<20111114172324.511d676a@mj>
Date: Tue, 15 Nov 2011 01:13:32 +0200
Message-ID: <CAFtRNNy4Q+YnABD0d17auDURcYR7K5jmU6uvSiURxAUP=EQWBw@mail.gmail.com> (sfid-20111115_001343_565954_EDD0B83D)
Subject: Re: [ath5k-devel] force AR5212 to sleep
From: Nick Kossifidis <mickflemm@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: =?UTF-8?B?QW5kcsOpcyBHYXJjw61h?= <andres.garcia.saavedra@gmail.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/15 Pavel Roskin <proski@gnu.org>:
> On Mon, 14 Nov 2011 11:42:24 +0100
> Andrés García Saavedra <andres.garcia.saavedra@gmail.com> wrote:
>
>> Hi all,
>>
>> I am testing some custom algorithms for powersaving using
>> mac80211/ath5k. I am using  Dlink DWL-AG660 PCMCIA cards for my
>> experiments. For these algorithms I am notifying sleep/awake events
>> from mac80211 down to the driver whenever I want to. For the case of
>> ath5k I followed that code madwifi was using to force the chipset to
>> sleep (full sleep mode), find the piece of code below:
>>
>> The problem is, the card (and the laptop) totally freezes whenever
>> this is done. According to
>> http://madwifi-project.org/wiki/Compatibility/D-Link this card uses a
>> AR5212, and madwifi driver does use this piece of code to force the
>> chip to sleep (in that case when resetting or stopping an interface).
>>
>> Undoubtedly, I am missing something I should take care of. I'd
>> appreciate any "clue" you could give me.
>>
>>
>> /**** CODE *****/
>>
>>     struct ath5k_softc *sc = hw->priv;
>>     struct ath5k_hw *ah = sc->ah;
>
> You must be using an outdated kernel if you have to do this.
>
>>     unsigned int i;
>>     u32 staid, data;
>>
>>     staid = ath5k_hw_reg_read(ah, AR5K_STA_ID1);
>>
>>     ath5k_hw_reg_write(ah, AR5K_SLEEP_CTL_SLE_ALLOW, AR5K_SLEEP_CTL);
>>
>>     staid |= AR5K_STA_ID1_PWR_SV;
>>
>>     ath5k_hw_reg_write(ah, staid, AR5K_STA_ID1);
>
> Just try one or two of those statements to see which is causing
> trouble.  Obviously, you'll need to print staid first so that you write
> the same value as ath5k_hw_reg_read() returned.  It's also important
> when you read the registers.  Try adding your code to the code that
> already accesses those registers.
>
> --
> Regards,
> Pavel Roskin

>From ath5k's reg.h...

855 #define AR5K_SLEEP_CTL_SLE_WAKE         0x00000000      /* Force
chip awake */
856 #define AR5K_SLEEP_CTL_SLE_SLP          0x00010000      /* Force
chip sleep */
857 #define AR5K_SLEEP_CTL_SLE_ALLOW        0x00020000      /* Normal
sleep policy */

Using sle_allow will not make chip go to sleep, it'll allow chip to go
to sleep for a specified duration, did you put a sleep duration before
setting this one ? Because your code suggests you din't.

from ath5k's reset.c...

455         case AR5K_PM_AUTO:
456                 staid &= ~AR5K_STA_ID1_DEFAULT_ANTENNA;
457                 /* fallthrough */
458         case AR5K_PM_NETWORK_SLEEP:
459                 if (set_chip)
460                         ath5k_hw_reg_write(ah,
461                                 AR5K_SLEEP_CTL_SLE_ALLOW |
462                                 sleep_duration,
463                                 AR5K_SLEEP_CTL);
464
465                 staid |= AR5K_STA_ID1_PWR_SV;
466                 break;

However putting card to sleep this way is not a good idea because in
some cases you get stuck and even a warm reset won't get you out of
this, that's why we have ath5k_hw_on_hold as an alternative that puts
the card on warm reset, effectively powering down most units. Check
out ath5k code and you 'll see we never use AR5K_PM_NETWORK_SLEEP nor
AR5K_PM_AUTO nor AR5K_PM_FULL_SLEEP (and I think MadWiFi also doesn't
use that code), at least not until we make it work correctly. We only
use sleep control register to wake up the card, not put it to sleep. I
believe ath5k_hw_on_hold will do the work for you, if not try using
SLE_ALLOW with a valid sleep duration and see how it goes.

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
