Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.216.179]:59571 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbZKFIEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 03:04:51 -0500
Received: by pxi9 with SMTP id 9so558120pxi.4
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 00:04:56 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 6 Nov 2009 00:04:56 -0800
Message-ID: <fd145f7d0911060004j55b06482tca088685d0626249@mail.gmail.com>
Subject: Getting random regulatory domains on boot-up with ath9k
From: Jeffrey Baker <jwbaker@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to work with a card made with Atheros 9280, but I find
that I am getting essentially random regulatory domains.  The very
first time I booted the system, under Linux 2.6.30, I got the country
code AT.  Subsequently I got US.  Then I upgraded to
compat-wireless-2009-11-06 and now I get AW (Aruba).

dmesg says:

ath: EEPROM regdomain: 0x37
ath: EEPROM indicates we should expect a direct regpair map
ath: Country alpha2 being used: AW
ath: Regpair used: 0x37
cfg80211: Calling CRDA for country: AW

Now, my understanding is that 0x37 is world roaming.  The key sentence
from the docs seems to be this:

"Regulatory pair regulatory domains are mapped to the first
ISO-3166-alpha2 country."

Does that mean that AW is the first country code in the 0x37
regulatory pair group?

The result is this list of channels

5180 MHz [36] (30.0 dBm) (passive scanning, no IBSS)
5200 MHz [40] (30.0 dBm) (passive scanning, no IBSS)
5220 MHz [44] (30.0 dBm) (passive scanning, no IBSS)
5240 MHz [48] (30.0 dBm) (passive scanning, no IBSS)
5260 MHz [52] (30.0 dBm) (passive scanning, no IBSS, radar detection)
5280 MHz [56] (30.0 dBm) (passive scanning, no IBSS, radar detection)
5300 MHz [60] (30.0 dBm) (passive scanning, no IBSS, radar detection)
5320 MHz [64] (30.0 dBm) (passive scanning, no IBSS, radar detection)
5500 MHz [100] (disabled)
5520 MHz [104] (disabled)
5540 MHz [108] (disabled)
5560 MHz [112] (disabled)
5580 MHz [116] (disabled)
5600 MHz [120] (disabled)
5620 MHz [124] (disabled)
5640 MHz [128] (disabled)
5660 MHz [132] (disabled)
5680 MHz [136] (disabled)
5700 MHz [140] (disabled)
5745 MHz [149] (30.0 dBm) (passive scanning, no IBSS)
5765 MHz [153] (30.0 dBm) (passive scanning, no IBSS)
5785 MHz [157] (30.0 dBm) (passive scanning, no IBSS)
5805 MHz [161] (30.0 dBm) (passive scanning, no IBSS)
5825 MHz [165] (30.0 dBm) (passive scanning, no IBSS)

... which in summary prevents me from operating an access point in the
5GHz band at all.  The perplexing thing is that I was able to use
channel 36 under kernel.org 2.6.30, so from my perspective that
software was working better than the current software does, and of
course leads me to believe that I can use software to change this card
to FCC regs instead of these frustrating "world" regs which prevent me
from running an AP.

Needless to say, I am perplexed by this behavior. The exact phy is
"Atheros AR9280 Rev:2"

-jwb
