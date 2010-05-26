Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56216 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab0EZRLi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 13:11:38 -0400
Received: by pwi7 with SMTP id 7so292553pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 10:11:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BFD04A4.4000403@nets.rwth-aachen.de>
References: <4BFD04A4.4000403@nets.rwth-aachen.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 10:11:16 -0700
Message-ID: <AANLkTik5BnKa7eP4U2Qq6uDYiRk_uc47IpslpFeC0l9r@mail.gmail.com>
Subject: Re: regulatory problems with ath5k
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
	David Quan <David.Quan@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 26, 2010 at 4:23 AM, Arnd Hannemann
<hannemann@nets.rwth-aachen.de> wrote:
> Hi,
>
> I'm trying to use 802.11a channels in AP mode with my ath5k nics with kernel 2.6.34.
> And after setting up crda, udev and wireless regdb,

Which release of wireless-regdb?

> "iw list" still shows flags
> "passive scanning, no IBSS" for most of the 802.11a channels (see below.)
>
> I wonder what I'm doing wrong here?

Lets take a look.

>
>        Band 2:
>                Frequencies:
>                        * 5180 MHz [36] (20.0 dBm) (radar detection)
>                        * 5200 MHz [40] (20.0 dBm) (radar detection)
>                        * 5220 MHz [44] (20.0 dBm) (radar detection)
>                        * 5240 MHz [48] (20.0 dBm) (radar detection)
>                        * 5260 MHz [52] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5280 MHz [56] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5300 MHz [60] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5320 MHz [64] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5500 MHz [100] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5520 MHz [104] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5540 MHz [108] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5560 MHz [112] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5580 MHz [116] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5600 MHz [120] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5620 MHz [124] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5640 MHz [128] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5660 MHz [132] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5680 MHz [136] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>                        * 5700 MHz [140] (26.0 dBm) (passive scanning, no IBSS, radar detection)


Please do: 'iw reg get' and paste the output here, the above channels
should not be passive scan/no-ibss for 'DE'.

>                        * 5745 MHz [149] (disabled)
>                        * 5765 MHz [153] (disabled)
>                        * 5785 MHz [157] (disabled)
>                        * 5805 MHz [161] (disabled)
>                        * 5825 MHz [165] (disabled)
>
> hannemann@mrouter46:~ $ sudo iw reg get
> country DE:
>        (2400 - 2483 @ 40), (N/A, 20)
>        (5150 - 5350 @ 40), (N/A, 20), NO-OUTDOOR, DFS
>        (5470 - 5725 @ 40), (N/A, 26), NO-OUTDOOR, DFS
>
> dmesg snippet:
>
> May 26 12:10:36 mrouter46 kernel: [   30.023089] console [netcon0] enabled
> May 26 12:10:36 mrouter46 kernel: [   30.023103] netconsole: network logging started
> May 26 12:10:36 mrouter46 kernel: [   30.314702] cfg80211: Calling CRDA to update world regulatory domain
> May 26 12:10:37 mrouter46 kernel: [   30.555745] ath5k 0000:00:0c.0: registered as \'phy0\'
> May 26 12:10:37 mrouter46 kernel: [   31.039151] ath: EEPROM regdomain: 0x8114

WTF your EEPROM has 0x8114 set on the regulatory domain. David, have
you ever seen such a thing? This kernel (2.6.34) should already have
an ath5k EEPROM checksum check so the EEPROM should be valid. Lets
figure this out first before digging more into this.

Some more notes below though.

> May 26 12:10:37 mrouter46 kernel: [   31.039168] ath: EEPROM indicates we should expect a country code
> May 26 12:10:37 mrouter46 kernel: [   31.039188] ath: doing EEPROM country->regdmn map search
> May 26 12:10:37 mrouter46 kernel: [   31.039205] ath: country maps to regdmn code: 0x37
> May 26 12:10:37 mrouter46 kernel: [   31.039222] ath: Country alpha2 being used: DE
> May 26 12:10:37 mrouter46 kernel: [   31.039237] ath: Regpair used: 0x37
> May 26 12:10:37 mrouter46 kernel: [   31.054155] cfg80211: World regulatory domain updated:

So cfg80211 *first* starts out with the world regulatory domain by
default, and then it will call CRDA for DE since your regpair mapped
to 'DE'.

> May 26 12:10:37 mrouter46 kernel: [   31.054178]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> May 26 12:10:37 mrouter46 kernel: [   31.054207]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> May 26 12:10:37 mrouter46 kernel: [   31.054232]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> May 26 12:10:37 mrouter46 kernel: [   31.054258]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> May 26 12:10:37 mrouter46 kernel: [   31.054284]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> May 26 12:10:37 mrouter46 kernel: [   31.054310]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> May 26 12:10:38 mrouter46 kernel: [   31.212057] phy0: Selected rate control algorithm \'minstrel\'
> May 26 12:10:38 mrouter46 kernel: [   31.212732] ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
> May 26 12:10:38 mrouter46 kernel: [   31.212732] ath5k phy0: RF5112B multiband radio found (0x36)
> May 26 12:10:38 mrouter46 kernel: [   31.212732] ath5k 0000:00:0e.0: registered as \'phy1\'
> May 26 12:10:38 mrouter46 kernel: [   31.622592] cfg80211: Calling CRDA for country: DE

Here is the call for 'DE'

> May 26 12:10:38 mrouter46 kernel: [   31.688006] cfg80211: Regulatory domain changed to country: DE
> May 26 12:10:38 mrouter46 kernel: [   31.688030]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> May 26 12:10:38 mrouter46 kernel: [   31.688057]     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
> May 26 12:10:38 mrouter46 kernel: [   31.688080]     (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> May 26 12:10:38 mrouter46 kernel: [   31.688103]     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
> May 26 12:10:38 mrouter46 kernel: [   31.745694] ath: EEPROM regdomain: 0x8114
> May 26 12:10:38 mrouter46 kernel: [   31.745694] ath: EEPROM indicates we should expect a country code
> May 26 12:10:38 mrouter46 kernel: [   31.745694] ath: doing EEPROM country->regdmn map search
> May 26 12:10:38 mrouter46 kernel: [   31.745694] ath: country maps to regdmn code: 0x37
> May 26 12:10:38 mrouter46 kernel: [   31.745694] ath: Country alpha2 being used: DE
> May 26 12:10:38 mrouter46 kernel: [   31.745694] ath: Regpair used: 0x37
> May 26 12:10:38 mrouter46 kernel: [   31.758662] phy1: Selected rate control algorithm \'minstrel\'
> May 26 12:10:38 mrouter46 kernel: [   31.759383] ath5k phy1: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
> May 26 12:10:38 mrouter46 kernel: [   31.759383] ath5k phy1: RF5112B multiband radio found (0x36)

Do you have two cards?

  Luis
