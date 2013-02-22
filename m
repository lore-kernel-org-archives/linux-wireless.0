Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60370 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3BVU2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 15:28:41 -0500
Message-ID: <1361564916.3420.11.camel@jlt4.sipsolutions.net> (sfid-20130222_212845_494165_3DE3EDAC)
Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Piotr Haber <phaber@broadcom.com>
Date: Fri, 22 Feb 2013 21:28:36 +0100
In-Reply-To: <A47087626F2942499CF47E79803E771E0431B792@SJEXCHMB13.corp.ad.broadcom.com>
References: <A47087626F2942499CF47E79803E771E0431B792@SJEXCHMB13.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-22 at 16:59 +0000, Arend Van Spriel wrote:

> > Similarly, you could give it a certain timeout to protect DHCP traffic.
> > I guess the only thing that would seem necessary would be a notification
> > of "DHCP done" that would allow you to drop the protection right away.
> 
> We discussed this and we could start protecting when we see a BOOTP
> message, but indeed the end is not that straightforward and would need
> a "DHCP done" notification. However, if we have that there is little
> overhead in having a "DHCP start" notification and I would prefer to
> avoid looking into the sk_buff to check the protocol. The knowledge of
> DHCP start and done is not a responsibility of the driver.

Yes, I agree that sniffing the traffic for this is not a good idea.

> > Is there any *reason* for it though? Would it ever call it after the
> > connection is fully established?
> 
> That obviously depends on the DHCP lease time or a renewal request. So
> it could be called afterwards as well.

But is it? You'd usually expect the DHCP renewal to happen before the
lease expires so then it wouldn't be quite that latency sensitive.

> > To me this seems not very well thought out.
> 
> Have to admit that it is a bit uninspired to reuse. In Android bcmdhd
> it is actually done by driver private ioctl, which did seem like a
> worse idea. Considered doing it entirely in the driver, but decided
> that it could be beneficial for dhcp clients to use such an interface
> and (arguably) for supplicant as well.

Yes, although actually even for DHCP you could probably go on things
like "do I have an address configured", maybe. Not really sure. Having
some sort of "DHCP bracketing" would seem quite a bit saner though than
what was proposed now.

johannes

