Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51984 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbbCUUi6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2015 16:38:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YZQAX-0004QG-KQ
	for linux-wireless@vger.kernel.org; Sat, 21 Mar 2015 21:38:53 +0100
Received: from p5793853F.dip0.t-ipconnect.de ([87.147.133.63])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 21 Mar 2015 21:38:53 +0100
Received: from juergen.Bausa by p5793853F.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 21 Mar 2015 21:38:53 +0100
To: linux-wireless@vger.kernel.org
From: =?utf-8?b?SsO8cmdlbg==?= Bausa <juergen.Bausa@online.de>
Subject: Re: Broadcom 43340
Date: Sat, 21 Mar 2015 20:38:37 +0000 (UTC)
Message-ID: <loom.20150321T213803-13@post.gmane.org> (sfid-20150321_213901_650009_57F3B096)
References: <550482A2.3080803@gmail.com>	<55048833.90408@broadcom.com>	 	<55048BB1.9080906@gmail.com>	<550491DA.6030105@broadcom.com>	 	<55049507.6040209@gmail.com> <20150314213907.3f1167bb@mir>	  <5504B29F.8000305@gmail.com> <55056EFB.9020100@broadcom.com>	  <loom.20150315T213441-211@post.gmane.org> <5505F651.3060607@broadcom.com>	  <loom.20150317T214603-379@post.gmane.org>	 <1426634407.11120.50.camel@redhat.com>	 <loom.20150318T222315-999@post.gmane.org> <1426714179.26901.37.camel@redhat.com> <5509F0B5.7030601@broadcom.com> <loom.20150319T215852-35@post.gmane.org> <550B4241.4040101@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@...> writes:

> 
> 
> CONFIG_BRCM_TRACING is another way to get debug output, but I guess that 
> is not enabled either.
> 

Just found this via google to enable wlan:

1. the nvram file under /sys/firmware/efi/efivars/ has a wrong MAC address.
I changed it to the correct one. However, I am not sure if this is really
necassary.

2. Found the following on the web:

>rmmod brcmfmac
>rmmod brcmutil
>echo on > /sys/bus/platform/drivers/sdhci-acpi/INT33BB\:00/power/control
>modprobe brcmfmac

After this, I can connect to wlan!

Does this give you enough information to find out, what the problem is? Or
do you still need DBG output from the driver? if so, just tell me and I will
try to compile and install the kernel with DBG turnded on. Its not a big
deal but I stopped working on it as I found this workaround.

At the momment I am trying to put these commands to rc,local. With limited
success until now, But this may be caused by the fact, that they are
executed too early. Will add some sleep.

Another thing I found out is, that the system sometimes comes up without
wlan0. It seems I have it only on every second boot. However, this could be
just by incident and it is not exactly every second boot but about 50 % of
all boots.

Juergen



