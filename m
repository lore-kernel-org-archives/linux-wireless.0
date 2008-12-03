Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39210 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609AbYLCWt6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 17:49:58 -0500
Subject: Re: iwlwifi - rfkill only works if the interface is up
From: Dan Williams <dcbw@redhat.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
In-Reply-To: <200812012250.37587.helmut.schaa@gmail.com>
References: <200812011311.17346.helmut.schaa@gmail.com>
	 <1228147151.31158.142.camel@violet.holtmann.net>
	 <20081201211231.GC3479@tuxdriver.com>
	 <200812012250.37587.helmut.schaa@gmail.com>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 17:48:40 -0500
Message-Id: <1228344520.25647.27.camel@localhost.localdomain> (sfid-20081203_235003_321234_C257ED58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-01 at 22:50 +0100, Helmut Schaa wrote:
> Am Montag, 1. Dezember 2008 schrieb John W. Linville:
> > FWIW, I'm not sure what the point of checking rfkill state would be if the
> > adapter is down anyway.  Hmmm...maybe management of the rfkill LED?
> 
> The main intention was that user space programs might want to listen to rfkill
> events in order to bring the interface up once the killswitch is disabled.
> 
> AFAIK NetworkManager takes an interface down once it recognises that the
> device is disabled through a killswitch. If the device is not able to notify
> a rfkill state change if it is down NM cannot recognise when the device can
> be brought up again.
> 
> Dan, is that correct?

Yes, but *only* because the rfkill layer < 2.6.27 (and still HAL
doesn't) didn't have any support for SOFT_BLOCK.  Once HAL grows support
for 3 states (HW_BLOCK, SW_BLOCK, UNBLOCKED) in its killswitch objects,
then I'll:

1) switch NM over to use SOFT_BLOCK when "disabling wireless", or if
there is no killswitch then just turn off the TX power with SIOCSIWTXPOW

2) Not take the interface down at all, but ensure that rfkill has
occurred

The only reason that NM takes the interface down is that previously,
this was the way to ensure that the radio was not transmitting.
Unfortunately, that also unloads firmware on iwl3945, meaning that the
3945 (and thus NM) cannot detect unblocking of the 3945 radio.

The reason we cannot use SIOCSIWTXPOW today is that with ipw2100,
ipw2200, and ipw2915, HAL reports that the radio is HW_BLOCKed and thus
there's no way to know that the radio can be unblocked via software
(like the applet menu).

Dan


