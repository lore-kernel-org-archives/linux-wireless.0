Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:50594 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab0KBMuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 08:50:18 -0400
Date: Tue, 2 Nov 2010 13:50:07 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Lee <lee-in-berlin@web.de>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
Message-ID: <20101102125007.GA30000@sig21.net>
References: <4CC0D0F6.4080507@web.de>
 <201010290017.13174.helmut.schaa@googlemail.com>
 <4CCB3F24.1030701@web.de>
 <201010301430.15868.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201010301430.15868.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, Oct 30, 2010 at 02:30:15PM +0200, Helmut Schaa wrote:
> Am Freitag 29 Oktober 2010 schrieb Lee:
> > On 29/10/10 00:17, Helmut Schaa wrote:
> > > In commit f1aa4c541e98afa8b770a75ccaa8504d0bff44a7 "rt2x00: Write the BSSID
> > > to register when interface is added" we've added the bssid passing to the
> > > device in AP mode to fix hw crypto on rt2800 devices in AP mode. But maybe
> > > the older devices behave differently and don't like getting a bssid set
> > > in AP mode?
> > >
> > > Lee, if you just revert the commit you've identified are you able to use
> > > the device in AP mode with hw crypto?
> > >
> > Reverting that memcpy() to it's original parameters works for me (AP mode + hw 
> > crypto).
> 
> Thanks for the info Lee. So, in AP mode we need to set the bssid on rt2800
> devices in order to get hw crypto to work but on (at least) rt73 devices we
> may not set the bssid to get hw crypto to work :(
> 
> Ivo, Gertjan, any ideas how to handle that case. I don't feel like introducing
> another device specific flag makes sense here?

Sorry for slow response time.  I can confirm that changing
		rt2x00lib_config_intf(rt2x00dev, intf, vif->type,
				      intf->mac, intf->bssid);
to
		rt2x00lib_config_intf(rt2x00dev, intf, vif->type,
				      intf->mac, NULL);
in rt2x00mac_add_interface() fixes rt73usb AP mode for me, too.
(still using compat-wireless-2.6.36-rc3-1)


While reading through the code I noticed the following in rt2800_config_intf():

		rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_ID_MASK, 3);

However, in Ralink source from http://www.ralinktech.com/support.php?s=2
in DPO_RT3370_LinuxSTA_V2.4.0.1_20100831/include/chip/rtmp_mac.h it says:
                USHORT          BssIdMask:2; // 0: one BSSID, 10: 4 BSSID,  01: 2 BSSID , 11: 8BSSID

This is different from rt73usb where 3 means "one BSSID".
I have not tested this change yet.


Johannes
