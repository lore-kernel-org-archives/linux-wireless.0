Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2710 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759266Ab2CAM6g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 07:58:36 -0500
Message-ID: <4F4F7271.8080900@broadcom.com> (sfid-20120301_135840_293351_1FC4AF7E)
Date: Thu, 1 Mar 2012 13:58:25 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Helmut Jarausch" <jarausch@igpm.rwth-aachen.de>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmsmac crashed 3.3-rc5 kernel
References: <jinmr4$pej$1@dough.gmane.org>
In-Reply-To: <jinmr4$pej$1@dough.gmane.org>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/01/2012 12:33 PM, Helmut Jarausch wrote:
> Hi,
>
> on an HP625 I have the following device
>
> 06:00.0 Network controller [0280]: Broadcom Corporation BCM4313 802.11b/g/
> n Wireless LAN Controller [14e4:4727] (rev 01)
>          Subsystem: Hewlett-Packard Company Device [103c:145c]
>          Kernel driver in use: bcma-pci-bridge
>
>
> This device isn't recognized by the brcmfmac driver but only by the
> brcmsfac driver.

That is expected. brcmfmac is support sdio/usb cards. brcmsmac is used 
for bcm4313 card.

> My kernel configuration is
>
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=y
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> CONFIG_BCMA_HOST_PCI=y
> # CONFIG_BCMA_DEBUG is not set
>
> # CONFIG_B43 is not set
> # CONFIG_B43LEGACY is not set
> CONFIG_BRCMUTIL=m
> CONFIG_BRCMSMAC=m
> # CONFIG_BRCMFMAC is not set
> CONFIG_BRCMDBG=y
>

looks ok.

>
> but doing  /etc/init.d/net.wlan0 start
> crashes the kernel - even<Ctrl><Alt><Shift><SysRq>   doesn't work anymore.
> I've tried strace, but the output file doesn't get closed so it's missing
> after reboot.

You could try some kernel hacking features. Some can help to get some 
vital info on screen.

> Any help is very much appreciated.
>
> P.S. the GRML64 live CD system does work on that hardware but it uses a
> 3.1 kernel and a staging driver.
>
> Since I'd like to use BTRFS I'd like to use a 3.3 kernel.
> Helmut.

Some more details would certainly increase my ability to help you.

Gr. AvS

