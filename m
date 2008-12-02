Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47131 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753534AbYLBNAD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 08:00:03 -0500
Date: Tue, 2 Dec 2008 10:59:59 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
Subject: Re: iwlwifi - rfkill only works if the interface is up
Message-ID: <20081202125959.GC1668@khazad-dum.debian.net> (sfid-20081202_140013_748588_5F4F6229)
References: <200812011311.17346.helmut.schaa@gmail.com> <1ba2fa240812010508hcb29699m8bd8b3b0ba8574cd@mail.gmail.com> <1228145453.31158.140.camel@violet.holtmann.net> <200812011634.37644.helmut.schaa@gmail.com> <1228147151.31158.142.camel@violet.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1228147151.31158.142.camel@violet.holtmann.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 01 Dec 2008, Marcel Holtmann wrote:
> if the hardware/firmware doesn't allow us to do so, we have no real
> option. I think that nobody thought about this use case so far. I am not
> sure if we should unregister it or just fix rfkill to add an invalid
> state. It is also possible to tie rfkill with ifup/ifdown.

Please don't register/unregister rfkill classes like that, it is extremely
broken from userspace's point-of-view, and it is not how the rfkill core
subsystem expects things to be used either.    If there is no way to avoid
register/unregister at interface up/down, it is better to never register any
rfkill classes at all, and remove the functionality.

Now, I hate when people use the term "rfkill switch" when dealing with the
kernel rfkill subsystem, because we can't really always be sure we
understood what the person means, so please bear with me...

Are you talking about the hardware rfkill line (the input pin where one
might have hooked an input device)?  Or about something else?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
