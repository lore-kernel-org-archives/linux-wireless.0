Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1912 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab1F2Xsd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:33 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 000/119] staging: brcm80211: more code cleanup and bug
 fixed
Date: Wed, 29 Jun 2011 16:46:24 -0700
Message-ID: <1309391303-22741-1-git-send-email-frankyl@broadcom.com> (sfid-20110630_014847_813563_0F7BA41B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most of these patches are brcmfmac cleanup.

Arend van Spriel (67):
  staging: brcm80211: fix checkpatch errors in types.h
  staging: brcm80211: remove flash related code from
    initvars_srom_pci()
  staging: brcm80211: minor cleanup in initvars_srom_pci()
  staging: brcm80211: make use of linux error codes in srom.c
  staging: brcm80211: remove code for unsupported chipsets from
    brcmsmac
  staging: brcm80211: remove unsupported chipset code from brcmsmac phy
  staging: brcm80211: remove otp power control functions
  staging: brcm80211: remove code from pmu.c related to unsupported
    chipsets
  staging: brcm80211: remove unused macro definitions from pmu.c
  staging: brcm80211: remove chip simulation specific code
  staging: brcm80211: remove macro FOREACH_AS_STA
  staging: brcm80211: change FOREACH_BSS macro to remove checkpatch
    error
  staging: brcm80211: remove macro definition DRV_MODULE_NAME
  staging: brcm80211: get rid on IS_CFG80211_FAVORITE macro
  staging: brcm80211: move assert function to dhd_linux.c
  staging: brcm80211: correct bcmsdh_recv_buf() calls
  staging: brcm80211: remove wireless extensions support from brcmfmac
  staging: brcm80211: remove dhd_set_timer function prototype
  staging: brcm80211: remove unused globals from dhd_common.c
  staging: brcm80211: remove extern function prototypes from c files
  staging: brcm80211: rename functions and variables in dhd_common.c
  staging: brcm80211: rename ioctl command codes in dhd.h
  staging: brcm80211: remove unused definitions from dhd.h
  staging: brcm80211: replace macro BCM_MSG_IFNAME_MAX with IFNAMSIZ
  staging: brcm80211: rename event handling definition
  staging: brcm80211: rename module parameters
  staging: brcm80211: remove unnecessary abstraction for scheduler
  staging: brcm80211: rename fullmac functions
  staging: brcm80211: remove unused prototypes from dhd.h
  staging: brcm80211: rename fullmac protocol related functions
  staging: brcm80211: get rid of PKT[TO/FROM]NATIVE macros
  staging: brcm80211: rename dhd_prot and get rid of dhd_prot_t typedef
  staging: brcm80211: remove conditional SIMPLE_ISCAN code
  staging: brcm80211: rename netdevice related functions in fullmac
  staging: brcm80211: rename static functions in dhd_linux.c
  staging: brcm80211: rename more brcmfmac module parameters
  staging: brcm80211: further renaming in fullmac sources
  staging: brcm80211: remove ARP_OFFLOAD_SUPPORT macro definition
  staging: brcm80211: remove PKT_FILTER_SUPPORT macro definition
  staging: brcm80211: remove BCMLXSDMMC macro definition
  staging: brcm80211: always enable code for PLATFORM_BUS functionality
  staging: brcm80211: remove DHD_SCHED macro definition
  staging: brcm80211: remove EMBEDDED_PLATFORM macro definition
  staging: brcm80211: remove MMC_SDIO_ABORT macro definition
  staging: brcm80211: remove TOE macro definition
  staging: brcm80211: define SHOW_EVENTS macro only for debugging
  staging: brcm80211: replace DHD_DEBUG macro with BCMDBG
  staging: brcm80211: remove unnecessary macro defintions
  staging: brcm80211: remove custom gpio support code
  staging: brcm80211: remove conditional code fragments from brcmfmac
  staging: brcm80211: rename EPI_VERSION_STR macro
  staging: brcm80211: use linux native ethertype iso ETH_P_BRCM
  staging: brcm80211: rename function variables
  staging: brcm80211: remove unused definitions from dhd.h
  staging: brcm80211: rename structure definitions in dhd.h
  staging: brcm80211: rename macro definitions in dhd.h
  staging: brcm80211: remove unused macro definitions from dhd.h
  staging: brcm80211: structure renaming in dhd.h
  staging: brcm80211: rename structure definitions in dhd_linux.c
  staging: brcm80211: rename struct dhd_pub to struct brcmf_pub
  staging: brcm80211: rename function variables
  staging: brcm80211: remove unused macros from dhd_dbg.h
  staging: brcm80211: rename dhd_bus structure and functions
  staging: brcm80211: rename static functions in wl_cfg80211.c
  staging: brcm80211: rename structures and variables in wl_cfg80211.c
  staging: brcm80211: rename pointer conversion macros in wl_cfg80211.h
  staging: brcm80211: rename external function in wl_cfg80211.c

Franky Lin (11):
  staging: brcm80211: remove unused sdtxlock from fullmac
  staging: brcm80211: remove empty sdrxqlock from fullmac
  staging: brcm80211: move sdtxqlock codes to dhd_sdio.c
  staging: brcm80211: remove unused files from fullmac
  staging: brcm80211: move sdio related suspend/resume code to bus
    interface layer
  staging: brcm80211: move waitqueue code to dhd_sdio.c
  staging: brcm80211: move fullmac watchdog timer code to dhd_sdio.c
  staging: brcm80211: move debug console related code to dhd_sdio.c
  staging: brcm80211: move dpc code to dhd_sdio.c
  staging: brcm80211: move sdio resource lock to dhd_sdio.c
  staging: brcm80211: clean up firmware download code in fullmac

Henry Ptasinski (9):
  staging: brcm80211: removed unneeded 'if' statement
  staging: brcm80211: delete empty brcmfmac/README file
  staging: brcm80211: run scripts/cleanfile to remove whitespace errors
  staging: brcm80211: cleanup whitespace errors
  staging: brcm80211: add missing KERN_ facility level to printk()
  staging: brcm80211: flatten wlc_phy_shared_detach()
  staging: brcm80211: remove unnecessary null check
  staging: brcm80211: reorg brcms_c_validboardtype for clarity
  staging: brcm80211: updated TODO file

Roland Vossen (31):
  staging: brcm80211: parsed ADDBA response ack window parameter
  staging: brcm80211: taking max AMPDU length advertized by peer into
    account
  staging: brcm80211: corrected tx status feedback for non AMPDU
    packets
  staging: brcm80211: Changed comments
  staging: brcm80211: replaced prefix of SDIO related functions
  staging: brcm80211: removed BDC defines
  staging: brcm80211: replaced typedef sdioh_info_t by struct
    sdioh_info
  staging: brcm80211: replaced typedef bcmsdh_info_t by struct
    brcmf_sdio
  staging: brcm80211: replaced typedef by struct for several sdio types
  staging: brcm80211: replaced typedef SDIOH_API_RC by int
  staging: brcm80211: replaced more sdio related typedefs by structs
  staging: brmc80211: cleaned up sdio related error codes
  staging: brcm80211: removed global function declarations from .c
    files
  staging: brcm80211: removed last occurrences of bcmsdh/BCMSDH
  staging: brcm80211: sdh related code cleanup
  staging: brcm80211: removed brcmf_sdioh_interrupt_pending()
  staging: brcm80211: removed brcmf_sdioh_reset()
  staging: brcm80211: removed brcmf_sdioh_start() and
    brcmf_sdioh_stop()
  staging: brcm80211: removed file sdiovar.h
  staging: brcm80211: further cleaned fullmac header files
  staging: brcm80211: removed last global function declaration in .c
    file
  staging: brcm80211: removed last typedefs from fullmac
  staging: brcm80211: removed unused code and definitions from fullmac
  staging: brcm80211: fullmac register access macro's take u32 instead
    of pointers
  staging: brcm80211: replaced macro R_SDREG by function r_sdreg()
  staging: brcm80211: replaced macro W_SDREG by function w_sdreg()
  staging: brcm80211: got rid of redundant member 'regs' of struct
    dhd_bus
  staging: brcm80211: removed last amd64 compiler warnings
  staging: brcm80211: W_REG macro cleanup in fullmac SDIO
  staging: brcm80211: removed unused definitions from dhd_sdio.c
  staging: brcm80211: fix for reported log spam problem

Sukesh Srikakula (1):
  staging:brcm80211:brcmfmac: CONNECTING status bit is set at
    appropriate location

 drivers/staging/brcm80211/Makefile                 |    2 +-
 drivers/staging/brcm80211/TODO                     |   12 +-
 drivers/staging/brcm80211/brcmfmac/Makefile        |   23 +-
 drivers/staging/brcm80211/brcmfmac/README          |    2 -
 drivers/staging/brcm80211/brcmfmac/aiutils.c       |    1 -
 drivers/staging/brcm80211/brcmfmac/bcmchip.h       |    3 +
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h      |  181 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |  489 ++--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |  273 +--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |  441 +--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h  |  132 -
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |  130 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h           | 1057 +++----
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h       |   61 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |  225 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    | 1237 ++-----
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |  158 -
 drivers/staging/brcm80211/brcmfmac/dhd_dbg.h       |   66 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     | 2048 +++--------
 .../staging/brcm80211/brcmfmac/dhd_linux_sched.c   |   25 -
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h     |   48 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      | 2821 ++++++++-------
 drivers/staging/brcm80211/brcmfmac/dngl_stats.h    |    4 +-
 drivers/staging/brcm80211/brcmfmac/pcicfg.h        |   50 -
 drivers/staging/brcm80211/brcmfmac/sbsdio.h        |   98 +-
 drivers/staging/brcm80211/brcmfmac/sdio_host.h     |  165 +-
 drivers/staging/brcm80211/brcmfmac/sdiovar.h       |   38 -
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   | 2374 ++++++-------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |  193 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         | 3711 --------------------
 drivers/staging/brcm80211/brcmfmac/wl_iw.h         |  138 -
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |   66 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |    4 -
 drivers/staging/brcm80211/brcmsmac/ampdu.c         |   78 +-
 drivers/staging/brcm80211/brcmsmac/bmac.c          |   44 +-
 drivers/staging/brcm80211/brcmsmac/d11.h           |   30 +-
 drivers/staging/brcm80211/brcmsmac/dma.c           |    2 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c   |   24 +-
 drivers/staging/brcm80211/brcmsmac/main.c          |   90 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |   49 +-
 drivers/staging/brcm80211/brcmsmac/otp.c           |   19 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |   59 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h   |    7 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |   14 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |   28 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     |  167 +-
 drivers/staging/brcm80211/brcmsmac/phy/phyreg_n.h  |   14 +-
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    |   18 +-
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c  |   28 +-
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h  |   10 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.h      |    4 +-
 drivers/staging/brcm80211/brcmsmac/pmu.c           | 1925 +----------
 drivers/staging/brcm80211/brcmsmac/pmu.h           |    3 -
 drivers/staging/brcm80211/brcmsmac/pub.h           |    2 +
 drivers/staging/brcm80211/brcmsmac/rate.h          |    6 +-
 drivers/staging/brcm80211/brcmsmac/scb.h           |    7 +-
 drivers/staging/brcm80211/brcmsmac/srom.c          |  160 +-
 drivers/staging/brcm80211/brcmsmac/types.h         |   32 +-
 drivers/staging/brcm80211/brcmutil/utils.c         |    4 +-
 drivers/staging/brcm80211/brcmutil/wifi.c          |    1 -
 drivers/staging/brcm80211/include/brcmu_utils.h    |    6 +-
 drivers/staging/brcm80211/include/soc.h            |    2 +-
 62 files changed, 5110 insertions(+), 13999 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/README
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/aiutils.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/dhd_linux_sched.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/pcicfg.h
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/sdiovar.h
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/wl_iw.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/wl_iw.h


