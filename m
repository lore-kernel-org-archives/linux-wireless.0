Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43021 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab0KCPWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 11:22:45 -0400
Received: by gxk23 with SMTP id 23so557777gxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 08:22:44 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond authentication (2.6.36, rt73usb)
Date: Wed, 3 Nov 2010 16:21:48 +0100
Cc: Ivo Van Doorn <ivdoorn@gmail.com>, Lee <lee-in-berlin@web.de>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
References: <4CC0D0F6.4080507@web.de> <AANLkTint5Y0X4F_OcvwWLxYhScf=sTZ2cD4gq-sMoNmy@mail.gmail.com> <20101103145950.GA5798@sig21.net>
In-Reply-To: <20101103145950.GA5798@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011031621.48923.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 03 November 2010 schrieb Johannes Stezenbach:
> On Wed, Nov 03, 2010 at 03:51:52PM +0100, Ivo Van Doorn wrote:
> > On Wed, Nov 3, 2010 at 3:14 PM, Johannes Stezenbach <js@sig21.net> wrote:
> > > On Tue, Nov 02, 2010 at 01:50:07PM +0100, Johannes Stezenbach wrote:
> > >>
> > >> While reading through the code I noticed the following in rt2800_config_intf():
> > >>
> > >>               rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_ID_MASK, 3);
> > >>
> > >> However, in Ralink source from http://www.ralinktech.com/support.php?s=2
> > >> in DPO_RT3370_LinuxSTA_V2.4.0.1_20100831/include/chip/rtmp_mac.h it says:
> > >>                 USHORT          BssIdMask:2; // 0: one BSSID, 10: 4 BSSID,  01: 2 BSSID , 11: 8BSSID
> > >>
> > >> This is different from rt73usb where 3 means "one BSSID".
> > >
> > > Any comments on this?
> > 
> > Well RT3370 isn't rt73 ;)
> > Instead (altough I don't know this exact chipset), I suspect it to be
> > of the rt2800 family.
> 
> OK, seems hat I wrote was confusing.
> 
> rt73usb sets the field to 3 (meaning "one BSSID").
> 
> But rt2800usb also sets it to 3, but it should be 0 (in rt2800_config_intf).

I would be fine with setting this to 0 but only in STA and IBSS mode. At
least in AP mode we want to keep the max value to be able to use multiple
AP mode interfaces.

Helmut
