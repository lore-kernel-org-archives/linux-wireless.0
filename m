Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60694 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab2LCEzA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 23:55:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1TfO3b-0006mh-Ax
	for linux-wireless@vger.kernel.org; Mon, 03 Dec 2012 05:55:03 +0100
Received: from c-71-231-49-117.hsd1.wa.comcast.net ([71.231.49.117])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2012 05:55:03 +0100
Received: from nlhintz by c-71-231-49-117.hsd1.wa.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2012 05:55:03 +0100
To: linux-wireless@vger.kernel.org
From: Nathan Hintz <nlhintz@hotmail.com>
Subject: Re: brcmsmac: Data bus error in reading =?utf-8?b?dHNmX3JhbmRvbQ==?=
Date: Mon, 3 Dec 2012 04:47:38 +0000 (UTC)
Message-ID: <loom.20121203T054035-582@post.gmane.org> (sfid-20121203_055507_275104_91564963)
References: <50BAB095.2070103@hauke-m.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke Mehrtens <hauke@...> writes:

> 
> Hi Arend,
> 
> I am getting a Data bus error when brcmsmac tries to read tsf_random in
> brcms_c_wme_setparams. This does not happen when I add a printk
> somewhere near that read of tsf_random or when I replace the read with a
> constant. In b43 this code works, without this error for me, see
> b43_qos_params_upload(). With the BCM4716 I do not have this problem. It
> could be that this is caused by the broken PCIe controller in the BCM4716.
> 
> I am using brcmsmac from compat-wireless 2012-09-07, but I have also
> tried the most recent brcmsmac code from wireless-testing. brcmsmac uses
> the normal firmware from linux-firmware and I have also tried the new
> firmware posted some days ago with the same result.
> 
> I am using a BCM43224 connected to the PCIe controller of the BCM4716.
> 
> Are there any special requirements for reading tsf_random under mips?
> 
> To make my BCM43224 work I use this patch [0], the "printk("dummy\n");"
> is a hack to workaround the problem I am describing here.
> 
> Hauke
> 
> [0]:
>

<snip>

I encountered a similar DBE using the "broadcom-wl" driver (OpenWRT) on a 
Linksys E3000; except that it occurred when reading "ifs_ctl" (offset 0x688).  
I too tried putting in some printk's (in linux_osl.c), which caused the 
problem to go away.  I eventually found that doing a dummy read of 4 bytes 
at that particular address just prior to the actual two byte read caused 
the problem to go away as well (an ugly hack).  I can reproduce it if you 
want a stack trace.

Nathan


