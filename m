Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56791 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab1GKApf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2011 20:45:35 -0400
Subject: Re: [PATCH v5 0/6] NFC subsystem
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: "Elias, Ilan" <ilane@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AC090B9732AB2B4DB7FF476E907FE66001317B8E2A@dnce02.ent.ti.com>
References: <AC090B9732AB2B4DB7FF476E907FE66001317B8E2A@dnce02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 02:46:14 +0200
Message-ID: <1310345174.5017.17.camel@sortiz-mobl> (sfid-20110711_024544_955625_0CB04053)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Sun, 2011-07-10 at 16:16 +0200, Elias, Ilan wrote:
> Hi Aloisio,
> 
> I went over the userspace interface and it seems to me 
> that it's very much following the PN533 chip interface.
> 
> As you probably know, the NFC forum is in the process of defining 
> a new industry standard for the NFC Controller Interface (NCI).
> All NFC chips in the near future will probably support the NCI,
I suppose that's arguable, especialy the "All" and "near future" terms
of your statement :)
Moreover, as far as I know, most NFC chips are currently HCI based and I
expect the transition from HCI to NCI to not be that fast.


>  
> which will provide a generic and standard interface for NFC functionality.
> 
> I think that your current userspace interface might be too specific 
> for PN533 chip, and might not expose all the required NFC functionality.
The idea for the current netlink userspace API is to be a generic and
high level one. It should allow for userspace components to build their
target management code and NDEF  parsing code on top of it, without
having to know if the below HW is HCI, NCI or anything else based.
Also, please note that the current API is going to be soon extended to
support target mode.


> A similar case with Bluetooth, where HCI is the industry standard which 
> is supported by most Bluetooth chips, thus BlueZ support it of course.
We plan to implement the NFC HCI (as in ETSI 102 622) code as a kernel
component, and we're currently working on that. HCI NFC based chipsets
will register against this layer which will then talk to the NFC core
layer.
The same architecture would hopefully work with NCI, although due to the
lack of currently available public NCI specs, I can't guarantee that it
won't require some small adjustments.

> Doesn't it make more sense to make the userspace interface more similar to the NCI?
Could you please point us at a publically available description of that
interface ?

Cheers,
Samuel.


