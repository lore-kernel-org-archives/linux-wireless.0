Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59548 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754292AbYHEMsV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 08:48:21 -0400
Date: Tue, 5 Aug 2008 09:48:14 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Message-ID: <20080805124814.GA32675@khazad-dum.debian.net> (sfid-20080805_144826_179113_9C464278)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217700664-20792-9-git-send-email-hmh@hmh.eng.br> <1217703723.8621.50.camel@johannes.berg> <20080802192704.GB24253@khazad-dum.debian.net> <1217864565.3139.17.camel@localhost.localdomain> <20080804223052.GG24927@khazad-dum.debian.net> <1217890611.17793.17.camel@localhost.localdomain> <20080804233525.GI24927@khazad-dum.debian.net> <1217927541.3603.32.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217927541.3603.32.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 05 Aug 2008, Johannes Berg wrote:
> On Mon, 2008-08-04 at 20:35 -0300, Henrique de Moraes Holschuh wrote:
> > And it is already damn clear that what we currently have (rfkill always
> > blocks on suspend) is not the correct way to go about it.  WHAT I want to
> > know now is whether there are any drivers out there which need the current
> > behaviour.
> 
> No. There are no drivers that rely on that. Seriously, all drivers

Did you review them all?  Including what is outside of drivers/net/wireless?

> implement some form of suspend by simply turning off the hardware.

Maybe on net/wireless, but I am really not going to trust that one for,
e.g., serial and USB drivers (USB being a bus that is often not shut down
during suspend because there are USB wake devices), unless you clearly state
you DID review them all, and which ones.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
