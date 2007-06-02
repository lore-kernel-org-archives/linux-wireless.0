Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp146.iad.emailsrvr.com ([207.97.245.146]:35547 "EHLO
	smtp146.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761006AbXFBVhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2007 17:37:35 -0400
Received: from [192.168.1.101] (c-24-34-179-5.hsd1.ma.comcast.net [24.34.179.5])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: ddrake@brontes3d.com)
	by relay4.r5.iad.mlsrvr.com (SMTP Server) with ESMTP id 2E2D2C1FB
	for <linux-wireless@vger.kernel.org>; Sat,  2 Jun 2007 17:11:08 -0400 (EDT)
Message-ID: <4661DCC7.7090907@gentoo.org>
Date: Sat, 02 Jun 2007 17:10:31 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mac80211 regulatory domain confusion
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One of the items preventing us moving zd1211rw to mac80211 is the lack
of regulatory domain support in zd1211rw-mac80211.

In the softmac driver, we read the regulatory domain code out of the
EEPROM, and look it up in a driver-supplied "allowed channels" table,
and base future decisions from that.

The current mac80211 port appears to allow all channels everywhere.

I've seen the patch titled "d80211: Allow drivers to configure default
regulatory domain". This is a confusing - if the driver sets the
IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED flag, then
ieee80211_init_client is not called?

If ieee80211_init_client is all about applying a default regulatory
domain to some internal structures, perhaps it should be renamed. If
it's about, say, initializing a wireless client device, perhaps the
check for default regdomain logic should be moved into that function.

Even after reading the discussion following that patch, I'm confused as
to what the driver should be doing and what the stack should be doing.
The ZD1211 hardware is capable of communicating on all channels, but the
software is what enforces the regdomain restrictions.

James Ketrenos wrote:
> "regdomains" are not static maps; they evolve over time as
> governments change their regulations.  The channels and features
> supported by hardware is static based on what the device was
> certified for.

So, this suggests that zd1211rw should be reading the EEPROM, looking up 
allowable channels, and formulating the ieee80211_hw_mode structures 
based on the results.

If we do that, should we also be setting the 
IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED flag? From the description of 
the flag, it sounds like we should:

/* Channels are already configured to the default regulatory domain
  * specified in the device's EEPROM */

We would then bypass various logic in ieee80211_unmask_channel(), but it 
seems to me that the logic there should be being applied regardless of 
whether the driver suggested a regdomain or not. That function is also 
confusing in that it refers to "the firmware" -- whose firmware?

Daniel
