Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46219 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab2K0Jzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 04:55:48 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so4759879eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 01:55:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50B470CE.8070402@think.ch>
References: <50B470CE.8070402@think.ch>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 27 Nov 2012 20:55:26 +1100
Message-ID: <CAGRGNgVT-Yru2ti9CWgwS5H2cfW=RTeL144zsdAmSRCAsLwOsg@mail.gmail.com> (sfid-20121127_105554_771387_EB07D657)
Subject: Re: regulatory domain settings overwritten
To: Erich Titl <erich.titl@think.ch>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Erich,

On Tue, Nov 27, 2012 at 6:50 PM, Erich Titl <erich.titl@think.ch> wrote:
> Hello
>
> I am trying to set up wireless support on an embedded X86 based device
> (PCengines WRAP) using an atheros based CM-9 card manufactured by
> Wistron Neweb.
>
> I am using cfg80211 with the internal regulatory domain database. I am
> observing the following with dmesg
>
> [  133.324451] cfg80211: Calling CRDA to update world regulatory domain
> [  133.344421] cfg80211: World regulatory domain updated:
> [  133.346021]     (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [  133.347622]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [  133.348902]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,
> 2000 mBm)
> [  133.349842]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
> 2000 mBm)
> [  133.350455]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [  133.351736]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
> 2000 mBm)
> [  133.353431] cfg80211: Calling CRDA for country: CH
> [  133.443881] cfg80211: Regulatory domain changed to country: CH
> [  133.444568]     (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [  133.445486]     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [  133.446397]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [  133.447630]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [  133.448863]     (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
> [  141.971982] ath5k 0000:00:0d.0: registered as 'phy0'
> [  142.453824] ath: EEPROM regdomain: 0x0
> [  142.453881] ath: EEPROM indicates default country code should be used
> [  142.453940] ath: doing EEPROM country->regdmn map search
> [  142.454009] ath: country maps to regdmn code: 0x3a
> [  142.454062] ath: Country alpha2 being used: US
> [  142.454109] ath: Regpair used: 0x3a
> [  146.738786] phy0: Selected rate control algorithm 'minstrel'
> [  146.838666] ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
> [  146.839284] ath5k phy0: RF5112B multiband radio found (0x36)
> [  146.842202] cfg80211: Calling CRDA for country: US
> [  146.936338] cfg80211: Current regulatory domain intersected:
> [  146.937470]     (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [  146.938415]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [  146.939290]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 1700 mBm)
> [  146.940525]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [  146.941758]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [  146.942702]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>
> Although I specify a country code CH at module loading, it appears that
> the athk5 driver is calling cfg80211 with a default country code. Why is
> US the default country code and why is it called at all.

It's not being completely overridden and it is working as designed.

Firstly, the default country code for all Atheros chips is the USA.
This is most likely because that's where the company is based.

Secondly, your choice, China, is not being overridden. As the card is
saying that it's configured for the USA, and you're saying that it's
in China, the regulatory framework is using the intersection of the US
and Chinese rules to govern it's output, thereby ensuring that the
operation of the card complies with all the information it has about
it's location.

This has been explained in more detail in this thread:

http://www.spinics.net/lists/linux-wireless/msg92420.html

If you want to have the complete set of frequencies as specified by
the Chinese rules, you will need to obtain a card which has been
configured for Chinese operation.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
