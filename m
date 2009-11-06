Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:41197 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759356AbZKFQVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 11:21:23 -0500
Received: by iwn10 with SMTP id 10so892347iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 08:21:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fd145f7d0911060004j55b06482tca088685d0626249@mail.gmail.com>
References: <fd145f7d0911060004j55b06482tca088685d0626249@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 6 Nov 2009 08:21:08 -0800
Message-ID: <43e72e890911060821r2703c186lbb75c40b449b2c55@mail.gmail.com>
Subject: Re: Getting random regulatory domains on boot-up with ath9k
To: Jeffrey Baker <jwbaker@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 6, 2009 at 12:04 AM, Jeffrey Baker <jwbaker@gmail.com> wrote:
> I am trying to work with a card made with Atheros 9280, but I find
> that I am getting essentially random regulatory domains.  The very
> first time I booted the system, under Linux 2.6.30, I got the country
> code AT.

That just happened to be the first alpha2 in the countries array on
the Atheros driver's country table which mapped 0x37 to an alpha2.
Either way it could have been any of the other alpha2s that map to
0x37 as well.

> Subsequently I got US.

I would need more full logs to analyze this, but it definitely would
not be expected to have come from the ath9k code. The US happened to
be default if you have CONFIG_WIRELESS_OLD_REGULATORY and hence why
this is called OLD, it was the old regulatory implementation. You can
also get US regulatory domain request through an AP country
information element. For atheros wireless cards that are already
programmed to follow a country regulatory domain though (ie: not a
world roaming regulatory domain) the country IE would just enhance
regulatory restrictions further -- it won't enable new channels.

> Then I upgraded to
> compat-wireless-2009-11-06 and now I get AW (Aruba).

Right, AW is now the first country that maps to 0x37, this was changed
on a recent patch.

> dmesg says:
>
> ath: EEPROM regdomain: 0x37
> ath: EEPROM indicates we should expect a direct regpair map
> ath: Country alpha2 being used: AW
> ath: Regpair used: 0x37
> cfg80211: Calling CRDA for country: AW
>
> Now, my understanding is that 0x37 is world roaming.

Actually no, that is not the case. 0x37 maps to ETSI1_WORLD which also
does have the postfix WORLD it does not mean its a world roaming
regulatory domain. The _WORLD postfix just annotates to the developer
that the 2 GHz regulatory SKU is one which world roams, but this is
more of an implementation detail and has nothing to do with real world
roaming regulatory domains. Real Atheros world regulatory domains have
0x60 in them, so this would be 0x61, 0x62, etc. These *are world
roaming* regulatory domain in the sense that static world regulatory
domains have been defined statically in the ath.ko module *and*
typically this also means passive scan is preferred on certain
channels which would otherwise remain disabled in certain countries,
just as beaconing is also disabled (this is called NO-IBSS flag). Now,
cfg80211 then has world roaming enhancements which *lift* the passive
scan and no-ibss (beaconing) flag if a channel has been found though
so you happened to have a world roaming card on 5 GHz you essentially
would be able to enable IBSS or AP mode of operation if a nearby AP
was found through an initial scan.

> The key sentence
> from the docs seems to be this:
>
> "Regulatory pair regulatory domains are mapped to the first
> ISO-3166-alpha2 country."
>
> Does that mean that AW is the first country code in the 0x37
> regulatory pair group?

Now it is, before it was AT.

