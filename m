Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38471 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756434Ab2DZNDX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 09:03:23 -0400
Message-ID: <4F994791.8020801@hauke-m.de> (sfid-20120426_150327_493445_C561EFC7)
Date: Thu, 26 Apr 2012 15:03:13 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] wireless: properly use pr_fmt()
References: <1335234998-31547-1-git-send-email-mcgrof@frijolero.org>
In-Reply-To: <1335234998-31547-1-git-send-email-mcgrof@frijolero.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2012 04:36 AM, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
> 
> pr_fmt() is either defined or we redefine it. Typically
> drivers define it prior to including printk.h but this
> is done under the assumption that no other subsystem
> it uses has already defined pr_fmt(). In such cases
> pr_fmt() should be undefined and redefined.
> 
> Doing this properly shaves down compilation time quite
> considerably.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
> ---
> 
> I left out only ath6kl as ath6kl folks get groggy it seems
> if you do not go through their tree. Bleh.
> 
>  drivers/net/wireless/ath/ath5k/ani.c                   |    3 +++
>  drivers/net/wireless/ath/ath5k/attach.c                |    2 ++
>  drivers/net/wireless/ath/ath5k/base.c                  |    2 ++
>  drivers/net/wireless/ath/ath5k/desc.c                  |    3 +++
>  drivers/net/wireless/ath/ath5k/dma.c                   |    3 +++
>  drivers/net/wireless/ath/ath5k/eeprom.c                |    2 ++
>  drivers/net/wireless/ath/ath5k/initvals.c              |    3 +++
>  drivers/net/wireless/ath/ath5k/led.c                   |    2 ++
>  drivers/net/wireless/ath/ath5k/mac80211-ops.c          |    3 +++
>  drivers/net/wireless/ath/ath5k/pci.c                   |    2 ++
>  drivers/net/wireless/ath/ath5k/phy.c                   |    2 ++
>  drivers/net/wireless/ath/ath5k/qcu.c                   |    3 +++
>  drivers/net/wireless/ath/ath5k/reset.c                 |    2 ++
>  drivers/net/wireless/ath/ath5k/sysfs.c                 |    2 ++
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c          |    3 +++
>  drivers/net/wireless/ath/ath9k/htc_hst.c               |    3 +++
>  drivers/net/wireless/ath/ath9k/init.c                  |    2 ++
>  drivers/net/wireless/ath/ath9k/pci.c                   |    2 ++
>  drivers/net/wireless/ath/main.c                        |    2 ++
>  drivers/net/wireless/ath/regd.c                        |    2 ++
>  drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c       |    2 ++
>  drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 ++
>  drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c      |    2 ++
>  drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c   |    2 ++
>  drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 ++
>  drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c     |    1 +
>  drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c    |    2 ++
>  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    2 ++
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c      |    2 ++
>  drivers/net/wireless/brcm80211/brcmsmac/dma.c          |    3 ++-
>  drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    2 ++
>  drivers/net/wireless/brcm80211/brcmsmac/main.c         |    2 ++
>  drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |    2 ++
>  drivers/net/wireless/brcm80211/brcmutil/utils.c        |    2 ++
>  drivers/net/wireless/iwlegacy/3945-mac.c               |    2 ++
>  drivers/net/wireless/iwlegacy/4965-mac.c               |    2 ++
>  drivers/net/wireless/iwlwifi/iwl-agn.c                 |    2 ++
>  drivers/net/wireless/iwlwifi/iwl-pci.c                 |    2 ++
>  drivers/net/wireless/libertas/cfg.c                    |    2 ++
>  drivers/net/wireless/libertas/if_cs.c                  |    2 ++
>  drivers/net/wireless/libertas/if_sdio.c                |    2 ++
>  drivers/net/wireless/libertas/if_spi.c                 |    2 ++
>  drivers/net/wireless/libertas/if_usb.c                 |    2 ++
>  drivers/net/wireless/libertas/main.c                   |    2 ++
>  drivers/net/wireless/libertas/mesh.c                   |    2 ++
>  drivers/net/wireless/libertas/rx.c                     |    2 ++
>  drivers/net/wireless/libertas_tf/cmd.c                 |    2 ++
>  drivers/net/wireless/libertas_tf/if_usb.c              |    2 ++
>  drivers/net/wireless/libertas_tf/main.c                |    2 ++
>  drivers/net/wireless/rtlwifi/wifi.h                    |    2 ++
>  net/wireless/core.c                                    |    2 ++
>  net/wireless/lib80211.c                                |    2 ++
>  net/wireless/lib80211_crypt_tkip.c                     |    2 ++
>  net/wireless/reg.c                                     |    2 ++
>  54 files changed, 115 insertions(+), 1 deletion(-)
> 

Hi Luis,

the problem here is that compat-wireless globally includes lots of
header files from the kernel and that also includes printk.h. I made a
patch some time ago to restructure compat so that we do not have to
include all these headers files globally. I will work on that again and
will try to send  a RFC patches sometime today. This also fixed the
pr_fmt() problem without the need of any patches in
compat-wireless/patches and made it possible to remove some other
patches as well.

My plan was to place the compat header code which is now in
compat/include/linux/compat-*.h into the headers where it is in the
mainline kernel and include the original file with inlcude_next.

Hauke
