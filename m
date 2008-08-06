Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:34763 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbYHFAhd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 20:37:33 -0400
Subject: Re: [PATCH 00/19] orinoco: WPA for Agere based cards
From: Pavel Roskin <proski@gnu.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Dave <kilroyd@googlemail.com>, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net
In-Reply-To: <1217892514.17793.39.camel@localhost.localdomain>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217822232.10989.13.camel@dv>  <48978C25.601@gmail.com>
	 <1217892514.17793.39.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 20:37:30 -0400
Message-Id: <1217983050.19480.41.camel@dv> (sfid-20080806_023735_541433_E4C5BDA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-08-04 at 19:28 -0400, Dan Williams wrote:
> > I'm not familiar with the difference between WPA/WPA2. Is that expected to work?
> 
> Depends; if it's WPA2/RSN + AES-CCMP, then most likely not, because I'm
> pretty sure the cards won't have onboard AES crypto acceleration
> hardware.  Most cards built before WPA2/RSN was standardized don't have
> the horsepower to do AES in firmware purely in software either.
> 
> But you might be able to get away with WPA2/RSN + TKIP if the AP allows
> this configuration.  In that configuration, the only difference between
> WPA and WPA2/RSN would be the information element IDs, really.  But if
> the firmware itself doesn't say it supports WPA on whatever website it
> came from, then likely the card won't do WPA2/RSN either.
> 
> In fact, you already did the right thing by _NOT_ adding
> IW_ENC_CAPA_WPA2 and IW_ENC_CAPA_CIPHER_CCMP in the GIWRANGE handler.
> Thus, you have not signaled that WPA2 is supported by the driver, and
> thus Pavel should not have expected it to work in the first place :)

Perhaps wpa_supplicant should have told me that.

I tried association to hostapd with madwifi, and the only working
configuration is WPA1 only with TKIP.  Even enabling WPA1 and WPA2 and
TKIP makes the connection fail.  Forcing WPA1 and TKIP in
wpa_supplicant.conf doesn't help.

I looked at the patches.  They have references to TKIP, but not to CCMP.
Yet it would be nice if we could support WPA1+WPA2, as we cannot require
that access points stop supporting WPA2, which is the 802.11i standard.
It's possible that we have an issue outside the driver.

> > > [185219.617236] eth1: Ext scan results too large (272 bytes).
> Truncating
> > > results to 270 bytes.

It can even be 296 bytes if I enable WPA1 and WPA2.  But this only
happens with an 802.11n router (D-Link DIR-615).  There are no such
complaints about hostapd+madwifi.  Perhaps 802.11n provides more data in
beacons.

I tried increasing the "data" size from 200 to 300 in hermes.h, and the
message went away.  I was able to associate to D-Link DIR-615 when it
was set to WPA1.  Setting it to WPA1+WPA2 caused connection to fail,
just like it happened with hostapd.  Scanning confirms that the cipher
for WPA1 is TKIP.

I think it should be safe to increase the side of "data" and remove the
unused "flags" filed at the end.  After all, we should trust the
firmware, not the unmaintained Agere driver.  If the firmware says it
has 296 bytes for us (header + "data"), why mistrust it?  I understand
if the firmware tells us it has 4 gigabytes of data from the beacon,
then it's clearly lying.  Let's make "data" 256 bytes to make it a nice
round number.  It would gives us 56 extra bytes, and we need extra 36
bytes in the worst case I could produce.

I'm sorry, I'm going to be offline soon, and I really cannot do any more
tests.

-- 
Regards,
Pavel Roskin
