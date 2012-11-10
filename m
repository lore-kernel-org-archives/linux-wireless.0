Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edgefb1.NCS.McGill.CA ([132.206.27.48]:54439 "EHLO
	edgefb1.ncs.mcgill.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2KJKAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Nov 2012 05:00:39 -0500
Received: from edgesmtp1.ncs.mcgill.ca (edgesmtp1.ncs.McGill.CA [132.206.27.52])
	by edgefb1.ncs.mcgill.ca (8.13.8/8.12.3) with ESMTP id qAA9r6Zc021035
	for <linux-wireless@vger.kernel.org>; Sat, 10 Nov 2012 04:53:06 -0500
Received: from edgemx6.ncs.mcgill.ca (edgemxdb6.ncs.McGill.CA [132.206.27.72])
	by edgesmtp1.ncs.mcgill.ca (Postfix) with ESMTP id 2BC5F1F001D
	for <linux-wireless@vger.kernel.org>; Sat, 10 Nov 2012 04:52:35 -0500 (EST)
Received: from edgemx6.ncs.mcgill.ca (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 10F5BCD8079
	for <linux-wireless@vger.kernel.org>; Sat, 10 Nov 2012 04:52:35 -0500 (EST)
Received: from exhub2010-3.campus.MCGILL.CA (exhub2010-3.campus.mcgill.ca [132.206.85.140])
	by edgemx6.ncs.mcgill.ca (Postfix) with ESMTP id ED92FCD8042
	for <linux-wireless@vger.kernel.org>; Sat, 10 Nov 2012 04:52:34 -0500 (EST)
Message-ID: <1352540937.4179.14.camel@eressea> (sfid-20121110_110047_692525_7EDB4EBA)
Subject: Unable to set regulatory domain
From: Felix Braun <Felix.Braun@mail.mcgill.ca>
To: <linux-wireless@vger.kernel.org>
Date: Sat, 10 Nov 2012 10:48:57 +0100
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there,

I'm having the following problem that I have so far failed to root
cause: my kernel spams the logfiles with calls to CRDA every three
seconds. This is caused by spurious (?) udev events:

# udevdam monitor --property

KERNEL[1469.840484] change   /devices/platform/regulatory.0 (platform)
ACTION=change
COUNTRY=00
DEVPATH=/devices/platform/regulatory.0
MODALIAS=platform:regulatory
SEQNUM=2472
SUBSYSTEM=platform

KERNEL[1469.848058] change   /devices/platform/regulatory.0 (platform)
ACTION=change
COUNTRY=97
DEVPATH=/devices/platform/regulatory.0
MODALIAS=platform:regulatory
SEQNUM=2473
SUBSYSTEM=platform

and so on and so forth every three seconds always in pairs for country
00 and then country 97.

I have a corresponding udev rule in /lib/udev/rules.d/85-regulatory
which instructs udev to call /usr/bin/crda. However, calling crda also
fails:

# COUNTRY=00 crda
Failed to set regulatory domain: -7

I have the following questions:
	- what does error code -7 stand for? How can I fix it?
	- how does the kernel produce the illegal country code 97?

I think part of the problem is that my wireless card seems to be
calibrated for China, whereas I am currenty located in Germany (which is
reflected by my access point)

Any pointers how to solve this would be very welcome.

Thanks in advance!
Felix

