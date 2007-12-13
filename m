Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933351AbXLMVd1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 16:33:27 -0500
Subject: Re: status wireless extensions API for new drivers
From: Dan Williams <dcbw@redhat.com>
To: Bjorge Dijkstra <bjd@jooz.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4761A108.2080005@jooz.net>
References: <4761A108.2080005@jooz.net>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 16:33:05 -0500
Message-Id: <1197581585.14270.26.camel@localhost.localdomain> (sfid-20071213_213331_306506_538C6A9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-12-13 at 22:15 +0100, Bjorge Dijkstra wrote:
> Hello all,
> 
> I have been working on adding support for RNDIS based USB wireless 

Quick question about these; does the firmware on the wireless device
itself talk RNDIS directly?  i.e., is RNDIS intended to replace all the
manufacturer-specific proprietary host<->adapter protocols?  How common
are the devices these days?  I trawled through CDW this weekend and
could only find one or two adapters (out of 30 or so) that were RNDIS.
I assume it's the wave of the Windows future though.

> devices[1]. Recently I've been getting some help from another developer 
> and the state of the driver has improved quite a bit. So we are thinking
> about getting it into the mainline kernel.
> We have used the Wireless Extensions API, but I get the impression that
> things are moving towards the cfg/nl80211 API's. Is it still acceptable
> for new drivers trying to get into mainline to use WEXT, or should we
> switch to the new API's?

Well, if you want to allow your driver to be backported at all, you'll
pretty much have to support WEXT.

_But_, since your driver doesn't have any need for backwards
compatibility requirements since it's not already upstream, you might
want to be the guinea pig for cfg80211/nl80211 :)  If you decided to
only support cfg80211, you'd get WEXT support since cfg80211 provides a
backwards compat solution for WEXT.  Plus you'd be helping out a great
deal by finding and fixing bugs in cfg80211/nl80211 and proving the
framework, which would be a great help.

Dan


