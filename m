Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38681 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753060AbYHDXfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 19:35:33 -0400
Date: Mon, 4 Aug 2008 20:35:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Message-ID: <20080804233525.GI24927@khazad-dum.debian.net> (sfid-20080805_013536_527894_D85657B0)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217700664-20792-9-git-send-email-hmh@hmh.eng.br> <1217703723.8621.50.camel@johannes.berg> <20080802192704.GB24253@khazad-dum.debian.net> <1217864565.3139.17.camel@localhost.localdomain> <20080804223052.GG24927@khazad-dum.debian.net> <1217890611.17793.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217890611.17793.17.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 04 Aug 2008, Dan Williams wrote:
> > But the OPPOSITE is not clear at all to me.  I don't know whether the other
> > users of rfkill need a radio block on suspend or not.  Unless someone can
> > look over *all* in-tree users of linux/rfkill.h and state that none of them
> > need it because all of them DO shutdown their devices on suspend, I will
> > have to ask the maintainers of every single one about it before I ask a
> > patch to be merged.  I already looked, and I don't know enough to have a
> > definitive answer by myself.
> 
> Using rfkill to enforce suspend power policy at a kernel-level is just
> wrong.  That's a policy decision for gnome-power-manager or
> kde-power-manager or whatever.  At the very least, it should be an
> option in sysfs to turn this behavior on or off.

There is no way I am adding an interface for userspace to decide how a
driver+rfkill stack should go in order to properly suspend a device.  The
kernel is to get it right by itself.  It already knows whether the device
was blocked or not before the suspend.  And, when it is suppored by the
device, the device driver already knows if it is part of a non-stop mesh
(libertas), or has to have WoWL enabled, etc.

And it is already damn clear that what we currently have (rfkill always
blocks on suspend) is not the correct way to go about it.  WHAT I want to
know now is whether there are any drivers out there which need the current
behaviour.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
