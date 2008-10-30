Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:8798 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760810AbYJ3Vr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 17:47:56 -0400
Received: by ey-out-2122.google.com with SMTP id 6so331243eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 14:47:31 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: crash with rt61pci when resuming with card ejected
Date: Thu, 30 Oct 2008 22:47:28 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1225361553.3690.3.camel@johannes.berg>
In-Reply-To: <1225361553.3690.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810302247.28609.IvDoorn@gmail.com> (sfid-20081030_224800_274011_7F655ACF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Maybe it was stupid, but with USB it always works, I suspended, ejected
> the card (because I had to go and didn't want to resume) while suspended
> and resumed when I arrived at uni, to find the laptop crashing.
> 
> http://johannes.sipsolutions.net/files/rt61pci-resume-crash.jpg
> 
> Sorry it's so unreadable, there wasn't much light and I only had my crap
> cell phone.
> 
> Here's some of the backtrace:
> NIP: rt61pci_mcu_request
> LR: rt2x00leds_unregister_led
> 
> rt2x00leds_unregister

Heh well these 2 functions are the most important ones in the trace anyway. ;)
The only reason I see that rt61pci_mcu_request might fail like this is if writel()
crashes when a device is unplugged while a driver still has a reference to the
register base pointer which came from ioremap().
But I don't know if that would be a valid assumption. :S

Ivo
