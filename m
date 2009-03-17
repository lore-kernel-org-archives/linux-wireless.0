Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f168.google.com ([209.85.219.168]:52602 "EHLO
	mail-ew0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbZCQXBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 19:01:12 -0400
Received: by ewy12 with SMTP id 12so239110ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 16:01:09 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt2x00 mesh support
Date: Wed, 18 Mar 2009 00:01:07 +0100
Cc: Antonio Marques <froz@icix.org>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <200903172304.12595.IvDoorn@gmail.com> <1237329348.5100.8.camel@johannes.local>
In-Reply-To: <1237329348.5100.8.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200903180001.07723.IvDoorn@gmail.com> (sfid-20090318_000115_127582_CA85009E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 17 March 2009, Johannes Berg wrote:
> On Tue, 2009-03-17 at 23:04 +0100, Ivo van Doorn wrote:
> 
> > I think I found something interesting in the log from Antonio which does
> > suggest a mac80211 bug:
> > 
> > 
> > > [108565.280398] phy3 -> rt73usb_config_intf: Error - TXRX_CSR9 WRITE:  0x000d0000, READ: 0x000d0000
> > > [108565.385291] phy3 -> rt73usb_write_beacon: Error - TXRX_CSR9 WRITE: 0x00040000, READ: 0x00040000
> > > [108565.492687] phy3 -> rt73usb_kick_tx_queue: Error - TXRX_CSR9  WRITE: 0x001d0000, READ: 0x001d0000
> > 
> > These 3 commands mean that mac80211 has send the beacon data.
> > 
> > > [108565.603206] phy3 -> rt73usb_init_registers: Error - TXRX_CSR9  WRITE: 0x00000000, READ: 0x00000000
> > 
> > This command means that mac80211 uses the start() callback function. This triggers rt2x00 to initialize
> > the registers which resets the beacon generation.
> 
> Strange, that doesn't seem right. If you look at net/mac80211/iface.c,
> you'll see it call ->start(), then ->add_interface(), and later
> ieee80211_start_mesh(), which calls _if_config() and sets
> beacon/beacon_enabled.

ok, I gone through the rt2x00 code a couple of times now to see how this bug can be triggered by rt2x00,
But the only other scenario I could find, is when the open() callback for the netdevice structure doesn't end
with a call to the config() callback function. But as far as I see it that is happening correctly.

Ivo
