Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:65222 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab3KRNgo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 08:36:44 -0500
Message-ID: <528A17EA.1020505@neratec.com> (sfid-20131118_143648_032809_88F17CE4)
Date: Mon, 18 Nov 2013 14:36:42 +0100
From: Matthias May <matthias.may@neratec.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: Sven Eckelmann <sven@open-mesh.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <simon@open-mesh.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [OpenWrt-Devel] ath9k: Deaf QCA9558 when setting
 rxchainmask
References: <19772470.YgPhAz9cYD@bentobox> <87B8D697-4540-4D0E-975B-125531E6833B@net.t-labs.tu-berlin.de> <CAJ-VmombLQqJsN50nndqCioFEOy=9cp_-34onQnWnpMoX6360w@mail.gmail.com> <2985619.kldLYNDlSX@bentobox> <21120.58000.344447.562435@gargle.gargle.HOWL> <528A0F79.1040807@neratec.com> <21130.4681.687594.315193@gargle.gargle.HOWL>
In-Reply-To: <21130.4681.687594.315193@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18/11/13 14:12, Sujith Manoharan wrote:
> Matthias May wrote:
>> I'm in the position where i want to use a 9390 as 2x2 instead of 3x3.
>> I use backports-3.12-1.
>> I've set the rx and tx mask in eeprom to 0x5.
>> Every 30 seconds there is a short disconnect.
>> Enabling some logging in
>> echo "0x0000050C" > /sys/kernel/debug/ieee80211/phy0/ath9k/debug
>> shows that something seems to go wrong during noise calibration. (See
>> attached log).
>> What seems odd to me, that for IQ cal it tries to calibrate chain 1
>> instead of chain 2.
> What is the value of 0x40d8 register ?
>
> echo 0x40d8 > /sys/kernel/debug/ieee80211/phy0/ath9k/regidx
> cat /sys/kernel/debug/ieee80211/phy0/ath9k/regval
>
> Sujith
root@CHD500279:/# echo 0x40d8 > 
/sys/kernel/debug/ieee80211/phy6/ath9k/regidx
root@CHD500279:/# cat /sys/kernel/debug/ieee80211/phy6/ath9k/regval
0x00000004

On another device showing the same behaviour (but with various other 
patches and based on compat-wireless-2013-06-27) 0x04000004.

Best regards
Matthias May

-- 
Matthias May
Software Engineer

Neratec Solutions AG
Postfach 83, CH-8608 Bubikon, Switzerland
Direct: +41 55 253 2074
Office: +41 55 253 2000
Fax:    +41 55 253 2070
email:  matthias.may@neratec.com
Web:   www.neratec.com

