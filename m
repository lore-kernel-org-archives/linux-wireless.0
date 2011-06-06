Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55294 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab1FFQUu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 12:20:50 -0400
Date: Mon, 6 Jun 2011 18:20:47 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, marcio.macedo@openbossa.org,
	aloisio.almeida@openbossa.org, Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [PATCH 2/6] NFC: add nfc generic netlink interface
Message-ID: <20110606162047.GA2880@sortiz-mobl> (sfid-20110606_182053_548206_6F6D93ED)
References: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org>
 <1307051170-17374-3-git-send-email-lauro.venancio@openbossa.org>
 <1307108661.3800.6.camel@jlt3.sipsolutions.net>
 <BANLkTikS+cssYccjg_SfOhR15N=M9erw6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <BANLkTikS+cssYccjg_SfOhR15N=M9erw6Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lauro,

On Fri, Jun 03, 2011 at 05:18:26PM -0300, Lauro Ramos Venancio wrote:
> > IMHO, the better way to structure this would be to create an event that
> > contains no information, and then allow a dump of the targets (with a
> > generation counter). That way, there are no such artificial limits due
> > to message sizes.
> 
> I agree that this is a better solution. But I think we don't need a
> generation counter because only a new polling operation (start_poll
> call) can change the targets list (i.e. there is no passive polling).
I think we agree on the fact that going through a target list dump would be a
better solution. Then if we do so we need to provide some sort of consistency
check, even though NFC doesn't define any sort of passive polling. One example
would be an NFC daemon running and getting the target list while a command
line tool could initiate a target poll.

 
> >> +static int nfc_genl_dump_devices(struct sk_buff *skb,
> >> +                               struct netlink_callback *cb)
> >
> > You should have a generation counter here so that applications getting a
> > dump can know whether their dump was a complete and consistent snapshot.
> > Otherwise, if devices are added or removed during the dump applications
> > will not be able to know that their dump wasn't right.
> >
> 
> We don't need a generation counter here because we have the events
> NFC_EVENT_DEVICE_ADDED and NFC_EVENT_DEVICE_REMOVED. So, it is
> possible to keep the device list consistency listening for these
> events.
I agree with you here we can keep it consistent by listening to these
events. But if we provide the dump hook, we need to add an additional
consistency check even though this kind of race is much less likely to happen
than in the target case (devices don't just show up on your NFC enabled phone).

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
