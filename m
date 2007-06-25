Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:56136 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170AbXFYTuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2007 15:50:12 -0400
Message-ID: <46801C71.6070107@lwfinger.net>
Date: Mon, 25 Jun 2007 14:50:09 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Matteo Croce <rootkit85@yahoo.it>
CC: Michal Schmidt <mschmidt@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: airo
References: <200706061903.13228.rootkit85@yahoo.it> <200706091816.47618.rootkit85@yahoo.it> <467FD362.8000602@redhat.com> <200706252127.32427.rootkit85@yahoo.it>
In-Reply-To: <200706252127.32427.rootkit85@yahoo.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matteo Croce wrote:
> Exactly, the boot process goes so:
> 1) udev loads forcedeth.ko and it gets eth0
> 2) udev also loads airo.ko
> 3) forcedeth loads very fast and udev renames it to eth1 according to /etc/iftab
> 4) airo slowly init the card and try to get eth1 as name, but found it busy and die()
> 
> Personally I solved this by deleting forcedeth.ko. I know that it's ugly, but I don't use wired etherned
> and i hate do "rmmod airo ; modprobe airo" at every boot, also in a shell script.

What does /etc/udev/rules.d/30-net_persistent_names.rules say about the name for the MAC address of 
the wired interface? On my system, the wired one is forced to be eth0 and the wireless to be eth1.

Larry
