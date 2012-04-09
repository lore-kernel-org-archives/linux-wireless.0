Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42139 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497Ab2DINGc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 09:06:32 -0400
Message-ID: <4F82DECD.1090404@hauke-m.de> (sfid-20120409_150642_533202_56276FC1)
Date: Mon, 09 Apr 2012 15:06:21 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: brcmsmac on BCM47XX SoCs
References: <4F7F71A2.40105@hauke-m.de> <4F815181.6030007@broadcom.com>
In-Reply-To: <4F815181.6030007@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2012 10:51 AM, Arend van Spriel wrote:
> On 04/06/2012 11:43 PM, Hauke Mehrtens wrote:
>> Hi Arend,
>>
>> I am currently trying to get brcmsmac running on my SoC (bcm4718 +
>> bcm43224). Using the sprom from bcma and not fetching it in brcmsmac was
>> not a big problem, are you interested in the patch?
> 
> Great. Some time ago I sent out a patch for parsing the sprom in bcma
> supporting newer sprom revisions and cutting loose from SSB. While in
> transit back from the collab summit last week I worked on v2 of that
> patch. That probably would affect your nvram work, ie. struct bcma_sprom
> iso ssb_sprom.

I used the content of struct ssb_sprom, as it is filled with all values
needed by brcmsmac from the nvram, I haven't check if they are filled by
the pci parsing code.
Moving to an other struct for bcma will result in some changes in
arch/mips/bcm47xx/sprom.c, but that should be doable. For my device it
looks like it also works with struct ssb_sprom.

How is the country code handelt? The nvram of my device contains
"ccode=EU" 5 times with all sort of prefixes. EU does not seam to be a
real regularity domain as most of the countries in the EU have their own
regulations and the Linux regulation databases does not know the key EU.
I haven't looked deeper into that topic I just saw some error message
because of EU being unknown.

>> I want to remove the pci code from brcmsmac as it should go into bcma
>> and some/most parts of the code are already there. I already did some of
>> this but I still have problems with my device, have you already started
>> this? I do not know if these problems  are related to my changes or some
>> other problems with my devices and brcmsmac.
> 
> True. host bus specific code should go. I did change brcmsmac to use the
> DMA-API instead of the pci-dma interface, but there is still stuff to do
> there. I have a 4718 reference design on my desk, but did not get to put
> it to use. What embedded distro are you using?

I think it is manageable to get it working on SoCs. The first thing I
see is to get the code from nicpci.c merged into bcma and then remove
nicpci.c, otp.c and srom.c from brcmsmac.

I am using OpenWrt trunk and it should work on your device, if it is
similar to the devices sold to end users from Asus, Netgear and so one,
expect for Ethernet, there are still the legal problems with that, but
USB works.

>> I want to get AP mode working on these device with brcmsmac, but for now
>> I do not even get station mode running. ;-)
> 
> I see why you want AP mode.
> 
>> Are there any devices with a ccrev<  20 supported by brcmsmac, the
>> lowest version I saw was 31 and there are some conditions in brcmsmac
>> for<  6,<  10 and<  20?
> 
> brcmsmac is targetted for bcm4313, bcm43224, and bcm43225 so the lowest
> is ccrev 32. The bcm4718 seems to have ccrev 31.

Ok, so the code for the old ccrevs can be removed, some, sometimes pci
depended, code less to worry about.

>> What are your plans to support phy_ht in brcmsmac, for now it is just
>> supported by b43?
> 
> I have not been paying good attention to community feedback on b43
> phy_ht support. As b43 support bcm4331 with that phy we decided to stay
> clear from that device. We are to add new phy code for new devices. Not
> sure if that includes the phy_ht.
> 
>> I am a little confused by the vendorid/vid and vendorid/did and the
>> boardvendor and boardtype members. brcms_c_chipmatch() uses vendorid and
>> vendorid from the pci config space, but what is the equivalent for SoCs
>> not on pci bus? boardvendor and boardtype are fetched in
>> ai_nvram_process and are fetched from nvram when an SoC is used and from
>> pci config space on a pci device at least that is the way it is done in
>> the Boradcom SDK.
> 
> I have to dive into this one. For now, happy Easter.
> 
> Gr. AvS
> 
> ps: Boradcom. I am making that typo all the time.
I should add that to by spell checker, as this is not the first time. ;-)

Happy Easter you too,

Hauke
