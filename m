Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:27456 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaKYNAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 08:00:41 -0500
Message-ID: <54747D76.6070207@broadcom.com> (sfid-20141125_140050_800231_50C83B4F)
Date: Tue, 25 Nov 2014 14:00:38 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] brcmsmac: extend hardware info shown in debugfs
References: <1416518822-29585-1-git-send-email-arend@broadcom.com> <1416518822-29585-4-git-send-email-arend@broadcom.com> <20141124215049.GA4484@tuxdriver.com> <54747232.3030503@broadcom.com>
In-Reply-To: <54747232.3030503@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/25/14 13:12, Arend van Spriel wrote:
> On 11/24/14 22:50, John W. Linville wrote:
>> Hmmm...I'm not sure why, but this is causing problems for me...
>>
>> ERROR: "brcmu_boardrev_str"
>> [drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko] undefined!
>
> I am confused as well. I did not have such an issue. The function is
> provided by brcmutil.ko (patch 2/4) and I did an EXPORT_SYMBOL and added
> it to the include file. Missing something? Also I don't see this issue
> over here. I will do a clean build on the wireless-next tree and see if
> I can reproduce this.

So I did a fresh checkout of wireless-next/master and applied patch 2 
and 3. Here is my build output:

$ make M=drivers/net/wireless/brcm80211 modules
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/ucode_loader.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/ampdu.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/antsel.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/channel.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/main.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy_shim.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/pmu.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/rate.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/stf.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/aiutils.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_n.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phy_qmath.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/dma.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.o
   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/debug.o
   LD [M]  drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.o
   CC [M]  drivers/net/wireless/brcm80211/brcmutil/utils.o
   CC [M]  drivers/net/wireless/brcm80211/brcmutil/d11.o
   LD [M]  drivers/net/wireless/brcm80211/brcmutil/brcmutil.o
   Building modules, stage 2.
   MODPOST 2 modules
   CC      drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.mod.o
   LD [M]  drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
   CC      drivers/net/wireless/brcm80211/brcmutil/brcmutil.mod.o
   LD [M]  drivers/net/wireless/brcm80211/brcmutil/brcmutil.ko

Anything else I should try over here?

Regards,
Arend
> Regards,
> Arend
>
>> On Thu, Nov 20, 2014 at 10:27:01PM +0100, Arend van Spriel wrote:
>>> The hardware info now also include radio and phy information, which
>>> can be helpful in debugging issues.
>>>
>>> Reviewed-by: Hante Meuleman<meuleman@broadcom.com>
>>> Reviewed-by: Pieter-Paul Giesberts<pieterpg@broadcom.com>
>>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>>> ---
>>> drivers/net/wireless/brcm80211/brcmsmac/debug.c | 40
>>> +++++++++++++++++--------
>>> 1 file changed, 27 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.c
>>> b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
>>> index 19740c1..c9a8b93 100644
>>> --- a/drivers/net/wireless/brcm80211/brcmsmac/debug.c
>>> +++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
>>> @@ -30,6 +30,7 @@
>>> #include "main.h"
>>> #include "debug.h"
>>> #include "brcms_trace_events.h"
>>> +#include "phy/phy_int.h"
>>>
>>> static struct dentry *root_folder;
>>>
>>> @@ -74,20 +75,33 @@ static
>>> int brcms_debugfs_hardware_read(struct seq_file *s, void *data)
>>> {
>>> struct brcms_pub *drvr = s->private;
>>> + struct brcms_hardware *hw = drvr->wlc->hw;
>>> + struct bcma_device *core = hw->d11core;
>>> + struct bcma_bus *bus = core->bus;
>>> + char boardrev[10];
>>>
>>> - seq_printf(s, "board vendor: %x\n"
>>> - "board type: %x\n"
>>> - "board revision: %x\n"
>>> - "board flags: %x\n"
>>> - "board flags2: %x\n"
>>> - "firmware revision: %x\n",
>>> - drvr->wlc->hw->d11core->bus->boardinfo.vendor,
>>> - drvr->wlc->hw->d11core->bus->boardinfo.type,
>>> - drvr->wlc->hw->boardrev,
>>> - drvr->wlc->hw->boardflags,
>>> - drvr->wlc->hw->boardflags2,
>>> - drvr->wlc->ucode_rev);
>>> -
>>> + seq_printf(s, "chipnum 0x%x\n"
>>> + "chiprev 0x%x\n"
>>> + "chippackage 0x%x\n"
>>> + "corerev 0x%x\n"
>>> + "boardid 0x%x\n"
>>> + "boardvendor 0x%x\n"
>>> + "boardrev %s\n"
>>> + "boardflags 0x%x\n"
>>> + "boardflags2 0x%x\n"
>>> + "ucoderev 0x%x\n"
>>> + "radiorev 0x%x\n"
>>> + "phytype 0x%x\n"
>>> + "phyrev 0x%x\n"
>>> + "anarev 0x%x\n"
>>> + "nvramrev %d\n",
>>> + bus->chipinfo.id, bus->chipinfo.rev, bus->chipinfo.pkg,
>>> + core->id.rev, bus->boardinfo.type, bus->boardinfo.vendor,
>>> + brcmu_boardrev_str(hw->boardrev, boardrev),
>>> + drvr->wlc->hw->boardflags, drvr->wlc->hw->boardflags2,
>>> + drvr->wlc->ucode_rev, hw->band->radiorev,
>>> + hw->band->phytype, hw->band->phyrev, hw->band->pi->ana_rev,
>>> + hw->sromrev);
>>> return 0;
>>> }
>>>
>>> --
>>> 1.9.1
>>>
>>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

