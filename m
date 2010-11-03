Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:57362 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242Ab0KCO7y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 10:59:54 -0400
Date: Wed, 3 Nov 2010 15:59:50 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Lee <lee-in-berlin@web.de>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
Message-ID: <20101103145950.GA5798@sig21.net>
References: <4CC0D0F6.4080507@web.de>
 <201010290017.13174.helmut.schaa@googlemail.com>
 <4CCB3F24.1030701@web.de>
 <201010301430.15868.helmut.schaa@googlemail.com>
 <20101102125007.GA30000@sig21.net>
 <20101103141413.GA5364@sig21.net>
 <AANLkTint5Y0X4F_OcvwWLxYhScf=sTZ2cD4gq-sMoNmy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTint5Y0X4F_OcvwWLxYhScf=sTZ2cD4gq-sMoNmy@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 03, 2010 at 03:51:52PM +0100, Ivo Van Doorn wrote:
> On Wed, Nov 3, 2010 at 3:14 PM, Johannes Stezenbach <js@sig21.net> wrote:
> > On Tue, Nov 02, 2010 at 01:50:07PM +0100, Johannes Stezenbach wrote:
> >>
> >> While reading through the code I noticed the following in rt2800_config_intf():
> >>
> >>               rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_ID_MASK, 3);
> >>
> >> However, in Ralink source from http://www.ralinktech.com/support.php?s=2
> >> in DPO_RT3370_LinuxSTA_V2.4.0.1_20100831/include/chip/rtmp_mac.h it says:
> >>                 USHORT          BssIdMask:2; // 0: one BSSID, 10: 4 BSSID,  01: 2 BSSID , 11: 8BSSID
> >>
> >> This is different from rt73usb where 3 means "one BSSID".
> >
> > Any comments on this?
> 
> Well RT3370 isn't rt73 ;)
> Instead (altough I don't know this exact chipset), I suspect it to be
> of the rt2800 family.

OK, seems hat I wrote was confusing.

rt73usb sets the field to 3 (meaning "one BSSID").

But rt2800usb also sets it to 3, but it should be 0 (in rt2800_config_intf).
I assumed this is a copy&paste mistake.
My device has rt3070 chipset.


Johannes
