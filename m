Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44228 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab2KPXfO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 18:35:14 -0500
Message-ID: <50A6CDA0.2080904@hauke-m.de> (sfid-20121117_003518_149244_9EB5E751)
Date: Sat, 17 Nov 2012 00:34:56 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Elliott Mitchell <ehem+outbound@m5p.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcm4716 and PCIe
References: <20121116044429.GA73539@scollay.m5p.com> <50A67454.6000804@hauke-m.de> <20121116201705.GA75969@scollay.m5p.com>
In-Reply-To: <20121116201705.GA75969@scollay.m5p.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2012 09:17 PM, Elliott Mitchell wrote:
> On Fri, Nov 16, 2012 at 06:13:56PM +0100, Hauke Mehrtens wrote:
>> On 11/16/2012 05:44 AM, Elliott Mitchell wrote:
>>> I happened to be browsing the linux-mips git repository and noticed the
>>> commit at Tue, 10 Jul 2012 16:16:47.
>>
>> What commit are you talking about? Do you have a commit id?
> 
> Looking at: http://git.linux-mips.org/?p=ralf/linux.git;a=commitdiff;h=1dfef20a4cf82997d4c7520138ed8188a181241c
> 
> I'm guessing "1dfef20a4cf82997d4c7520138ed8188a181241c" is the commit id.
> 
> Subject is: "brcmsmac: remove PCI_FORCEHT() macro"
> 
> Description is:
> The BCM4716 is a SoC and does not have a PCI client interface, so this
> condition is never true.
> 
> Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> I'm guessing the piece of code is invoked on all flavors of bcm471[678],
> so while it doesn't get invoked on most devices, some of them it
> definitely can be.

I have never seen a bcm4718 with a PCIe controller running in client
mode and it does not make sense to me. PCIe client mode means it is
connected to some other controller like in a Intel chipset in a desktop
PC, but there you would use a normal PCIe card and not a SoC. The
controller is normally running in host mode, so an other PCIe card like
the BCM43224 could be connected to the PCIe controller in the SoC. I
have a Netgear WNDR3400 with a BCM4718 and a BCM43224 connected to the
PCIe host controller in the SoC.

>>> The Broadcom 4716 *does* have an external PCI Express interface! Take a
>>> look at the images on http://wiki.openwrt.org/toh/asus/rt-n16  If you
>>> look at the image of the underside
>>> (http://wiki.openwrt.org/_media/inbox/rt-n16_back_hires.jpg) on the right
>>> side, CON3 and CON5 are the solder pads for mounting a mini-PCIe
>>> connector and bracket.  Apparently V11 is a voltage regulator needed for
>>> that to work, but on this an example of a Broadcom 4716 board that really
>>> does allow a useable PCIe interface (with some hardware hacking).
>>
>> Are you sure the Asus rt-n16 has a BCM4716 and not an BCM4718? Both have
>> the same chip id (0x4716), but a different revision number (BCM4716 =
>> rev 8, BCM4718 = rev 10). The BCM4716 and BCM4717 do not have a PCIe
>> controller, just the BCM4718 has one [0].
> 
> I'm not actually.  Currently exploring a device with ASUS's minimal shell
> they give you.  According to /proc/cpuinfo, "system type: Broadcom
> BCM4716 chip rev 1 pkg 10".  If I'm looking at the correct byte in
> /sys/devices/[...]/config, it does in fact appear to be 0x0A (decimal
> 10).

So it is a BCM4718 with a PCIe controller.

> I've seen photos of some people in Taiwan who soldered something at V11
> (presumably a voltage regulator, it's all Chinese to me).  I'm guessing
> they did in fact get a MiniPCIe card to work, but everything is in the
> wrong language.   :-)   The crucial build photo of the regulator module
> has disappeared, so it is more difficult to reconstruct.

Yes that could be possible and mainline linux would support such a
setup. Be aware that the PCIe controller in the BCM4718 reorders some of
the PCIe writes and reads, which causes some problems.

Hauke
