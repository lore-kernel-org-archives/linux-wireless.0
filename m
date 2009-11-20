Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63569 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbZKTXdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 18:33:50 -0500
Received: by bwz27 with SMTP id 27so3835759bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2009 15:33:55 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [RFC] p54: software hot-swap eeprom image
Date: Sat, 21 Nov 2009 00:33:49 +0100
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dan Williams <dcbw@redhat.com>
References: <200911202027.13284.chunkeey@googlemail.com> <87y6m1aqro.fsf@purkki.valot.fi>
In-Reply-To: <87y6m1aqro.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911210033.49887.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 November 2009 21:24:27 Kalle Valo wrote:
> Christian Lamparter <chunkeey@googlemail.com> writes:
> 
> > This (aggregated) patch adds a new sysfs file "eeprom_overwrite"
> > which can be used to upload an customized eeprom image to the
> > driver during normal operation.
> >
> > The old wlanX device will quickly vanish. And if the new EEPROM
> > image passes all sanity checks the device will reappear.
> >
> > Hopefully, this proves to be an adequate solution for everyone
> > with a bad/missing EEPROM data/chip.
> 
> Wasn't the concensus that request_firmware() will be used for this
> kind of device specific data? stlc45xx had a similar sysfs interface
> and people didn't like it. And I tend to agree with them, adding odd
> sysfs files is not the best way to handle this.

no, I wanted something that could fix every possible problem.

I know of several different devices which could use more or
less the same fixes, but we want to retain the mac-addresses, 
baseband/mac processor info, PHYs and hw-layout related features
(or in other words: 95% of the eeprom _other_ content).

Here's *real* list of the problems:
p54pci devices:
1. CardBus Netgear WG511 (duette phy / ISL3880 mac)
		- (no country code)
		- (disabled antenna diversity)
		- *swapped rssi<->dbm parameters*
		  => affects internal calibration and link stability,
			 renders dBm reading totally useless,

2. miniPCI ZComax XG-601 (frisbee phy / ISL3880 mac)
		- (no country code)
		- (disabled antenna diversity)

3. miniPCI ZComax XG-603 (frisbee phy / ISL3886 mac)
		- (no country code)
		- (disabled antenna diversity)
		- *fixed* output power limits
		  (the card _only_ transmits @ 14 dBm)

4. miniPCI Allnet 271 (frisbee phy / ISL3880 mac)
		- (no country code)
		- (disabled antenna diversity)

5. James' minipci Gigafast WF728-AEX (frisbee phy / isl3880 mac)
		- (no country code)
		- (disabled antenna diversity)
		- incomplete phy calibration data
		  => card only works on channel 1, 7, 12, 14

p54usb devices:
1. Dell 1450 USB (crossbow phy / ISL3892 mac)
		- *wrong* country code
		  (disables all non-US channels, even though it's OK to use them in the EU)
	   	- disabled antenna diversity

Or in other words, I haven't come a cross a single p54 device with
a proper EEPROM since I picked up my first card 3/4 years ago...

anyway, I had to think about it again:
eeprom_overwrite is no longer meant to fully replace the onboard eeprom, or
in p54spi's case the supplied (minimal) blob data. It should (not yet, but
hopefully in the next RFC, if we all agree on something) merely allow
users to fix the faulty pieces without altering the unaffected bits 
(like volatile patch deltas for the static const eeprom).
In fact I gave it a new name already: volatile_eeprom_patch :-D .

I'm unsure about ethtool --eeprom-load. Because unlike --change-eeprom,
we won't be able to mess around with low-level physical bits flipping
in the EEPROM itself, so people might get confused why they _setting_
doesn't stick over modules reloads/reboots etc...

Regards,
	Chr

---
damn bugs!
