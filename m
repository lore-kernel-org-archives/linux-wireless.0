Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:6346 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYLAQRM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 11:17:12 -0500
Received: by yw-out-2324.google.com with SMTP id 9so964589ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 08:17:10 -0800 (PST)
To: Marcel Holtmann <holtmann@linux.intel.com>
Subject: Re: iwlwifi - rfkill only works if the interface is up
Date: Mon, 1 Dec 2008 17:16:41 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
References: <200812011311.17346.helmut.schaa@gmail.com> <200812011634.37644.helmut.schaa@gmail.com> <1228147151.31158.142.camel@violet.holtmann.net>
In-Reply-To: <1228147151.31158.142.camel@violet.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812011716.43486.helmut.schaa@gmail.com> (sfid-20081201_171715_090645_F647A680)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 1. Dezember 2008 schrieb Marcel Holtmann:
> Hi Helmut,
> 
> > > > > Nevertheless, I'm wondering if the current behaviour (even with the patch above)
> > > > > makes much sense. I mean, the user space cannot rely on the rfkill state
> > > > > unless an appropriate interface is up. As the device is able to report the
> > > > > killswitch state without firmware being loaded the following approach could
> > > > > be feasible:
> > > > > - iwl_pci_probe enables the device and enables the interrupts
> > > > > - iwl_mac_start just loads the firmware
> > > > > - iwl_mac_stop just releases the firmware but leaves the interrupts enabled
> > > > 
> > > > In 3495  rfkill interrupt is not available and rfkill state is
> > > > delivered only when firmware is loaded, therefore this is not
> > > > possible to bring device down and also expect rfill switch event.
> > > > There were few threads about this subject.
> > > > In 4965 and 5000 this will work
> > > 
> > > do we unregister the rfkill switch when bringing the adapter down.
> > 
> > No.
> > 
> > > If not, then we might should do that. I don't see a point in exposing a
> > > rfkill switch if we can't do anything with it.
> > 
> > Either that, or make the rfkill usable even when the interface is down.
> 
> if the hardware/firmware doesn't allow us to do so, we have no real
> option.

Ah, you're talking about 3945. Missed that.

Helmut
