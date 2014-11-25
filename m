Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48707 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaKYTAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 14:00:14 -0500
Date: Tue, 25 Nov 2014 13:50:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/4] brcmsmac: extend hardware info shown in debugfs
Message-ID: <20141125185049.GE15476@tuxdriver.com> (sfid-20141125_200026_213184_0B2FE169)
References: <1416518822-29585-1-git-send-email-arend@broadcom.com>
 <1416518822-29585-4-git-send-email-arend@broadcom.com>
 <20141124215049.GA4484@tuxdriver.com>
 <54747232.3030503@broadcom.com>
 <54747D76.6070207@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54747D76.6070207@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2014 at 02:00:38PM +0100, Arend van Spriel wrote:
> On 11/25/14 13:12, Arend van Spriel wrote:
> >On 11/24/14 22:50, John W. Linville wrote:
> >>Hmmm...I'm not sure why, but this is causing problems for me...
> >>
> >>ERROR: "brcmu_boardrev_str"
> >>[drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko] undefined!
> >
> >I am confused as well. I did not have such an issue. The function is
> >provided by brcmutil.ko (patch 2/4) and I did an EXPORT_SYMBOL and added
> >it to the include file. Missing something? Also I don't see this issue
> >over here. I will do a clean build on the wireless-next tree and see if
> >I can reproduce this.
> 
> So I did a fresh checkout of wireless-next/master and applied patch 2 and 3.
> Here is my build output:
> 
> $ make M=drivers/net/wireless/brcm80211 modules
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/ucode_loader.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/ampdu.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/antsel.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/channel.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/main.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy_shim.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/pmu.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/rate.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/stf.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/aiutils.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_n.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phy_qmath.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/dma.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmsmac/debug.o
>   LD [M]  drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmutil/utils.o
>   CC [M]  drivers/net/wireless/brcm80211/brcmutil/d11.o
>   LD [M]  drivers/net/wireless/brcm80211/brcmutil/brcmutil.o
>   Building modules, stage 2.
>   MODPOST 2 modules
>   CC      drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.mod.o
>   LD [M]  drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
>   CC      drivers/net/wireless/brcm80211/brcmutil/brcmutil.mod.o
>   LD [M]  drivers/net/wireless/brcm80211/brcmutil/brcmutil.ko
> 
> Anything else I should try over here?

/home/linville/git/wireless-testing
[linville-x1.hq.tuxdriver.com]:> make M=drivers/net/wireless/brcm80211 modules
  Building modules, stage 2.
  MODPOST 3 modules
WARNING: "brcmu_boardrev_str" [drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko] undefined!
  CC      drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.mod.o
  LD [M]  drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
  CC      drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.mod.o
  LD [M]  drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
  CC      drivers/net/wireless/brcm80211/brcmutil/brcmutil.mod.o
  LD [M]  drivers/net/wireless/brcm80211/brcmutil/brcmutil.ko

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
