Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:59900 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYLBNPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 08:15:03 -0500
Subject: Re: iwlwifi - rfkill only works if the interface is up
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
In-Reply-To: <20081202125959.GC1668@khazad-dum.debian.net>
References: <200812011311.17346.helmut.schaa@gmail.com>
	 <1ba2fa240812010508hcb29699m8bd8b3b0ba8574cd@mail.gmail.com>
	 <1228145453.31158.140.camel@violet.holtmann.net>
	 <200812011634.37644.helmut.schaa@gmail.com>
	 <1228147151.31158.142.camel@violet.holtmann.net>
	 <20081202125959.GC1668@khazad-dum.debian.net>
Content-Type: text/plain
Date: Tue, 02 Dec 2008 14:14:53 +0100
Message-Id: <1228223693.31158.240.camel@violet.holtmann.net> (sfid-20081202_141507_657627_A803DD8D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrique,

> > if the hardware/firmware doesn't allow us to do so, we have no real
> > option. I think that nobody thought about this use case so far. I am not
> > sure if we should unregister it or just fix rfkill to add an invalid
> > state. It is also possible to tie rfkill with ifup/ifdown.
> 
> Please don't register/unregister rfkill classes like that, it is extremely
> broken from userspace's point-of-view, and it is not how the rfkill core
> subsystem expects things to be used either.    If there is no way to avoid
> register/unregister at interface up/down, it is better to never register any
> rfkill classes at all, and remove the functionality.
> 
> Now, I hate when people use the term "rfkill switch" when dealing with the
> kernel rfkill subsystem, because we can't really always be sure we
> understood what the person means, so please bear with me...
> 
> Are you talking about the hardware rfkill line (the input pin where one
> might have hooked an input device)?  Or about something else?

so this case is that we are not getting any updates about the rfkill
line status if the firmware is not loaded (happens at ifdown case). How
do you propose this should be handled?

Regards

Marcel


