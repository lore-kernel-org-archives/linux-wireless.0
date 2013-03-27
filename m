Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:55955 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796Ab3C0KY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 06:24:29 -0400
Message-ID: <5152C8DB.4080105@dpets.co.uk> (sfid-20130327_112434_800687_A69DEDA4)
Date: Wed, 27 Mar 2013 10:24:27 +0000
From: John Talbut <jt@dpets.co.uk>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Arend van Spriel <arend@broadcom.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org
Subject: Re: brcmsmac in kernel driver on a Samsung NC110
References: <51514F1B.1080207@dpets.co.uk> <5151639F.4010700@broadcom.com> <51516BC2.5010004@dpets.co.uk> <515173A4.7030607@broadcom.com> <515179C5.50406@dpets.co.uk> <51517E28.5000303@broadcom.com> <515182C6.5030305@dpets.co.uk> <51518682.7060503@broadcom.com> <515189C6.7070003@dpets.co.uk> <51518E14.3050500@broadcom.com> <CACna6ryjYroPdWoKhz25KUtURpSGDta0UvGeOLms9jy1tnw1Xg@mail.gmail.com> <5151EC49.9030109@dpets.co.uk> <5151F088.2040408@hauke-m.de> <5151FB85.5080007@dpets.co.uk> <51521A8A.6060900@broadcom.com> <CACna6rwWNtPBJDShe1ia9dB_o40V_zZ1DFv677VSpmOmw083-A@mail.gmail.com>
In-Reply-To: <CACna6rwWNtPBJDShe1ia9dB_o40V_zZ1DFv677VSpmOmw083-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27/03/13 07:46, Rafał Miłecki wrote:
> 2013/3/26 Arend van Spriel <arend@broadcom.com>:
>> On 03/26/2013 08:48 PM, John Talbut wrote:
>>> echo "14e4 4357" > /sys/bus/pci/drivers/bcma-pci-bridge/new_id
>>> bash: /sys/bus/pci/drivers/bcma-pci-bridge/new_id: No such file or directory
>>
>> This could mean you do not have CONFIG_BCMA_HOST_PCI=y in your .config
> 
> Exactly. Make sure you have CONFIG_BCMA_HOST_PCI=y and that your
> host_pci.c is not modified/hacked/whatever.
> 
> You can compare it with
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/bcma/host_pci.c
> bcma_pci_bridge_tbl.
> 
OK, thanks, I have recompiled the kernel with CONFIG_BCMA_HOST_PCI=y and
we have some progress.

ls /sys/bus/bcma/devices
bcma0:0

lspci -d 14e4: -v
now has a line:
Kernel driver in use: bcma-pci-bridge

host_pci.c is the same as torvalds.

However, kernel log includes:
brcmsmac bcma0:0: firmware: agent aborted loading brcm/bcm43xx-0.fw (not
found?)
ieee80211 phy0: brcmsmac: Failed to find firmware usually in
/lib/firmware/brcm
brcmsmac: brcms_bcma_probe: brcms_attach failed!

And iwconfig shows no wireless extensions.

John
