Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60556 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753996AbXF0B7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2007 21:59:05 -0400
Date: Tue, 26 Jun 2007 21:58:53 -0400
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Dan Williams <dcbw-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: airo
Message-ID: <20070626215853.45d81292@oldman>
In-Reply-To: <1182805834.10966.0.camel@xo-13-A4-25.localdomain>
References: <200706061903.13228.rootkit85@yahoo.it>
	<200706091816.47618.rootkit85@yahoo.it>
	<467FD362.8000602@redhat.com>
	<200706252127.32427.rootkit85@yahoo.it>
	<46801C71.6070107@lwfinger.net>
	<1182805834.10966.0.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 25 Jun 2007 17:10:34 -0400
Dan Williams <dcbw-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, 2007-06-25 at 14:50 -0500, Larry Finger wrote:
> > Matteo Croce wrote:
> > > Exactly, the boot process goes so:
> > > 1) udev loads forcedeth.ko and it gets eth0
> > > 2) udev also loads airo.ko
> > > 3) forcedeth loads very fast and udev renames it to eth1 according to /etc/iftab
> > > 4) airo slowly init the card and try to get eth1 as name, but found it busy and die()
> > > 
> > > Personally I solved this by deleting forcedeth.ko. I know that it's ugly, but I don't use wired etherned
> > > and i hate do "rmmod airo ; modprobe airo" at every boot, also in a shell script.
> > 
> > What does /etc/udev/rules.d/30-net_persistent_names.rules say about the name for the MAC address of 
> > the wired interface? On my system, the wired one is forced to be eth0 and the wireless to be eth1.
> 
> Even so, drivers need to be safe against device renames at any stage.
> 
> Dan
> 
> 

Name should NOT be used for anything but messages (and request_irq).
The driver should use ifindex if it needs some persistent token.
Using rtnl_lock() works but it can't be held across hotplug or other events.
