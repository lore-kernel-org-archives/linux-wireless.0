Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53250 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab0AYSac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:30:32 -0500
Received: by bwz27 with SMTP id 27so2919018bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 10:30:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b6c5339f1001250951u548e6a16raf661464660ec577@mail.gmail.com>
References: <4B5CB7AB.7010105@bzz.no> <b6c5339f1001250951u548e6a16raf661464660ec577@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 25 Jan 2010 19:30:10 +0100
Message-ID: <69e28c911001251030p79f00ea1j23f95b5e2f8571a3@mail.gmail.com>
Subject: Re: Bug: 2.6.32 ath5k, unable to connect to AP on channel 13
To: Bob Copeland <me@bobcopeland.com>
Cc: "John S. Skogtvedt" <jss@bzz.no>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 25, 2010 at 6:51 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sun, Jan 24, 2010 at 4:12 PM, John S. Skogtvedt <jss@bzz.no> wrote:
>> Hello,
>>
>> As the subject says, using ath5k on 2.6.32 I am not able to connect to
>> an AP on channel 13 (i.e. wpa_supplicant doesn't find the AP and thus
>> fails to associate). I'm in Norway, and the card is bought in Norway.
>
>> dmesg output:
>> [    7.205952] cfg80211: Using static regulatory domain info
>> [    7.205956] cfg80211: Regulatory domain: US
>> [    7.206243] cfg80211: Calling CRDA for country: US
>
> Well, there's your problem, AFAICT.  You have
> CONFIG_WIRELESS_OLD_REGULATORY=y?  And ieee80211_regdom=EU doesn't work?
>
>> [    7.887265] ath: EEPROM regdomain: 0x80d0
>> [    7.887267] ath: EEPROM indicates we should expect a country code
>> [    7.887270] ath: doing EEPROM country->regdmn map search
>> [    7.887272] ath: country maps to regdmn code: 0x37
>> [    7.887275] ath: Country alpha2 being used: DK
>> [    7.887277] ath: Regpair used: 0x37
>> [    8.288352] ath5k phy0: Atheros AR2414 chip found (MAC: 0x79, PHY: 0x45)
>> [    8.288607] cfg80211: Calling CRDA for country: DK
>
> Denmark, which should allow the channels in question.

However, does the DK regdomain really get set? Is CRDA installed?

>
>> iw list output:
>> Wiphy phy0
>>        Band 1:
>>                Frequencies:
>>                        * 2412 MHz [1] (20.0 dBm)
>>                        * 2417 MHz [2] (20.0 dBm)
>>                        * 2422 MHz [3] (20.0 dBm)
>>                        * 2427 MHz [4] (20.0 dBm)
>>                        * 2432 MHz [5] (20.0 dBm)
>>                        * 2437 MHz [6] (20.0 dBm)
>>                        * 2442 MHz [7] (20.0 dBm)
>>                        * 2447 MHz [8] (20.0 dBm)
>>                        * 2452 MHz [9] (20.0 dBm)
>>                        * 2457 MHz [10] (20.0 dBm)
>>                        * 2462 MHz [11] (20.0 dBm)
>>                        * 2467 MHz [12] (disabled)
>>                        * 2472 MHz [13] (disabled)
>>                        * 2484 MHz [14] (disabled)
>> ...
>>
>>
>> iw reg get output:
>> country US:
>>        (2402 - 2472 @ 40), (6, 27)
>>        (5170 - 5190 @ 40), (6, 23)
>>        (5190 - 5210 @ 40), (6, 23)
>>        (5210 - 5230 @ 40), (6, 23)
>>        (5230 - 5330 @ 40), (6, 23)
>>        (5735 - 5835 @ 40), (6, 30)
>>
>> I tried "iw reg set NO" without effect.
>
> CCed Luis in case he has anything to add.
>
> --
> Bob Copeland %% www.bobcopeland.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
