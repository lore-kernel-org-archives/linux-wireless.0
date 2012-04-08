Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4282 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab2DHIvU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2012 04:51:20 -0400
Message-ID: <4F815181.6030007@broadcom.com> (sfid-20120408_105125_177329_88AA8A24)
Date: Sun, 8 Apr 2012 10:51:13 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: brcmsmac on BCM47XX SoCs
References: <4F7F71A2.40105@hauke-m.de>
In-Reply-To: <4F7F71A2.40105@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/06/2012 11:43 PM, Hauke Mehrtens wrote:
> Hi Arend,
>
> I am currently trying to get brcmsmac running on my SoC (bcm4718 +
> bcm43224). Using the sprom from bcma and not fetching it in brcmsmac was
> not a big problem, are you interested in the patch?

Great. Some time ago I sent out a patch for parsing the sprom in bcma 
supporting newer sprom revisions and cutting loose from SSB. While in 
transit back from the collab summit last week I worked on v2 of that 
patch. That probably would affect your nvram work, ie. struct bcma_sprom 
iso ssb_sprom.

> I want to remove the pci code from brcmsmac as it should go into bcma
> and some/most parts of the code are already there. I already did some of
> this but I still have problems with my device, have you already started
> this? I do not know if these problems  are related to my changes or some
> other problems with my devices and brcmsmac.

True. host bus specific code should go. I did change brcmsmac to use the 
DMA-API instead of the pci-dma interface, but there is still stuff to do 
there. I have a 4718 reference design on my desk, but did not get to put 
it to use. What embedded distro are you using?

> I want to get AP mode working on these device with brcmsmac, but for now
> I do not even get station mode running. ;-)

I see why you want AP mode.

> Are there any devices with a ccrev<  20 supported by brcmsmac, the
> lowest version I saw was 31 and there are some conditions in brcmsmac
> for<  6,<  10 and<  20?

brcmsmac is targetted for bcm4313, bcm43224, and bcm43225 so the lowest 
is ccrev 32. The bcm4718 seems to have ccrev 31.

> What are your plans to support phy_ht in brcmsmac, for now it is just
> supported by b43?

I have not been paying good attention to community feedback on b43 
phy_ht support. As b43 support bcm4331 with that phy we decided to stay 
clear from that device. We are to add new phy code for new devices. Not 
sure if that includes the phy_ht.

> I am a little confused by the vendorid/vid and vendorid/did and the
> boardvendor and boardtype members. brcms_c_chipmatch() uses vendorid and
> vendorid from the pci config space, but what is the equivalent for SoCs
> not on pci bus? boardvendor and boardtype are fetched in
> ai_nvram_process and are fetched from nvram when an SoC is used and from
> pci config space on a pci device at least that is the way it is done in
> the Boradcom SDK.

I have to dive into this one. For now, happy Easter.

Gr. AvS

ps: Boradcom. I am making that typo all the time.


