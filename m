Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:50565 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZA3SJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 13:09:39 -0500
Message-Id: <F1FAF4F1-E45A-461D-8D46-5D1B1A1BBAE2@ing.unibs.it> (sfid-20090130_190943_641683_32E5AB17)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: ad-hoc mode implementation
Date: Fri, 30 Jan 2009 19:09:35 +0100
Cc: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I began testing the opensource firmware on b43 when running ad-hoc  
mode and I faced a strange problem that drove me to investigate about  
how ad-hoc mode is implemented inside the wireless stack. Note that  
what follows holds for both Broadcom original firmware and opensource  
one, however I did all these tests switching back to original BCM  
firmware.

It turned out that Apple Macs with 4328 hardware (bot a/b/g and n)  
running different version of OSX never succeed in joining ad-hoc  
networks initiated by b43 while they can join without problems ad-hoc  
networks run by ath5k (with initiated or run I mean "the first node  
that is configured with that SSID"). I attach a complete description  
of the tests at the end of this message.

I then captured some traffic and it seems that b43 never sends beacon  
when initiating ad-hoc networks, it just sends probes to itself and  
responds to broadcast probe requests. Note that ath5k instead sends  
beacons as long as it is the first node. Probably I'm missing  
something, so just responding to broadcast probes could be a correct  
alternative procedure to advertise ad-hoc network, however this seems  
to be the only difference to explain the different behavior of newer  
Apple Macs when joining ath5k or b43 ad-hoc initiated networks.

Please note that if I invert roles (ad-hoc initiated by those Apple  
Macs, b43 joining the network) everything is fine, so this is not an  
issue involving send and receive operations, nodes do not have  
communication problems.

Has anyone ever experienced such issues? Is it correct to not send  
beacon when starting an ad-hoc network? I did some tests and OSX does  
send beacon when initiating an ad-hoc network (as ath5k does).

Cheers,
-FG

----- testbed scenarios

When I initiate an ad-hoc network on a Linux PC with a 4306 card, I  
can't join it using any of my Apple Macs equipped with BCM hardware.

I tried two different Apple, one is a new MacBook Pro with 4328 BCM N- 
PHY, the other is a two years old iMac 17 with a a/b/g  4328 BCM  
hardware. The Kernel I used on the x86 PC was 2.6.29-rc2-wl, the  
firmware was the original Broadcom ucode5, I did not use encryption. I  
did extensive testing but I never succeeded.

I then tried the same setup, using this time a 4318 card to initiate  
the ad-hoc network on the Linux box, and I got the same behavior.  
Finally I repeated the experiment this time initiating the ad-hoc  
network with a Linksys WRT54GL (BCM 4320), same result, the two Apple  
Macs never joined the network, they reported a generic error and  
nothing more.

Please note that if I repeat the experiments using a MacBook Pro with  
Atheros hardware everything works fine. Also all other Linux PC I have  
do not have problems in joining these b43-run ad-hoc networks  
independently of the kind of Atheros or BCM hardware they use.

