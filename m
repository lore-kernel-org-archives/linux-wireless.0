Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:44061 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118AbZB0OPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 09:15:23 -0500
Message-ID: <49A7F578.4080405@lwfinger.net> (sfid-20090227_151532_086298_ABBFE2E0)
Date: Fri, 27 Feb 2009 08:15:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Korrignu <korrignu@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: informations about BCM4312
References: <49A7E9FC.7070904@gmail.com>
In-Reply-To: <49A7E9FC.7070904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Korrignu wrote:
> hello,
> 
> i have a BCM4312 (rev02) chipset on my laptop, and I can't understand on
> this webpage http://wireless.kernel.org/en/users/Drivers/b43#supported
> if it is supported by b43 module or not
> 
> in fact, when i load the module, there is no new network interface
> created...
> and i can't find informations about it on the web...
> 
> could get me some informations about this problem ?

The BCM4312 is somewhat of a problem as there are two completely different
devices that use that identification. You need to look at the PCI ID to tell if
it is supported. Use the command 'lspci -n'and look for a line that has
"14e5:43XX" in it. If XX is 15, it is not supported. The fact that you have to
load the b43 module manually suggests that it is not supported. The other thing
to do is the command 'dmesg | grep b43'.

Larry
