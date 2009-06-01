Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46350 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbZFAPuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 11:50:21 -0400
Date: Mon, 1 Jun 2009 12:50:20 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090601155020.GC15485@khazad-dum.debian.net>
References: <1243841639.5299.8.camel@johannes.local> <4A238EA2.4040106@tuffmail.co.uk> <20090601122839.GB11011@khazad-dum.debian.net> <1243859931.5299.17.camel@johannes.local> <20090601124553.GE11011@khazad-dum.debian.net> <1243860606.5299.21.camel@johannes.local> <20090601133351.GI11011@khazad-dum.debian.net> <1243866545.5299.25.camel@johannes.local> <20090601153620.GB15485@khazad-dum.debian.net> <1243870669.5299.29.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243870669.5299.29.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 01 Jun 2009, Johannes Berg wrote:
> On Mon, 2009-06-01 at 12:36 -0300, Henrique de Moraes Holschuh wrote:
> > > > On a related note, Johannes, would you be opposed to exporting something I
> > > > could call from thinkpad-acpi to request a radio state change on a rfkill
> > > > struct?   This would allow me to remove some of the mess in thinkpad-acpi.
> > > 
> > > I don't think I understand what you want? What do you mean by "request a
> > > radio state change"?
> > 
> > As in "please try to block this _specific_ radio", and "please try to
> > unblock this _specific_ radio".
> > 
> > I.e. what one would do by a write to the "state" attribute of the _old_
> > rfkill sysfs (and which would get overriden the next time someone changed
> > the global state, etc).
> 
> Ok, but where would you want that exported to? It's available
> on /dev/rfkill, why would you want that for the driver, it can just call
> itself, no?

Yes, it "calls itself" right now... so I can certainly do that :)

However, the in-driver shortcut means I give rfkill a kick and say "the soft
state has changed, deal with it", instead of "please change the state" which
it might deny due to EPO, etc.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