> The result is this list of channels
>
> 5180 MHz [36] (30.0 dBm) (passive scanning, no IBSS)
> 5200 MHz [40] (30.0 dBm) (passive scanning, no IBSS)
> 5220 MHz [44] (30.0 dBm) (passive scanning, no IBSS)
> 5240 MHz [48] (30.0 dBm) (passive scanning, no IBSS)
> 5260 MHz [52] (30.0 dBm) (passive scanning, no IBSS, radar detection)
> 5280 MHz [56] (30.0 dBm) (passive scanning, no IBSS, radar detection)
> 5300 MHz [60] (30.0 dBm) (passive scanning, no IBSS, radar detection)
> 5320 MHz [64] (30.0 dBm) (passive scanning, no IBSS, radar detection)
> 5500 MHz [100] (disabled)
> 5520 MHz [104] (disabled)
> 5540 MHz [108] (disabled)
> 5560 MHz [112] (disabled)
> 5580 MHz [116] (disabled)
> 5600 MHz [120] (disabled)
> 5620 MHz [124] (disabled)
> 5640 MHz [128] (disabled)
> 5660 MHz [132] (disabled)
> 5680 MHz [136] (disabled)
> 5700 MHz [140] (disabled)
> 5745 MHz [149] (30.0 dBm) (passive scanning, no IBSS)
> 5765 MHz [153] (30.0 dBm) (passive scanning, no IBSS)
> 5785 MHz [157] (30.0 dBm) (passive scanning, no IBSS)
> 5805 MHz [161] (30.0 dBm) (passive scanning, no IBSS)
> 5825 MHz [165] (30.0 dBm) (passive scanning, no IBSS)
>
> ... which in summary prevents me from operating an access point in the
> 5GHz band at all.

Yes, unfortunately when Atheros cards are programmed with a country
code the world roaming enhancement I described above does not apply
which would otherwise have at least enabled AP / IBSS mode of
operation if at least any of your local neighbors did have an AP on
any of the passive-scan/no-ibss channels.

But -- as it so happens "AW" has no entry on db.txt therefore making
0x37 cards stuck with non-world roaming capabilities but since CRDA
does not find any regulatory domain the card essentially *is* stuck
world roaming.

> The perplexing thing is that I was able to use
> channel 36 under kernel.org 2.6.30, so from my perspective that
> software was working better than the current software does,

You can interpret that as however you want, the real fact is just that
AT did have an entry on db.txt which does consist of at least a set of
5 GHz channels which do enable AP mode of operation:

country AT:
        (2402 - 2482 @ 40), (N/A, 20)
        (5170 - 5250 @ 40), (N/A, 20)
        (5250 - 5330 @ 40), (N/A, 20), DFS
        (5490 - 5710 @ 40), (N/A, 27), DFS

> and of
> course leads me to believe that I can use software to change this card
> to FCC regs instead of these frustrating "world" regs which prevent me
> from running an AP.

You have a few twisted statements here but let me order them up and
fix the for you:

  * If you happen to have an Atheros card with a region code and that
region code maps to an alpha2 for which CRDA does not have an entry
for yet your card will remain world roaming if you did not enable
CONFIG_WIRELESS_OLD_REGULATORY as the default under the new regulatory
framework is to world roam. If you did enable
CONFIG_WIRELESS_OLD_REGULATORY though your default would be the static
US rules followed by a request to CRDA for the US regulatory domain.

  * What you have found is a regression introduced by the patch titled
"ath: Updates for regulatory and country codes" and its caused by your
region code not having a mapped regulatory domain on db.txt, as AW has
no entry yet on wireless-regdb.

  * The fix for the regression would be to either use an alpha2 which
does have an entry and put that first in the array *or* (my
preference) to check first the alpha2 set on cfg80211 and see if that
maps to a country allowed by your region code and if so get cfg80211
to request that regulatory domain to CRDA.

  * On modern 802.11 cards you typically can somehow change the
regulatory domain one way or another:

  - Reverse engineering of driver
  - Reprogramming of an EEPROM
  - Modifying open drivers or open regulatory databases and signing
off on these changes

Most Linux distributions today do ship a crda with RSA key support
which protect usage against a non-authored-and-trusted regulatory.bin.
You can obviosly modify and build your own crda and wireless-regdb but
this would be an act an end user does.

So one way or another user intervention is required to alter current
regulatory solutions. For Linux though the best solution *as an end
user* to enable AP mode is not to alter wireless-regdb but instead to
report your issue. In your case you have a non-trivial regression
which does indeed need to be addressed.

> Needless to say, I am perplexed by this behavior. The exact phy is
> "Atheros AR9280 Rev:2"

Thanks for the report, we'll cook up a fix and have you test it.

  Luis
