Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49776 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab2FJN2l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 09:28:41 -0400
Message-ID: <4FD4A102.20805@hauke-m.de> (sfid-20120610_152918_879647_CE954AD0)
Date: Sun, 10 Jun 2012 15:28:34 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/18] brcmsmac: remove PCIE() makro
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de> <1338937641-8519-2-git-send-email-hauke@hauke-m.de> <4FD10989.6040701@broadcom.com>
In-Reply-To: <4FD10989.6040701@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2012 10:05 PM, Arend van Spriel wrote:
> On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
>> Instead of checking if there is a PCIe core on the bus, better check if
>> hosttype is PCIe.
> 
> I was under the impression that the macro was used for code needed when
> the chip has a PCIe core instead of a PCI core. Maybe BCMA only supports
> chips with PCIe core and in the respect checking the hosttype is
> essentially the same, but I would not necessarily call it better.
> 

The code from the initial submission to staging looked like this:

#define PCIE(si) ((BUSTYPE((si)->pub.bustype) == PCI_BUS) &&	\
		  ((si)->pub.buscoretype == PCIE_CORE_ID))

I have never seen a device using the AI bus (bcma) and a PCI core and
not a PCIe core and I do not think bcma will work with a PCI device or
core. The bustype in your old code is the same as the hosttype in bcma,
so under the assumption that all device are using PCIe that are coming
to this code the code now does the same as in the initial submission to
staging.

buscore in brcmsmac contained a reference to a PCIe core on the bus, if
there was any. On a SoC with a PCIe core in host mode this also
contained this PCIe core, but it was not the buscore and the hosttype
was not PCIE, nor the bustype when using your SDK would be PCI_BUS, but
SI_BUS.

So this patch is also more or less a bugfix for brcmsmac when you are
not on a PCIe connected device, like a SoC. The old code also caused a
null pointer in ai_get_buscoretype() and ai_get_buscorerev() if buscore
was not set because there was no PCIe core on the bus.

>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    9 ++++-----
>>  1 file changed, 4 insertions(+), 5 deletions(-)
>>
> 
> Gr. AvS
> 

