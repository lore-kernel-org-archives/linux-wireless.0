Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:34289 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207Ab1GKHai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 03:30:38 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: "samuel@sortiz.org" <samuel@sortiz.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 11 Jul 2011 09:30:26 +0200
Subject: RE: [PATCH v5 0/6] NFC subsystem
Message-ID: <AC090B9732AB2B4DB7FF476E907FE66001317B8FDF@dnce02.ent.ti.com> (sfid-20110711_093043_040462_8506FBE9)
References: <AC090B9732AB2B4DB7FF476E907FE66001317B8E2A@dnce02.ent.ti.com>
 <1310345174.5017.17.camel@sortiz-mobl>
In-Reply-To: <1310345174.5017.17.camel@sortiz-mobl>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

Thanks for your reply.

> -----Original Message-----
> From: Samuel Ortiz [mailto:samuel@sortiz.org]
> Sent: Monday, July 11, 2011 3:46 AM
> To: Elias, Ilan
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: [PATCH v5 0/6] NFC subsystem
> 
> Hi Ilan,
> 
> On Sun, 2011-07-10 at 16:16 +0200, Elias, Ilan wrote:
> > Hi Aloisio,
> >
> > I went over the userspace interface and it seems to me
> > that it's very much following the PN533 chip interface.
> >
> > As you probably know, the NFC forum is in the process of defining
> > a new industry standard for the NFC Controller Interface (NCI).
> > All NFC chips in the near future will probably support the NCI,
> I suppose that's arguable, especialy the "All" and "near future" terms
> of your statement :)
> Moreover, as far as I know, most NFC chips are currently HCI based and I
> expect the transition from HCI to NCI to not be that fast.
I assume you're right and it might take some time for the transition to occur, but still I believe most of NFC chips will support NCI in the near future. Thus, I think the userspace interface should also take into consideration the NCI.

> 
> 
> >
> > which will provide a generic and standard interface for NFC
> > functionality.
> >
> > I think that your current userspace interface might be too specific
> > for PN533 chip, and might not expose all the required NFC functionality.
> The idea for the current netlink userspace API is to be a generic and
> high level one. It should allow for userspace components to build their
> target management code and NDEF  parsing code on top of it, without
> having to know if the below HW is HCI, NCI or anything else based.
> Also, please note that the current API is going to be soon extended to
> support target mode.
I agree that the userspace API should be generic and high level one, so it will be able to support all underlying HW interface, e.g. HCI and NCI.

> 
> 
> > A similar case with Bluetooth, where HCI is the industry standard which
> > is supported by most Bluetooth chips, thus BlueZ support it of course.
> We plan to implement the NFC HCI (as in ETSI 102 622) code as a kernel
> component, and we're currently working on that. HCI NFC based chipsets
> will register against this layer which will then talk to the NFC core
> layer.
> The same architecture would hopefully work with NCI, although due to the
> lack of currently available public NCI specs, I can't guarantee that it
> won't require some small adjustments.
> 
> > Doesn't it make more sense to make the userspace interface more similar
> > to the NCI?
> Could you please point us at a publically available description of that
> interface ?
You can download latest NCI spec and check its current status in the NFC forum website at:
http://www.nfc-forum.org/home/

> 
> Cheers,
> Samuel.
> 
Thanks & BR,
Ilan

