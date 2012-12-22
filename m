Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:35639 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2LVPpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 10:45:09 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: RFC: Driver ST-E cw1200 driver
Date: Sat, 22 Dec 2012 10:45:03 -0500
Message-Id: <1356191120-5280-1-git-send-email-pizza@shaftnet.org> (sfid-20121222_164514_301438_E54AC1C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Back in May, some folks at ST-E posted a GPL driver for their CW1200 
WLAN chipset.  After some back and forth, all communications from its 
authors abruptly ceased.

I've been maintaining and enhancing this driver for my employer, who 
manufactures modules that utilize the CW1200 chipset.  We've supplied it 
to our customers on top of a custom compat-wireless release, always 
intending to submit our fixes upstream once ST-E got the driver into the 
kernel.

That never happened, so instead of shouldering the maintainence burden 
on my own, I've decided to try and take up the torch and get this driver 
merged again.

This driver supports:

 * 802.11 Client (including WPA)
 * 802.11 AP (including WPA)
 * SDIO and SPI host interfaces
 * 802.11e/WMM/QoS
 * Has passed WFA testing
 * Big and Little Endian systems

There are known warts with this driver:
 
 * Driver targets 3.6.x kernel (haven't tried to build with 3.7/3.8-rc)
 * IBSS is busted, badly.
 * Lots of checkpatch warnings (I will fix this up for the next submission)
 * Lots of magic numbers used (intentionally, I suspect)
 * Lots of "that seems more complicated than it needs to be"
 * P2P is untested (by me) 
 * There are some quirks that are only present for compat-wireless's needs,
   such as the CMD53 workaround and the forced-enabled "generic" SDIO 
   support targetting my employer's SDIO modules.

This initial RFC posting is to elicit feedback for the bigger-picture 
things, rather than worrying about stylistic things like checkpatch 
failures.  There's too much to talk about in advance, so please ask 
questions, and point out stuff that can be done better.  I'll try to 
correct everything I can.

It's worth repeating that I'm not its original author either, but I'm 
willing to take ownership/maintainership to get this pushed into the 
mainline -- I'd love nothing more than for ST-E to take an official 
interest in this driver again.

Although I'm maintaining this driver for my employer, this upstream push 
is being done on my own initiative, on my own time.  It may have warts 
and some questionably complicated ways of doing things, but it does 
work, and is deployed on tens of thousands of systems in the real world.

Anyway.  Feedback welcome.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>


