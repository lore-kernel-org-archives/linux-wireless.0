Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53182 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934392Ab1JEOlD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 10:41:03 -0400
Message-ID: <4E8C6C77.9000402@hauke-m.de> (sfid-20111005_164107_455047_4F9A54A3)
Date: Wed, 05 Oct 2011 16:40:55 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/15] staging: brcm80211: cleanup fullmac structs and
 softmac srom lookup
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2011 03:19 PM, Arend van Spriel wrote:
> This series addresses more community feedback items received on mainline
> patch (v2) posted August 25, 2011. The driver structures in brcmfmac could
> do with some tidying and in the brcmsmac variables loaded from srom were
> accessed by string identifiers. This has been replaced by enumerated
> identifiers and the entries are stored in kernel standard linked list.
> 
> This series applies to staging-next and depends on the patch series posted
> on Oct 4, 2011 (see Message-ID below).
> 
> Message-ID: <1317763152-17607-1-git-send-email-arend@broadcom.com>
> 
> Arend van Spriel (11):
>   staging: brcm80211: move driver variable functions to srom.c
>   staging: brcm80211: remove code duplication for driver variable
>     lookup
>   staging: brcm80211: change parameter in driver variable lookup
>   staging: brcm80211: remove locking macro definitions
>   staging: brcm80211: fix thread blocking issue in
>     brcmf_sdbrcm_bus_stop()
>   staging: brcm80211: remove invalid variable lookup from srom
>   staging: brcm80211: use identifiers instead of string for srom lookup
>   staging: brcm80211: use enum identifiers in srom variable tables
>   staging: brcm80211: replace string based variable storage by linked
>     list
>   staging: brcm80211: remove parameter 'off' from _initvars_srom_pci()
>   staging: brcm80211: cleanup driver variable references
> 
> Franky Lin (4):
>   staging: brcm80211: remove threads_only code from fullmac
>   staging: brcm80211: remove redundant bus register layer from fullmac
>   staging: brcm80211: clean up struct brcmf_if in fullmac
>   staging: brcm80211: remove brcmf_op_if from fullmac
> 
>  drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   10 -
>  drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   16 +-
>  drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |  134 +--
>  drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  133 +--
>  drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    4 -
>  drivers/staging/brcm80211/brcmsmac/aiutils.c      |   32 +-
>  drivers/staging/brcm80211/brcmsmac/aiutils.h      |    6 +-
>  drivers/staging/brcm80211/brcmsmac/antsel.c       |   15 +-
>  drivers/staging/brcm80211/brcmsmac/channel.c      |    2 +-
>  drivers/staging/brcm80211/brcmsmac/mac80211_if.c  |  157 ++--
>  drivers/staging/brcm80211/brcmsmac/main.c         |  144 +---
>  drivers/staging/brcm80211/brcmsmac/main.h         |    5 -
>  drivers/staging/brcm80211/brcmsmac/nicpci.c       |    5 +-
>  drivers/staging/brcm80211/brcmsmac/nicpci.h       |    2 +-
>  drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c  |   42 +-
>  drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h  |    4 +-
>  drivers/staging/brcm80211/brcmsmac/phy/phy_int.h  |    7 -
>  drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c  |   64 +-
>  drivers/staging/brcm80211/brcmsmac/phy/phy_n.c    |  330 ++++--
>  drivers/staging/brcm80211/brcmsmac/phy_shim.c     |    9 +
>  drivers/staging/brcm80211/brcmsmac/phy_shim.h     |    4 +
>  drivers/staging/brcm80211/brcmsmac/pub.h          |  263 +++++-
>  drivers/staging/brcm80211/brcmsmac/srom.c         | 1124 +++++++++++----------
>  drivers/staging/brcm80211/brcmsmac/srom.h         |    4 +-
>  drivers/staging/brcm80211/brcmsmac/stf.c          |    4 +-
>  25 files changed, 1342 insertions(+), 1178 deletions(-)
> 
Hi Arend,

the code handling sprom looks better that before, but why don't you use
a struct for the sprom and put all the stuff into it like it is done in
ssb/bcma? We have haven't observance any problem using structs in b43 on
pci bus and SoCs with a nvram storing the sprom variables.

I found some references to SROM4_ and other older version, but I think
this driver only supports devices with sprom 8 and 9.

Hauke
