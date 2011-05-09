Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34909 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1EIIgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 04:36:39 -0400
Subject: Re: [Regression] Problem with rfkill on 2.6.38
From: Johannes Berg <johannes@sipsolutions.net>
To: Colin Guthrie <gmane@colin.guthr.ie>
Cc: linux-wireless@vger.kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	platform-driver-x86@vger.kernel.org
In-Reply-To: <ip6j66$o5f$1@dough.gmane.org> (sfid-20110426_170016_050429_A6E2C01A)
References: <ip6j66$o5f$1@dough.gmane.org>
	 (sfid-20110426_170016_050429_A6E2C01A)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 10:36:35 +0200
Message-ID: <1304930195.3475.17.camel@jlt3.sipsolutions.net> (sfid-20110509_103643_023867_2D660FE3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Colin,

[Matthew, everybody from the platform list, please see
http://mid.gmane.org/ip6j66$o5f$1@dough.gmane.org for the full email
thread]

Sorry, took me a while to get back to your email.

> wifi works fine generally, but after cycling RFKILL I have to reload the
> various modules before it works again.


> [root@jimmy ~]# rmmod dell_laptop

I'm pretty sure this one's at fault, see below.

> Turn back on:
> 
> iwlagn 0000:0b:00.0: RF_KILL bit toggled to enable radio.

See, iwlwifi just reports this from the hw.

> usb 4-2: new full speed USB device using uhci_hcd and address 4

And your BT USB device shows up on the bus too. But then:

> iwlagn 0000:0b:00.0: RF_KILL bit toggled to disable radio.

> usb 4-2: USB disconnect, address 4

iwlwifi reports that it was killed, and your BT USB device disappears.

> I've been looking through the various commits that could come into play
> (although I am sure there are others):

All the commits you listed are related to iwlwifi only. However, we can
see that both wifi and BT are killed again. Therefore, iwlwifi can't be
at fault (its rfkill line is basically a GPIO input, it can't cause BT
to drop from the bus).

The consequence is that the fault must be with dell_laptop, the BIOS is
the only thing that can be causing both to be rf-killed. (I'd also
suspect rfkill, but it has no changes since 2.6.37)

johannes

