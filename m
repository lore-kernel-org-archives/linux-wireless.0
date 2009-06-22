Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57170 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758517AbZFVPo5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 11:44:57 -0400
Subject: Re: Proposal enquiry for Wireless Roaming feature enhancement
From: Dan Williams <dcbw@redhat.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Balaji Ravindran <b@w1an.in>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mircea Gherzan <mgherzan@gmail.com>
In-Reply-To: <87k534nwy3.fsf@litku.valot.fi>
References: <4A38672F.9090904@w1an.in> <87hbyfmlds.fsf@litku.valot.fi>
	 <1245231411.20613.3.camel@johannes.local> <87bpol90z5.fsf@litku.valot.fi>
	 <1245681796.4338.24.camel@dhcp-100-3-98.bos.redhat.com>
	 <87k534nwy3.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 11:44:56 -0400
Message-Id: <1245685496.4338.72.camel@dhcp-100-3-98.bos.redhat.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-06-22 at 17:51 +0300, Kalle Valo wrote:
> Dan Williams <dcbw@redhat.com> writes:
> 
> >> >  2) a way of telling userspace whether or not it has to handle
> >> >  roaming, now that new cards are showing up (iwm) that can handle it
> >> >  themselves
> >> 
> >> What about older fullmac cards, do they support roaming in hardware?
> >
> > Yes.  airo at least, and I think also atmel, orinoco, but not Libertas.
> > Most of the fullmac cards do handle roaming between BSSIDs in the same
> > SSID transparently.  Libertas on the other hand pushes that control to
> > the driver.
> 
> Can you tell anything about the configuration parameters available? For
> example, can the driver configure an rssi threshold for enabling
> background scanning[1]?

On airo maybe, there is for example:

	__le16 linkLossDelay;
	__le16 maxBeaconLostTime;
	__le16 refreshInterval;

which might have some effect on the firmware jumping to a new AP.  Or it
might just be the threshold at which the driver gives up and signals
disassoc.

TBH, I'm actually not sure about atmel, I forgot that their firmware is
somewhat lighter than airo and orinoco.  Later orinoco firmware versions
might give up more control to the driver.

Dan

