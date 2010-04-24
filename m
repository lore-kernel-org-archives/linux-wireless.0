Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:39154 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729Ab0DXFmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Apr 2010 01:42:20 -0400
Date: Sat, 24 Apr 2010 07:42:10 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: b43 'hardware blocked' but only keyboard/led touch button
Message-ID: <20100424054210.GA23836@frolo.macqel>
References: <4BB1335F.7030306@lwfinger.net> <20100330073401.GA13675@frolo.macqel> <1269967657.3019.16.camel@localhost.localdomain> <20100330171139.GA28367@srcf.ucam.org> <20100330192629.GA24060@frolo.macqel> <20100330193129.GA31847@srcf.ucam.org> <20100419115329.GA5306@frolo.macqel> <20100419145107.GB8017@srcf.ucam.org> <20100419150050.GA28290@frolo.macqel> <20100419150627.GA10680@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100419150627.GA10680@srcf.ucam.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Matthew,

On Mon, Apr 19, 2010 at 04:06:28PM +0100, Matthew Garrett wrote:
> On Mon, Apr 19, 2010 at 05:00:50PM +0200, Philippe De Muyter wrote:
> > On Mon, Apr 19, 2010 at 03:51:07PM +0100, Matthew Garrett wrote:
> > > On Mon, Apr 19, 2010 at 01:53:29PM +0200, Philippe De Muyter wrote:
> > > 
> > > > and the blue/red led doesn't change color, and wifi state does not change
> > > > either.
> > > 
> > > What's the output of the rfkill command now?
> > 
> > Sorry, I cannot answer before friday (not my laptop).
> 
> No problem. The best command to run will be
> 
> rfkill list
> 
> and then just attach the output.

Here you are :

Led is blue, wifi does not work (testing with airodump-ng)

	linux-m1ew:~ # rfkill list
	0: hp-wifi: Wireless LAN
		Soft blocked: yes
		Hard blocked: no
	1: phy0: Wireless LAN
		Soft blocked: yes
		Hard blocked: no
	linux-m1ew:~ # rfkill unblock hp-wifi
	Bogus unblock argument 'hp-wifi'.
	linux-m1ew:~ # rfkill unblock 0
	linux-m1ew:~ # rfkill list
	0: hp-wifi: Wireless LAN
		Soft blocked: no
		Hard blocked: no
	1: phy0: Wireless LAN
		Soft blocked: yes
		Hard blocked: no
	linux-m1ew:~ # rfkill list
	0: hp-wifi: Wireless LAN
		Soft blocked: no
		Hard blocked: no
	1: phy0: Wireless LAN
		Soft blocked: yes
		Hard blocked: no
	linux-m1ew:~ # rfkill unblock 1
	linux-m1ew:~ # rfkill list
	0: hp-wifi: Wireless LAN
		Soft blocked: no
		Hard blocked: no
	1: phy0: Wireless LAN
		Soft blocked: no
		Hard blocked: no
	linux-m1ew:~ # 

Led is still blue, wifi works

Touching the soft key
Led stays blue, wifi does not work anymore (testing with airodump-ng)

	linux-m1ew:~ # rfkill list
	0: hp-wifi: Wireless LAN
		Soft blocked: no
		Hard blocked: yes
	1: phy0: Wireless LAN
		Soft blocked: no
		Hard blocked: yes
	linux-m1ew:~ # dmesg | tail
	[  494.758041] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
	[ 1390.158487] atkbd serio0: Unknown key pressed (translated set 2, code 0x94 on isa0060/serio0).
	[ 1390.158501] atkbd serio0: Use 'setkeycodes e014 <keycode>' to make it known.
	[ 1390.165406] atkbd serio0: Unknown key released (translated set 2, code 0x94 on isa0060/serio0).
	[ 1390.165418] atkbd serio0: Use 'setkeycodes e014 <keycode>' to make it known.
	[ 1390.988287] b43-phy0: Radio hardware status changed to DISABLED
	[ 1390.992840] b43-phy0: Radio turned on by software
	[ 1390.992854] b43-phy0: The hardware RF-kill button still turns the radio physically off. Press the button to turn it on.
	linux-m1ew:~ # 

Touching the soft key again
Led stays blue, wifi works again (testing with airodump-ng)

	linux-m1ew:~ # rfkill list
	0: hp-wifi: Wireless LAN
		Soft blocked: no
		Hard blocked: no
	1: phy0: Wireless LAN
		Soft blocked: no
		Hard blocked: no
	linux-m1ew:~ # dmesg | tail
	[ 1390.988287] b43-phy0: Radio hardware status changed to DISABLED
	[ 1390.992840] b43-phy0: Radio turned on by software
	[ 1390.992854] b43-phy0: The hardware RF-kill button still turns the radio physically off. Press the button to turn it on.
	[ 1447.758302] atkbd serio0: Unknown key pressed (translated set 2, code 0x94 on isa0060/serio0).
	[ 1447.758312] atkbd serio0: Use 'setkeycodes e014 <keycode>' to make it known.
	[ 1447.764038] atkbd serio0: Unknown key released (translated set 2, code 0x94 on isa0060/serio0).
	[ 1447.764048] atkbd serio0: Use 'setkeycodes e014 <keycode>' to make it known.
	[ 1451.008317] b43-phy0: Radio hardware status changed to ENABLED
	[ 1451.252283] b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
	[ 1456.785018] ADDRCONF(NETDEV_UP): wlan0: link is not ready
	linux-m1ew:~ # 

So the problems are :

- often wifi is blocked, but (except for `sudo rfkill' now) my daughter had
no way to enable it,
- the led does not reflect the wifi enabled/disabled state.
- messages from kernel about `Unknown key pressed'

Philippe

Philippe De Muyter  phdm at macqel dot be  Tel +32 27029044
Macq Electronique SA  rue de l'Aeronef 2  B-1140 Bruxelles  Fax +32 27029077
