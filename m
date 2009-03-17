Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f168.google.com ([209.85.219.168]:43810 "EHLO
	mail-ew0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbZCQWER (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 18:04:17 -0400
Received: by ewy12 with SMTP id 12so225082ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 15:04:14 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt2x00 mesh support
Date: Tue, 17 Mar 2009 23:04:12 +0100
Cc: Antonio Marques <froz@icix.org>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <200903172250.02427.IvDoorn@gmail.com> <1237326824.10264.3.camel@johannes.local>
In-Reply-To: <1237326824.10264.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200903172304.12595.IvDoorn@gmail.com> (sfid-20090317_230419_312427_8EFA85A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 17 March 2009, Johannes Berg wrote:
> On Tue, 2009-03-17 at 22:50 +0100, Ivo van Doorn wrote:
> 
> > > 
> > > Actually, it does, in ieee80211_start_mesh(). I have no idea then.
> > 
> > I understood that in normal master mode rt73usb doesn't scan either,
> > so my bet is that the bug is in rt2x00. :)
> 
> But the bug seems to hit almost all other drivers too, which confuses
> me. I'd double-check that the _start_mesh() call actually goes through
> and a beacon is available at that point...

I think I found something interesting in the log from Antonio which does
suggest a mac80211 bug:


> [108565.280398] phy3 -> rt73usb_config_intf: Error - TXRX_CSR9 WRITE:  0x000d0000, READ: 0x000d0000
> [108565.385291] phy3 -> rt73usb_write_beacon: Error - TXRX_CSR9 WRITE: 0x00040000, READ: 0x00040000
> [108565.492687] phy3 -> rt73usb_kick_tx_queue: Error - TXRX_CSR9  WRITE: 0x001d0000, READ: 0x001d0000

These 3 commands mean that mac80211 has send the beacon data.

> [108565.603206] phy3 -> rt73usb_init_registers: Error - TXRX_CSR9  WRITE: 0x00000000, READ: 0x00000000

This command means that mac80211 uses the start() callback function. This triggers rt2x00 to initialize
the registers which resets the beacon generation.

So the problem seems to be that mac80211 first sends the beacon to the driver and then starts the interface
in which case I bet most drivers/hardware reset beacon generation. So now the driver will be waiting for
new beacons from mac80211 which probably won't provide that until a scan command is issued.

Ivo
