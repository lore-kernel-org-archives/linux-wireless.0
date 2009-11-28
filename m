Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35771 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbZK1N1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 08:27:50 -0500
Date: Sat, 28 Nov 2009 11:27:52 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ian Molton <ian.molton@collabora.co.uk>,
	linux-acpi@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>
Subject: Re: rfkill: persistent device suspend/resume
Message-ID: <20091128132752.GD17373@khazad-dum.debian.net>
References: <4A37A3E1.8060606@tuffmail.co.uk>
 <1245161645.13461.3.camel@johannes.local>
 <4A37AEB7.6060405@tuffmail.co.uk>
 <20090618030806.GE29569@khazad-dum.debian.net>
 <20091128124158.GB17373@khazad-dum.debian.net>
 <1259413945.5428.21.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1259413945.5428.21.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 28 Nov 2009, Johannes Berg wrote:
> On Sat, 2009-11-28 at 10:41 -0200, Henrique de Moraes Holschuh wrote:
> > What do you guys think?   I will cook up a patch to implement the above, but
> > if there are any objections to the idea, I'd like to hear it ASAP, as I do
> > have a regression to fix :)
> 
> What part of that don't we do?
> 
> static int rfkill_resume(struct device *dev)
> {
>         struct rfkill *rfkill = to_rfkill(dev);
>         bool cur;
> 
>         if (!rfkill->persistent) {
>                 cur = !!(rfkill->state & RFKILL_BLOCK_SW);
>                 rfkill_set_block(rfkill, cur);
>         }

The issue I am reporting is _only_ about persistent devices, so it is the
if(!rfkill->persistent) that is the problem.  It works perfectly for the
other devices.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
