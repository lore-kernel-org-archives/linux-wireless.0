Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbXFYVF6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2007 17:05:58 -0400
Subject: Re: airo
From: Dan Williams <dcbw@redhat.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Matteo Croce <rootkit85@yahoo.it>,
	Michal Schmidt <mschmidt@redhat.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46801C71.6070107@lwfinger.net>
References: <200706061903.13228.rootkit85@yahoo.it>
	 <200706091816.47618.rootkit85@yahoo.it> <467FD362.8000602@redhat.com>
	 <200706252127.32427.rootkit85@yahoo.it>  <46801C71.6070107@lwfinger.net>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 17:10:34 -0400
Message-Id: <1182805834.10966.0.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-06-25 at 14:50 -0500, Larry Finger wrote:
> Matteo Croce wrote:
> > Exactly, the boot process goes so:
> > 1) udev loads forcedeth.ko and it gets eth0
> > 2) udev also loads airo.ko
> > 3) forcedeth loads very fast and udev renames it to eth1 according to /etc/iftab
> > 4) airo slowly init the card and try to get eth1 as name, but found it busy and die()
> > 
> > Personally I solved this by deleting forcedeth.ko. I know that it's ugly, but I don't use wired etherned
> > and i hate do "rmmod airo ; modprobe airo" at every boot, also in a shell script.
> 
> What does /etc/udev/rules.d/30-net_persistent_names.rules say about the name for the MAC address of 
> the wired interface? On my system, the wired one is forced to be eth0 and the wireless to be eth1.

Even so, drivers need to be safe against device renames at any stage.

Dan


