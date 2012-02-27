Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.keele.netcentral.co.uk ([212.57.235.197]:48361 "EHLO
	smtp3.keele.netcentral.co.uk" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751429Ab2B0LEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 06:04:24 -0500
Received: from terrafix.co.uk (reverse.keele.netcentral.co.uk [212.57.249.250] (may be forged))
	by smtp3.keele.netcentral.co.uk (8.14.2/8.14.2) with ESMTP id q1RA9CDI013920
	for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 10:09:21 GMT
Received: from WorldClient by terrafix.co.uk (MDaemon PRO v12.5.3)
	with ESMTP id md50002180617.msg
	for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 10:09:12 +0000
Date: Mon, 27 Feb 2012 10:09:11 +0000
From: "Joe Woodward" <jw@terrafix.co.uk>
To: linux-wireless@vger.kernel.org
Subject: libertas firmware loading slow with latest UDEV
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <WC20120227100911.6501DA@terrafix.co.uk> (sfid-20120227_120427_849747_E238FB57)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Im running on a stock 3.2 kernel and have updated from udev-175 to udev-181/kmod-5, and loading the libertas firmware (WiFi SD8686 SDIO) 
takes a *lot* longer (it does eventually succeed).

In fact, it takes 30 seconds longer, which seems to imply some timeout somewhere is being hit.

# modprobe libertas_sdio
[  108.600311] libertas_sdio: Libertas SDIO driver
[  108.613891] libertas_sdio: Copyright Pierre Ossman
[  139.116882] libertas_sdio mmc1:0001:1: (unregistered net_device): 00:19:88:3e:4f:f9, fw 9.70.3p36, cap 0x00000303
[  139.191223] libertas_sdio mmc1:0001:1: wlan0: Marvell WLAN 802.11 adapter

After doing an initial Google it seems that changes in udev-177 may have caused this issue, and that this is due to the way certain drivers load 
firmware, which needs fixing in the kernel.

So I have a couple of questions:
 - Is this analysis correct?
 - In my case is this a libertas_sdio-specific driver issue?
 - And is anyone working on a fix or have a patch for a fix?
 - Or is there anything I can do to work around this problem in the mean time?

Thanks,
Joe



References:
http://www.spinics.net/lists/netdev/msg185742.html
https://bbs.archlinux.org/viewtopic.php?id=134012

>From https://bbs.archlinux.org/viewtopic.php?pid=1045516#p1045516:
What is happening is that some kernel drivers are asking udev to load their firmware before their modules have finished loading. This used to work 
fine because udev gave firmware request special treatment and served them without waiting for anything else.

As of udev-177 this is no longer done. All events are treated the same, and a firmware event that is the child of a module event (which is the case 
that is causing us problems) is only served once the parent event has finished. In order to avoid dead-locks the modprobe is given a 30 seconds 
timeout, after which the firmware event can continue to be loaded. This is what you are seeing.

This problem should be solved by fixing the kernel drivers, and I know that at least he netdev guys are aware of it and working on it. If anyone is 
interested in helping out they should go to the kernel bugzilla/mailinglist.


