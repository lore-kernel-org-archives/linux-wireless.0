Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:11169 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751120Ab0FQEsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 00:48:25 -0400
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-035170103
	for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 13:48:24 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	=?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Subject: Re: [ath5k-devel] Race condition in CRDA calls?
Date: Thu, 17 Jun 2010 13:47:58 +0900
Cc: "ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <201003251801.57951.8an@praha12.net> <20100526214658.GB10931@tux>
In-Reply-To: <20100526214658.GB10931@tux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201006171347.58712.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi!

are there any news on that? i think i hit the same bug, now...

thanks,
bruno

On Thu May 27 2010 06:46:58 Luis R. Rodriguez wrote:
> Just FYI, you want to use linux-wireless for reporting such things,
> not ath5k-devel. Also I have been real busy in March (and stil am but
> just trying to reply) so if I do not reply maybe others can. In
> linux-wireless you'll likely get much more review/help than ath5k-devel
> for this.
> 
> More below.
> 
> On Thu, Mar 25, 2010 at 10:01:54AM -0700, Lukáš Turek wrote:
> > Hi,
> > 
> > I've been testing current vanilla 2.6.34 from git today on a computer
> > with three Atheros PCI cards and noticed a strange behavior: although
> > all the cards have the same regulatory domain (0x36), only the last one
> > (phy2) had the correct channels enabled, the other two (phy0 and phy1)
> > stayed in US regulatory domain with channels 52-140 disabled.
> > 
> > It seems the reply from CRDA for the first request gets into the kernel
> > after the last card is detected and all the replies get mixed up some
> > way:
> > 
> > ath5k 0000:02:01.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> > ath5k 0000:02:01.0: registered as 'phy0'
> > ath: EEPROM regdomain: 0x36
> > ath: EEPROM indicates we should expect a direct regpair map
> > ath: Country alpha2 being used: CZ
> > ath: Regpair used: 0x36
> > udev: renamed network interface eth0 to eth2
> > udev: renamed network interface eth1_rename to eth0
> > phy0: Selected rate control algorithm 'minstrel'
> > ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
> > ath5k 0000:02:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> > ath5k 0000:02:02.0: registered as 'phy1'
> > ath: EEPROM regdomain: 0x36
> > ath: EEPROM indicates we should expect a direct regpair map
> > ath: Country alpha2 being used: CZ
> > ath: Regpair used: 0x36
> > cfg80211: Calling CRDA for country: CZ
> > phy1: Selected rate control algorithm 'minstrel'
> > ath5k phy1: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
> > ath5k 0000:02:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> > ath5k 0000:02:03.0: registered as 'phy2'
> > ath: EEPROM regdomain: 0x36
> > ath: EEPROM indicates we should expect a direct regpair map
> > ath: Country alpha2 being used: CZ
> > ath: Regpair used: 0x36
> > cfg80211: Calling CRDA for country: CZ
> > udev: renamed network interface wlan1 to wlan3
> > phy2: Selected rate control algorithm 'minstrel'
> > ath5k phy2: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
> > cfg80211: Calling CRDA for country: CZ
> > udev: renamed network interface wlan1 to wlan2
> > cfg80211: Current regulatory domain intersected:
> > (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> > (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> > (2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
> > (2474000 KHz - 2483500 KHz @ 9500 KHz), (N/A, 2000 mBm)
> > (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> > cfg80211: Current regulatory domain intersected:
> > (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> > (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> > (2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
> > (2474000 KHz - 2483500 KHz @ 9500 KHz), (N/A, 2000 mBm)
> > (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> > cfg80211: Current regulatory domain intersected:
> > (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> > (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> > (2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
> > (2474000 KHz - 2483500 KHz @ 9500 KHz), (N/A, 2000 mBm)
> > (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> > 
> > Another reason might be udev messing up with device names. I will try to
> > debug this, but any hints would be greatly appreciated, because there's
> > not much info about the CRDA <-> kernel interaction.
> 
> You forgot to supply the kernel log of when cfg80211 loads, that
> would have been helpful. After cfg80211 loads then leave a window
> open with 'iw event -t' running. Then load ath5k, and if you want to
> debug udev you can use udevadm, for example to debug only
> kernel messages:
> 
> udevadm monitor --environment kernel
> 
> In short cfg80211 will do an intersection if the core had a regulatory
> domain set for some reason and then a driver suggested to use another
> country. If cfg80211 was world roaming and a driver then just used
> a request for CZ then it shuld stick to CZ. If a second device comes
> up with CZ then -EALREADY should be expected IIRC, if this is not happening
> it smells like a bug.
> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
