Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:39712 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761552AbXLMWFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 17:05:53 -0500
Message-ID: <4761ACC7.9050108@jooz.net> (sfid-20071213_220559_479160_9CD2A73A)
Date: Thu, 13 Dec 2007 23:05:59 +0100
From: Bjorge Dijkstra <bjd@jooz.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: status wireless extensions API for new drivers
References: <4761A108.2080005@jooz.net> <1197581585.14270.26.camel@localhost.localdomain>
In-Reply-To: <1197581585.14270.26.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> 
> Quick question about these; does the firmware on the wireless device
> itself talk RNDIS directly?  i.e., is RNDIS intended to replace all the
> manufacturer-specific proprietary host<->adapter protocols?

Yes, the devices themselves talk RNDIS. It's basically Windows NDIS
driver API calls over a USB transport. What I have created is not much
more than a layer that translates the WEXT calls to appropriate RNDIS
messages to allow the device to be configured. The actual networking
part is handled by rndis_host and usbnet.

> How common
> are the devices these days?  I trawled through CDW this weekend and
> could only find one or two adapters (out of 30 or so) that were RNDIS.
> I assume it's the wave of the Windows future though.
> 

I know of about 5 or 6 different devices and none of them are new, but
they seem to be fairly popular. AFAIK all are based on the same
broadcom 4320 chipset.

> 
> Well, if you want to allow your driver to be backported at all, you'll
> pretty much have to support WEXT.
> 
> _But_, since your driver doesn't have any need for backwards
> compatibility requirements since it's not already upstream, you might
> want to be the guinea pig for cfg80211/nl80211 :)  If you decided to
> only support cfg80211, you'd get WEXT support since cfg80211 provides a
> backwards compat solution for WEXT.  Plus you'd be helping out a great
> deal by finding and fixing bugs in cfg80211/nl80211 and proving the
> framework, which would be a great help.

Well, regular WEXT is already more or less done, so I'd prefer to not
throw that away :)  I was just wondering about the current state of the
wireless api's.

> 
> Dan
> 

regards,
Bjorge

