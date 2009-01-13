Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33657 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757524AbZAMNWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 08:22:04 -0500
Date: Tue, 13 Jan 2009 11:21:59 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Werner Almesberger <werner@openmoko.org>,
	linux-wireless@vger.kernel.org
Subject: Re: rfkill: how murderous can it be ?
Message-ID: <20090113132159.GB27676@khazad-dum.debian.net> (sfid-20090113_142214_349769_6EB61815)
References: <20090112191514.GA22112@almesberger.net> <20090113005401.GA7565@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090113005401.GA7565@srcf.ucam.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 13 Jan 2009, Matthew Garrett wrote:
> On Mon, Jan 12, 2009 at 05:15:14PM -0200, Werner Almesberger wrote:
> > Alternatively, we could just power down the whole WLAN module. That is
> > easily done and very reliable. However, MAC state (ESSID, keys, and a
> > host of other settings) is obliterated if we do this. A watchful user 
> > space (e.g., wpa_supplicant) could then restore the status quo ante.
> 
> Some platform rfkill methods will perform a logical PCI hotplug of the 
> device, without any means of notifying the driver beforehand. Since this 
> will destroy the driver structure, I think we really need to leave state 
> restoration up to userspace.

Sounds acceptable, certaily...

But I DO heavily suggest that we inform userspace differently when state was
lost (i.e. when it absolutely HAS to reconfigure the device or there are no
chances of data passing through).

Right now, it HAS that information in a roundabout way: if the device
disappears (hotunplug), state was lost (duh! :-p)   If it stays around, no
state was lost...

And, as an user, I'd be rather annoyed if suddenly I couldn't easily and
cheaply just hit the rfkill hotkey (softswitch) to kill and unkill my WLAN
while browsing, and stopping a few minutes to read the screen... because
every time I unkilled, the system would churn, deassociate and reassociate
and be otherwise annoying doing a reconfiguration it didn't absolutely have
to do.

In other words: make it possible to be configurable!  From the kernel POV
that just means we need to have to publish to userspace the fact that it has
to reconfigure when there is not a full hotunplug/hotplug being done.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
