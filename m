Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f189.google.com ([209.85.222.189]:57846 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab0AYTVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 14:21:05 -0500
Received: by pzk27 with SMTP id 27so118120pzk.33
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 11:21:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c911001251030p79f00ea1j23f95b5e2f8571a3@mail.gmail.com>
References: <4B5CB7AB.7010105@bzz.no> <b6c5339f1001250951u548e6a16raf661464660ec577@mail.gmail.com>
	<69e28c911001251030p79f00ea1j23f95b5e2f8571a3@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 25 Jan 2010 11:20:42 -0800
Message-ID: <43e72e891001251120y568e480fje5cfc370c969c744@mail.gmail.com>
Subject: Re: Bug: 2.6.32 ath5k, unable to connect to AP on channel 13
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	"John S. Skogtvedt" <jss@bzz.no>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/25 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Mon, Jan 25, 2010 at 6:51 PM, Bob Copeland <me@bobcopeland.com> wrote:
>> On Sun, Jan 24, 2010 at 4:12 PM, John S. Skogtvedt <jss@bzz.no> wrote:
>>> Hello,
>>>
>>> As the subject says, using ath5k on 2.6.32 I am not able to connect to
>>> an AP on channel 13 (i.e. wpa_supplicant doesn't find the AP and thus
>>> fails to associate). I'm in Norway, and the card is bought in Norway.
>>
>>> dmesg output:
>>> [    7.205952] cfg80211: Using static regulatory domain info
>>> [    7.205956] cfg80211: Regulatory domain: US
>>> [    7.206243] cfg80211: Calling CRDA for country: US
>>
>> Well, there's your problem, AFAICT.  You have
>> CONFIG_WIRELESS_OLD_REGULATORY=y?  And ieee80211_regdom=EU doesn't work?

OLD_REG is exactly that, old regulatory, new regulatory stuff does not
know anything about EU as EU is not a country. OLD_REG is in fact
removed from the latest wireless-testing.git so I recommend debian
just abandon it.

>>> [    7.887265] ath: EEPROM regdomain: 0x80d0
>>> [    7.887267] ath: EEPROM indicates we should expect a country code
>>> [    7.887270] ath: doing EEPROM country->regdmn map search
>>> [    7.887272] ath: country maps to regdmn code: 0x37
>>> [    7.887275] ath: Country alpha2 being used: DK
>>> [    7.887277] ath: Regpair used: 0x37
>>> [    8.288352] ath5k phy0: Atheros AR2414 chip found (MAC: 0x79, PHY: 0x45)
>>> [    8.288607] cfg80211: Calling CRDA for country: DK
>>
>> Denmark, which should allow the channels in question.
>
> However, does the DK regdomain really get set? Is CRDA installed?
>
>> CCed Luis in case he has anything to add.

Yea not sure if debian ships crda and wireless-regdb yet.

  Luis
