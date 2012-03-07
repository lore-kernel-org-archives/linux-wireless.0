Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173021pub.verizon.net ([206.46.173.21]:50547 "EHLO
	vms173021pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2CGFbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 00:31:48 -0500
Received: from vznit170060 ([unknown] [172.18.12.132])
 by vms173021.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0M0I00HLY20XI5B0@vms173021.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Tue, 06 Mar 2012 23:31:45 -0600 (CST)
Date: Tue, 06 Mar 2012 23:31:45 -0600 (CST)
From: alupu@verizon.net
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Message-id: <27728117.2989270.1331098305793.JavaMail.root@vznit170060> (sfid-20120307_063151_925820_4B9F86CA)
Subject: Re: r8712u staging in kernel 3.2.9
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 03/06/12 10:22 PM, Larry Finger wrote:> Here are the details for my system, which is 64-bit.
> I'm running kernel 3.3-rc5 with wireless-tools version 30.
  
The root of the divergence between our results might be 
found in the differences between my version 29 and your "30".

According to Jean Tourrilhes (the founding father of the tools):
"The latest stable version of Wireless Tools is version 29"
He also mentions (and offers) a version "30-pre9(beta)".
See
<www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>

As an aside, this situation where distributions (as opposed to the
(B)LFS approach) tweak packages so as to offer an overall workable
release is getting worse and worse, especially lately where
software package dependencies are getting way out of hand.
In this particular instance, we'll never know if openSuse "30"
is the same as "30-pre9(beta)" (whatever that would mean) or
a lower "-pre" or even an in-house version 29/30 software
massaged to play nice with other package instances within
a particular distribution release.

That said, this doesn't mean that my problem might not lie elsewhere.
A great help would be if you could install the latest
_stable_ release (29) and quickly test my complaints.
Don't be afraid of the version police. You cannot be arrested
for using the _official_, genuine, latest stable version 29.
You _might_ get in trouble if they catch you using a most
likely counterfeit version 30 :)

> What would be the ifconfig command to start the interface with DHCP?
> In my distro, we have an ifup command that reads a configuration file.
> That script is too complicated to see what it does.

I've used DHCP only for "wire" connections, in a wrapper of my
own which finally ends up doing something like,
 dhcpcd eth0 -L
For wireless stuff I use 'pppoe-start/stop/status' with an
appropriate /etc/ppp/xxxxx.conf file.

For a solid, more legible (IMHO) approach (DHCP, etc.),
you can take a look at LFS-Bootscripts:
<www.linuxfromscratch.org/lfs/view/development/chapter03/packages.html>
and BLFS-Bootscripts:
<www.linuxfromscratch.org/blfs/view/svn/introduction/bootscripts.html>
 
Thanks,
-- Alex
