Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:19346 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbYGaPTd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 11:19:33 -0400
Subject: Re: Driver for the FullMAC card
From: Pavel Roskin <proski@gnu.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Dmitry <dbaryshkov@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1217514241.12016.13.camel@localhost.localdomain>
References: <g6qr98$q28$2@ger.gmane.org>
	 <1217512488.12016.8.camel@localhost.localdomain>
	 <bc64b4640807310715j41bb0029i5c8be73a311ed52@mail.gmail.com>
	 <1217514241.12016.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 11:19:31 -0400
Message-Id: <1217517571.22143.17.camel@dv> (sfid-20080731_171939_644245_A348C76E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-07-31 at 10:24 -0400, Dan Williams wrote:

> prism2_usb already uses p80211, which is a softmac stack.  So the cards
> are already being driven in softmac mode.  You basically just have to
> write a mac80211 driver for the hardware and ignore p80211 completely.

I don't think p80211 is a softmac stack.  It's just a thin layer for
802.11 packet manipulation.  There were some talks about splitting
lib80211 from mac80211 so that FullMAC cards could make use of the
existing code.  p80211 is something of that kind.

Prism USB is not much different from other Prism cards.  Sure, it needs
packet interface for communicating to the device, but it associates on
its own.

I asked Jouni if HostAP could be converted to SoftMAC, and his answer
was that it may be a good AP but a poor station (sorry I cannot find it
in the archives).  The same would apply to Prism USB.

-- 
Regards,
Pavel Roskin
