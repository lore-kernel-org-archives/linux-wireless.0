Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:42365 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab0CRUvf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 16:51:35 -0400
Message-ID: <4BA2924C.7020905@free.fr>
Date: Thu, 18 Mar 2010 21:51:24 +0100
From: =?ISO-8859-1?Q?Nicolas_de_Peslo=FCan?= <nicolas.2p.debian@free.fr>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx devel <Bcm43xx-dev@lists.berlios.de>
Subject: Re: RFC: A workaround for BCM43XX devices with no on-board SPROM
References: <4BA266FB.1080507@lwfinger.net>
In-Reply-To: <4BA266FB.1080507@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote :
> Michael,
> 
> I'm switching this discussion from the kernel Bugzilla to the lists.
> 
> As you know, but I'm restating for anyone that has not read our previous
> discussions, the b43 driver needs to be changed to handle some of the newer
> devices do not have an on-board SPROM. It would be trivial to incorporate the
> data except for the need to have a unique, reproducible MAC.
> 
> I am proposing to solve this problem using the following steps:
> 
> (1) Modify b43-fwcutter to take data from an existing SPROM, modify the MAC by
> replacing the last 3 octets with random numbers, and write the resulting file to
> /lib/firmware/b43. Fortunately, all affected devices seem to have Revision 8
> SPROMS, which makes preparation easier. All such devices will need to use the
> calibration parameters of the device from which the prototype SPROM was copied,
> but that should not be a serious problem. I have chosen to implement this in
> fwcutter rather than ssb_sprom because the ordinary user will not have access to
> ssb_sprom; however, they do have a version of fwcutter supplied by the distro.
> Unconditionally writing an additional small file to the firmware directory when
> extracting firmware is small overhead and it will be transparent to the user of
> whatever mechanism the distro uses. The routines needed to calculate the CRC,
> etc. have been copied into fwcutter from ssb_sprom. A version of this code is
> already running.
> 
> (2) Use the steps in http://bcm-v4.sipsolutions.net/802.11/IsSpromAvailable to
> determine if the device has an SPROM. If not, then use the kernel's firmware
> loading mechanism to get the contents of the file prepared in step 1. This file
> has an 8-bit CRC, thus the validity of the file can be tested even though the
> test is not very robust.
> 
> It it reasonable to keep the vendor portion of the MAC and only replace the
> "serial number", or would it be better to randomize all 6 octants?

We know that there exist a risk (arguably low) for two devices in the same LAN to have the same 
random part of the MAC. The risk might be higher if, for any reason, the random number generator 
lack good entropy at the time fwcutter is run.

Also, keeping the same MAC prefix (one from Broadcom) will lead to a risk of having the same MAC for 
a randomly generated device and for a legitimate MAC from Broadcom.

To reduce the risk, we can chose two different ways :

1/ Using a "private" MAC (having bit 0x02 of the lowest byte of the MAC set to 1). This will provide 
a random area of 46 bits, far better than 24 bits if we keep the Broadcom prefix.
2/ Registering a public MAC prefix for this usage.

Anyway, I think we should add a duplicate MAC detection system, that would at least issue a warning 
if the NIC lacking an SPROM (and so knowing the MAC address was randomized) receive a packet with 
its MAC as the source MAC.

Of course, in some network topologies, several NIC may share the same MAC, leading to some of them 
receiving packets with their own MAC as source MAC. A bonding configuration is one such situation. 
For this reason, it might be also desirable to have the ability to report to an upper layer that the 
MAC is possibly "unsafe" (subject to a risk of duplicate MAC) and probably not suitable to become 
the shared MAC for a bonding configuration. That way, at the time such configuration are setup, the 
tool used to setup the configuration would have the ability to report the situation to the user.

Also, in order to keep the same MAC if one run fwcutter again, we should provide fwcutter with an 
option to decide whether we want to keep the previously randomized MAC or whether fwcutter should 
provide a new one (in particular if the current one hit a duplicate MAC).

	Nicolas.

> 
> Is there a better way to load a file into the kernel?
> 
> Thanks,
> 
> Larry
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
> 

