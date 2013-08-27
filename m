Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab3H0JI5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 05:08:57 -0400
Date: Tue, 27 Aug 2013 11:07:08 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: Fabien ADAM <id2ndr@crocobox.org>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 3.11] rt2800: fix wrong TX power
 compensation
Message-ID: <20130827090707.GB5548@redhat.com> (sfid-20130827_110900_476613_5C5C3914)
References: <20130826131851.GB10525@redhat.com>
 <1377548398.4408.4.camel@mattotaupa>
 <20130827080001.GA2609@redhat.com>
 <1377591765.5019.23.camel@mattotaupa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377591765.5019.23.camel@mattotaupa>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 27, 2013 at 10:22:45AM +0200, Paul Menzel wrote:
> > I checked 2 devices (3071 & 3070) but they have EXTERNAL_TX_ALC bit set.
> > I assume the fix is correct based on vendor driver and it fixes devices
> > which have no EXTERNAL_TX_ACL, but I can not tell what chipset that are.
> > Is possible that the same chipset can be configured with and without
> > EXTERNAL_TX_ALC.
> 
> I have the following device.
> 
>         $ lsusb -s 004
>         Bus 002 Device 004: ID 148f:2870 Ralink Technology, Corp. RT2870 Wireless Adapter
> 
> How do I check if the bit is set? Sometimes the device disconnects when
> being 10 meters away from the access point. The connection is also
> slower than with an ath5k device right next to it.

If you compiled kernel with DEBUGFS support, you can check that by:

mount -t debugfs debugfs /sys/kernel/debug/
cd /sys/kernel/debug/ieee80211/phy0/rt2800usb/register/
echo "0x001b" > eeprom_offset
cat eeprom_value

Second less significant bit is EXTERNAL_TX_ALC .

I think your device has EXTERNAL_TX_ACL since it's older chip, but who
knows ...

Stanislaw


