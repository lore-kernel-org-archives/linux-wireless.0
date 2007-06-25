Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out114.alice.it ([85.37.17.114]:2918 "EHLO
	smtp-out114.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbXFYT1f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2007 15:27:35 -0400
From: Matteo Croce <rootkit85@yahoo.it>
To: Michal Schmidt <mschmidt@redhat.com>
Subject: Re: airo
Date: Mon, 25 Jun 2007 21:27:32 +0200
References: <200706061903.13228.rootkit85@yahoo.it> <200706091816.47618.rootkit85@yahoo.it> <467FD362.8000602@redhat.com>
In-Reply-To: <467FD362.8000602@redhat.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706252127.32427.rootkit85@yahoo.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 25 June 2007 16:38:26 you wrote:
> It looks like some other network interface gets renamed from "eth0" to
> "eth1" at the same time the airo driver is initializing the card. Does
> it happen always after booting? Do you have other network interfaces?
> This patch should fix it. Can you test it?

Exactly, the boot process goes so:
1) udev loads forcedeth.ko and it gets eth0
2) udev also loads airo.ko
3) forcedeth loads very fast and udev renames it to eth1 according to /etc/iftab
4) airo slowly init the card and try to get eth1 as name, but found it busy and die()

Personally I solved this by deleting forcedeth.ko. I know that it's ugly, but I don't use wired etherned
and i hate do "rmmod airo ; modprobe airo" at every boot, also in a shell script.

Cheers,
Matteo
