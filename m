Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36364 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab1LVLL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 06:11:59 -0500
Received: by wgbdr13 with SMTP id dr13so15723364wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Dec 2011 03:11:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAApCBGx28SbbmNpynCpKW9CyAsV5+c_fZ=1k9QAsKnXf4nDQEw@mail.gmail.com>
References: <CAApCBGx28SbbmNpynCpKW9CyAsV5+c_fZ=1k9QAsKnXf4nDQEw@mail.gmail.com>
Date: Thu, 22 Dec 2011 13:11:58 +0200
Message-ID: <CAApCBGx7fHuQr87TnppE6FyX9d-1F0huUqgYhjv++8vmfov6zQ@mail.gmail.com> (sfid-20111222_121203_221077_B579182E)
Subject: Re: ar9390 failing AGC calibration on powerpc platform
From: wireless newbie <wnewbie72@gmail.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: Felix Fietkau <nbd@openwrt.org>, openwrt-devel@lists.openwrt.org,
	Mohammed Shafi <shafi.wireless@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

I still haven't been able to get this thing working. But I have made
some tests on other powerpc target (mpc8315 cpu versus mpc8321 cpu on
my own target) and I can tell that this problem doesn't seem to be
related to big endian environment. Ar9390 works just fine with
mpc8315. The difference between those two targets is that 8315 has
pcie bus whereas my own target's pcie bus is behind pci-to-pcie bridge
(PLX PEX8112).

Is anyone aware of any limitations or bugs related to using ar9390
behind pci-to-pcie bridge? All help is really appreciated.


2011/11/29 wireless newbie <wnewbie72@gmail.com>:
> Hi,
>
> I have been trying to get my ar9390 based wlan module to work as an AP
> on my powerpc target. There seems to be some issues with AGC
> calibration though. As soon as I start hostapd, I get the following:
>
> ath9k 0000:01:00.0: mon.wlan0: Features changed: 0x00004800 -> 0x00004000
> ath: Unable to reset hardware; reset status -5 (freq 2412 MHz)
> Could not set interface mon.wlan0 flags: Input/output error
> nl80211: Failed to set interface wlan0 into AP mode
> nl80211 driver initialization failed.
> ELOOP: remaining socket: sock=8 eloop_data=0x10219770
> user_data=0x10219d18 handler=0x1002b8c0
> ELOOP: remaining socket: sock=10 eloop_data=0x1021c0b8 user_data=(nil)
> handler=0x100353e0
>
> Further debugging revealed that the problem was AGC calibration that
> didn't finish and that can be seen from the logs too:
>
> ath: timeout (100000 us) on reg 0xa2c4: 0x00158dd9 & 0x00000001 != 0x00000000
>
> I moved that module to x86 ubuntu 11.10 pc to see if it works there.
> For my surprise it worked just fine. So it seems that there is
> something related to powerpc platform. I'm using kernel 2.6.39 and
> compat wireless drivers from november. Would it be possible that there
> is some endianess stuff somewhere that isn't handled properly?
