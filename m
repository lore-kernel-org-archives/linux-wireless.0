Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.getmail.no ([84.208.15.66]:43713 "EHLO
	get-mta-out02.get.basefarm.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750893Ab0AYT0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 14:26:39 -0500
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Received: from smtp.getmail.no ([10.5.16.4]) by get-mta-out02.get.basefarm.net
 (Sun Java(tm) System Messaging Server 7.0-0.04 64bit (built Jun 20 2008))
 with ESMTP id <0KWT006HPI0ECHA0@get-mta-out02.get.basefarm.net> for
 linux-wireless@vger.kernel.org; Mon, 25 Jan 2010 20:26:38 +0100 (MET)
Received: from [192.168.1.10] ([84.208.235.192])
 by get-mta-in02.get.basefarm.net
 (Sun Java(tm) System Messaging Server 7.0-0.04 64bit (built Jun 20 2008))
 with ESMTPA id <0KWT00MSZI0CQM30@get-mta-in02.get.basefarm.net> for
 linux-wireless@vger.kernel.org; Mon, 25 Jan 2010 20:26:38 +0100 (MET)
Message-id: <4B5DF06C.60000@bzz.no>
Date: Mon, 25 Jan 2010 20:26:36 +0100
From: "John S. Skogtvedt" <jss@bzz.no>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Bug: 2.6.32 ath5k, unable to connect to AP on channel 13
References: <4B5CB7AB.7010105@bzz.no>
 <b6c5339f1001250951u548e6a16raf661464660ec577@mail.gmail.com>
 <69e28c911001251030p79f00ea1j23f95b5e2f8571a3@mail.gmail.com>
In-reply-to: <69e28c911001251030p79f00ea1j23f95b5e2f8571a3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik skrev:
> On Mon, Jan 25, 2010 at 6:51 PM, Bob Copeland <me@bobcopeland.com> wrote:
>> On Sun, Jan 24, 2010 at 4:12 PM, John S. Skogtvedt <jss@bzz.no> wrote:
>>> Hello,
>>>
>>> As the subject says, using ath5k on 2.6.32 I am not able to connect to
>>> an AP on channel 13 (i.e. wpa_supplicant doesn't find the AP and thus
>>> fails to associate). I'm in Norway, and the card is bought in Norway.
>>> dmesg output:
>>> [    7.205952] cfg80211: Using static regulatory domain info
>>> [    7.205956] cfg80211: Regulatory domain: US
>>> [    7.206243] cfg80211: Calling CRDA for country: US
>> Well, there's your problem, AFAICT.  You have
>> CONFIG_WIRELESS_OLD_REGULATORY=y?  And ieee80211_regdom=EU doesn't work?
>>
>>> [    7.887265] ath: EEPROM regdomain: 0x80d0
>>> [    7.887267] ath: EEPROM indicates we should expect a country code
>>> [    7.887270] ath: doing EEPROM country->regdmn map search
>>> [    7.887272] ath: country maps to regdmn code: 0x37
>>> [    7.887275] ath: Country alpha2 being used: DK
>>> [    7.887277] ath: Regpair used: 0x37
>>> [    8.288352] ath5k phy0: Atheros AR2414 chip found (MAC: 0x79, PHY: 0x45)
>>> [    8.288607] cfg80211: Calling CRDA for country: DK
>> Denmark, which should allow the channels in question.
> 
> However, does the DK regdomain really get set? Is CRDA installed?
> 

Thank you, with CRDA installed it does work.
(Debian doesn't currently package it, but I found a source package in
the RFP bug report:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=536502
)

However, shouldn't it work without CRDA with
CONFIG_WIRELESS_OLD_REGULATORY=y and ieee80211_regdom=EU?

