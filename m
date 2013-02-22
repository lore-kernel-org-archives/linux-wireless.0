Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4592 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664Ab3BVQ72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 11:59:28 -0500
From: "Arend Van Spriel" <arend@broadcom.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>
Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
Date: Fri, 22 Feb 2013 16:59:16 +0000
Message-ID: <A47087626F2942499CF47E79803E771E0431B792@SJEXCHMB13.corp.ad.broadcom.com> (sfid-20130222_175932_172287_75421F29)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-22 at 13:32 +0000, Johannes Berg wrote:
> On Fri, 2013-02-22 at 13:32 +0000, Piotr Haber wrote:
> > > Apart from a few minor technical comments that I'll omit for now, I'm
> > > not sure what value this really has? EAPOL can already be "protected" by
> > > way of knowing when the station is marked authorized, and DHCP is pretty
> > > tricky because it could take "forever", might not be there at all, etc.
> >
> > By "protect" I meant give Wifi a priority over BT so these time sensitive things 
> > can finish quicker/on first try, limiting the possibility of dropping packets because of BT 
> > using the medium.
>
> I know :)
>
> > This is supposed to be temporary and time limited, so if say DHCP finishes in the window 
> > we give it - great, if not the coexistence goes back to default behavior and Wifi traffic is
> > treated as usual. 
>
> That's not even documented/implemented, the way I read the patch you'd
> have to set it back manually.

Actually, the timeout is in brcmfmac so it currently relies on common sense of the driver developers (they tend to use it from time to time though).

> > > What application would actually call this? I don't really see how it
> > > could be integrated like that.
> >
> > For EAPOL wpa_supplicant might use it. For DHCP it could be used from enter/exit hooks
> > via iw or some other utility able to send nl messages.
>
> See that's the thing, I don't really see the point for EAPOL: you could
> just as well start protecting when the association is done, and end it
> when the station is marked authorized. That will have protected any
> EAPOL (or other protocols for that matter) traffic.

Ah, did we miss some cfg80211 API call that can tell us a station is authorized.

> Similarly, you could give it a certain timeout to protect DHCP traffic.
> I guess the only thing that would seem necessary would be a notification
> of "DHCP done" that would allow you to drop the protection right away.

We discussed this and we could start protecting when we see a BOOTP message, but indeed the end is not that straightforward and would need a "DHCP done" notification. However, if we have that there is little overhead in having a "DHCP start" notification and I would prefer to avoid looking into the sk_buff to check the protocol. The knowledge of DHCP start and done is not a responsibility of the driver.

> > This feature is styled after Android one.
>
> I know, I'm (vaguely) familiar with that.
>
> > There a Wifi state machine tries to "protect" DHCP traffic.
>
> Is there any *reason* for it though? Would it ever call it after the
> connection is fully established?

That obviously depends on the DHCP lease time or a renewal request. So it could be called afterwards as well.

> To me this seems not very well thought out.

Have to admit that it is a bit uninspired to reuse. In Android bcmdhd it is actually done by driver private ioctl, which did seem like a worse idea. Considered doing it entirely in the driver, but decided that it could be beneficial for dhcp clients to use such an interface and (arguably) for supplicant as well.

We'll do some more thinking and see whether there will be a RFC v2 ;-)

Gr. AvS
