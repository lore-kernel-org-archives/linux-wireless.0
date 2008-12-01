Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:42073 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYLAPa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 10:30:59 -0500
Subject: Re: iwlwifi - rfkill only works if the interface is up
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
In-Reply-To: <1ba2fa240812010508hcb29699m8bd8b3b0ba8574cd@mail.gmail.com>
References: <200812011311.17346.helmut.schaa@gmail.com>
	 <1ba2fa240812010508hcb29699m8bd8b3b0ba8574cd@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 16:30:53 +0100
Message-Id: <1228145453.31158.140.camel@violet.holtmann.net> (sfid-20081201_163103_242948_E861DACF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> > Nevertheless, I'm wondering if the current behaviour (even with the patch above)
> > makes much sense. I mean, the user space cannot rely on the rfkill state
> > unless an appropriate interface is up. As the device is able to report the
> > killswitch state without firmware being loaded the following approach could
> > be feasible:
> > - iwl_pci_probe enables the device and enables the interrupts
> > - iwl_mac_start just loads the firmware
> > - iwl_mac_stop just releases the firmware but leaves the interrupts enabled
> 
> In 3495  rfkill interrupt is not available and rfkill state is
> delivered only when firmware is loaded, therefore this is not
> possible to bring device down and also expect rfill switch event.
> There were few threads about this subject.
> In 4965 and 5000 this will work

do we unregister the rfkill switch when bringing the adapter down. If
not, then we might should do that. I don't see a point in exposing a
rfkill switch if we can't do anything with it.

Regards

Marcel


