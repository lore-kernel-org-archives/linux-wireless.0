Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:2704 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab0LPGER (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 01:04:17 -0500
Subject: Re: [PATCH] staging: ath6kl: Fixing device NULL pointer dereference
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vipin Mehta <Vipin.Mehta@Atheros.com>
In-Reply-To: <20101216011416.GA388@vmehta-desktop>
References: <1292375879-32085-1-git-send-email-vmehta@atheros.com>
	 <AANLkTin_fw6aRc5Rs1_BTcapTE9kgPHy7_Gex9wRtkWy@mail.gmail.com>
	 <20101216011416.GA388@vmehta-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 22:04:15 -0800
Message-ID: <1292479455.5182.38.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-15 at 17:15 -0800, Vipin Mehta wrote:
> On Tue, Dec 14, 2010 at 08:15:24PM -0800, Luis R. Rodriguez wrote:
> > > diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> > > +    A_MEMZERO(&osDevInfo, sizeof(osDevInfo));
> > > +    if ( A_FAILED( HIFConfigureDevice(hif_handle, HIF_DEVICE_GET_OS_DEVICE,
> > while you are adding new code, why not use the direct Linux calls?

> I'll change the use of A_MEMZERO(), A_FAILED() macros and A_STATUS
> data type given that we have an incoming patch that cleans the rest
> of the code for similar usage. Changing the use of HIFConfigureDevice()
> will be more useful if we do it across the driver since it will require
> significant changes in the data structures defined in the HIF layer.
> It qualifies for an entirely separate patch and can be done later in a
> systematic way.

I hope you hold off for a bit making changes to ath6kl.

I just finished more of those cleanup conversions.
Here's what I've done so far.
There's a lot more of this still possible.
It's unfortunately large.

Sending separately to Vipin and Luis.

Reformat to remove typedefs, A_<foo> macros, etc.
Improve readability by using a more kernel conformant style.

Joe Perches (35):
  staging: ath6kl: Convert enum A_STATUS to int
  staging: ath6kl: Remove A_SUCCESS macro
  staging: ath6kl: Remove A_FAILED macro
  staging: ath6kl: Remove A_BOOL and TRUE/FALSE
  staging: ath6kl: Convert A_CHAR to char
  staging: ath6kl: Convert A_UINT8 to u8
  staging: ath6kl: Convert A_UINT16 to u16
  staging: ath6kl: Convert A_UINT32 to u32
  staging: ath6kl: Convert A_UINT64 to u64
  staging: ath6kl: Convert A_INT8 to s8
  staging: ath6kl: Convert A_INT16 to s16
  staging: ath6kl: Convert A_INT32 to s32
  staging: ath6kl: Convert (status != A_OK) to (status)
  staging: ath6kl: Remove #define A_OK
  staging: ath6kl: Convert leading spaces to tab indentation
  staging: ath6kl: Remove direct comparisons to true/false
  staging: ath6kl: Cuddle while open braces
  staging: ath6kl: Use do {} while (0) around #defines
  staging: ath6kl: Remove most uses of braces around single statements
  staging: ath6kl: Remove braces around single statement if { foo } else uses
  staging: ath6kl: Remove blank lines
  staging: ath6kl: Hoist assigns from ifs
  staging: ath6kl: Cuddle open brace to if
  staging: ath6kl: Cuddle else open brace
  staging: ath6kl: Add space after commas
  staging: ath6kl: Remove spaces before quoted newlines
  staging: ath6kl: Convert A_UCHAR to u8
  staging: ath6kl: Convert A_MEMCPY to memcpy
  staging: ath6kl: Convert A_MEMCMP to memcmp
  staging: ath6kl: Convert A_MALLOC to kmalloc/kzalloc
  staging: ath6kl: Convert A_MALLOC_NOWAIT to kmalloc/kzalloc(,GFP_ATOMIC)
  staging: ath6kl: Convert A_FREE to kfree
  staging: ath6kl: Convert A_MEMZERO to memset
  staging: ath6kl: Remove trailing whitespace
  staging: ath6kl: Convert AR_DEBUG_PRINTF to ath6k_dbg

 drivers/staging/ath6kl/bmi/include/bmi_internal.h  |   19 +-
 drivers/staging/ath6kl/bmi/src/bmi.c               | 1738 ++--
 .../staging/ath6kl/hif/common/hif_sdio_common.h    |   72 +-
 .../hif/sdio/linux_sdio/include/hif_internal.h     |   87 +-
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   | 2019 +++--
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |  682 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          | 2373 +++---
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |  496 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   | 1317 ++--
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    | 1293 ++--
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        | 2286 +++---
 drivers/staging/ath6kl/htc2/htc.c                  |  875 +-
 drivers/staging/ath6kl/htc2/htc_debug.h            |    3 +-
 drivers/staging/ath6kl/htc2/htc_internal.h         |  206 +-
 drivers/staging/ath6kl/htc2/htc_recv.c             | 2827 +++---
 drivers/staging/ath6kl/htc2/htc_send.c             | 1821 ++--
 drivers/staging/ath6kl/htc2/htc_services.c         |  772 +-
 drivers/staging/ath6kl/include/a_config.h          |    2 +-
 drivers/staging/ath6kl/include/a_debug.h           |   62 +-
 drivers/staging/ath6kl/include/a_drv.h             |    2 +-
 drivers/staging/ath6kl/include/a_drv_api.h         |  108 +-
 drivers/staging/ath6kl/include/a_osapi.h           |    6 +-
 drivers/staging/ath6kl/include/a_types.h           |    2 +-
 drivers/staging/ath6kl/include/aggr_recv_api.h     |   46 +-
 drivers/staging/ath6kl/include/ar3kconfig.h        |   35 +-
 drivers/staging/ath6kl/include/ar6000_api.h        |    3 +-
 drivers/staging/ath6kl/include/ar6000_diag.h       |   29 +-
 drivers/staging/ath6kl/include/ar6kap_common.h     |   14 +-
 drivers/staging/ath6kl/include/athbtfilter.h       |  145 +-
 drivers/staging/ath6kl/include/athendpack.h        |    5 +-
 drivers/staging/ath6kl/include/athstartpack.h      |    4 +-
 drivers/staging/ath6kl/include/bmi.h               |  108 +-
 .../ath6kl/include/common/AR6002/AR6002_regdump.h  |   44 +-
 .../ath6kl/include/common/AR6002/AR6K_version.h    |    6 +-
 .../staging/ath6kl/include/common/AR6002/addrs.h   |   10 +-
 .../common/AR6002/hw2.0/hw/analog_intf_reg.h       |    1 -
 .../include/common/AR6002/hw2.0/hw/analog_reg.h    |    1 -
 .../include/common/AR6002/hw2.0/hw/gpio_reg.h      |    1 -
 .../include/common/AR6002/hw2.0/hw/mbox_host_reg.h |    1 -
 .../include/common/AR6002/hw2.0/hw/mbox_reg.h      |    1 -
 .../include/common/AR6002/hw2.0/hw/rtc_reg.h       |    1 -
 .../ath6kl/include/common/AR6002/hw2.0/hw/si_reg.h |    1 -
 .../include/common/AR6002/hw2.0/hw/uart_reg.h      |    1 -
 .../include/common/AR6002/hw2.0/hw/vmc_reg.h       |    1 -
 .../common/AR6002/hw4.0/hw/analog_intf_ares_reg.h  |    5 +-
 .../AR6002/hw4.0/hw/analog_intf_athr_wlan_reg.h    |    5 +-
 .../common/AR6002/hw4.0/hw/analog_intf_reg.h       |    9 +-
 .../common/AR6002/hw4.0/hw/apb_athr_wlan_map.h     |    3 +-
 .../include/common/AR6002/hw4.0/hw/apb_map.h       |    8 +-
 .../include/common/AR6002/hw4.0/hw/bb_lc_reg.h     |    5 +-
 .../include/common/AR6002/hw4.0/hw/efuse_reg.h     |    4 +-
 .../common/AR6002/hw4.0/hw/gpio_athr_wlan_reg.h    |    4 +-
 .../include/common/AR6002/hw4.0/hw/gpio_reg.h      |    8 +-
 .../include/common/AR6002/hw4.0/hw/mac_dma_reg.h   |   38 +-
 .../include/common/AR6002/hw4.0/hw/mac_pcu_reg.h   |    4 +-
 .../include/common/AR6002/hw4.0/hw/mbox_host_reg.h |    9 +-
 .../include/common/AR6002/hw4.0/hw/mbox_reg.h      |    8 +-
 .../common/AR6002/hw4.0/hw/mbox_wlan_host_reg.h    |    4 +-
 .../include/common/AR6002/hw4.0/hw/mbox_wlan_reg.h |    4 +-
 .../include/common/AR6002/hw4.0/hw/rdma_reg.h      |    4 +-
 .../include/common/AR6002/hw4.0/hw/rtc_reg.h       |    8 +-
 .../include/common/AR6002/hw4.0/hw/rtc_wlan_reg.h  |    4 +-
 .../ath6kl/include/common/AR6002/hw4.0/hw/si_reg.h |    4 +-
 .../include/common/AR6002/hw4.0/hw/uart_reg.h      |    4 +-
 .../include/common/AR6002/hw4.0/hw/umbox_reg.h     |    9 +-
 .../common/AR6002/hw4.0/hw/umbox_wlan_reg.h        |    4 +-
 .../include/common/AR6002/hw4.0/hw/vmc_reg.h       |    8 +-
 .../include/common/AR6002/hw4.0/hw/vmc_wlan_reg.h  |    4 +-
 drivers/staging/ath6kl/include/common/a_hci.h      |  483 +-
 drivers/staging/ath6kl/include/common/athdefs.h    |   87 +-
 drivers/staging/ath6kl/include/common/bmi_msg.h    |  273 +-
 drivers/staging/ath6kl/include/common/btcoexGpio.h |   15 +-
 drivers/staging/ath6kl/include/common/cnxmgmt.h    |   14 +-
 drivers/staging/ath6kl/include/common/dbglog.h     |   48 +-
 drivers/staging/ath6kl/include/common/dbglog_id.h  |   55 +-
 drivers/staging/ath6kl/include/common/discovery.h  |   60 +-
 .../staging/ath6kl/include/common/dset_internal.h  |   23 +-
 drivers/staging/ath6kl/include/common/dsetid.h     |   25 +-
 .../staging/ath6kl/include/common/epping_test.h    |   99 +-
 drivers/staging/ath6kl/include/common/gmboxif.h    |   27 +-
 drivers/staging/ath6kl/include/common/htc.h        |  204 +-
 .../staging/ath6kl/include/common/htc_services.h   |   30 +-
 drivers/staging/ath6kl/include/common/ini_dset.h   |   68 +-
 drivers/staging/ath6kl/include/common/pkt_log.h    |   16 +-
 drivers/staging/ath6kl/include/common/regDb.h      |    2 +-
 drivers/staging/ath6kl/include/common/regdump.h    |   14 +-
 .../include/common/regulatory/reg_dbschema.h       |  152 +-
 .../include/common/regulatory/reg_dbvalues.h       |  735 +-
 drivers/staging/ath6kl/include/common/roaming.h    |   18 +-
 drivers/staging/ath6kl/include/common/targaddrs.h  |  214 +-
 drivers/staging/ath6kl/include/common/testcmd.h    |  198 +-
 drivers/staging/ath6kl/include/common/tlpm.h       |    2 +-
 drivers/staging/ath6kl/include/common/wlan_defs.h  |   60 +-
 drivers/staging/ath6kl/include/common/wlan_dset.h  |    8 +-
 drivers/staging/ath6kl/include/common/wmi.h        | 2740 +++---
 drivers/staging/ath6kl/include/common/wmi_thin.h   |  310 +-
 drivers/staging/ath6kl/include/common/wmix.h       |  145 +-
 drivers/staging/ath6kl/include/common_drv.h        |   58 +-
 drivers/staging/ath6kl/include/dbglog_api.h        |   10 +-
 drivers/staging/ath6kl/include/dl_list.h           |  142 +-
 drivers/staging/ath6kl/include/dset_api.h          |   33 +-
 drivers/staging/ath6kl/include/gpio_api.h          |   24 +-
 drivers/staging/ath6kl/include/hci_transport_api.h |  177 +-
 drivers/staging/ath6kl/include/hif.h               |  287 +-
 drivers/staging/ath6kl/include/host_version.h      |    4 +-
 drivers/staging/ath6kl/include/htc_api.h           |  449 +-
 drivers/staging/ath6kl/include/htc_packet.h        |  278 +-
 drivers/staging/ath6kl/include/target_reg_table.h  |  256 +-
 drivers/staging/ath6kl/include/wlan_api.h          |  103 +-
 drivers/staging/ath6kl/include/wmi_api.h           |  547 +-
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |  971 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |  805 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h   |   15 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   | 1504 ++--
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h   |   52 +-
 drivers/staging/ath6kl/miscdrv/common_drv.c        | 1479 ++--
 drivers/staging/ath6kl/miscdrv/credit_dist.c       |  599 +-
 drivers/staging/ath6kl/miscdrv/miscdrv.h           |   12 +-
 drivers/staging/ath6kl/os/linux/ar6000_android.c   |  559 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       | 9670 ++++++++++----------
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        | 1077 ++--
 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c    |  755 +-
 drivers/staging/ath6kl/os/linux/ar6k_pal.c         |  180 +-
 drivers/staging/ath6kl/os/linux/cfg80211.c         | 2389 +++---
 drivers/staging/ath6kl/os/linux/eeprom.c           |  640 +-
 .../staging/ath6kl/os/linux/export_hci_transport.c |   96 +-
 drivers/staging/ath6kl/os/linux/hci_bridge.c       | 1597 ++--
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |  644 +-
 drivers/staging/ath6kl/os/linux/include/ar6k_pal.h |    8 +-
 .../ath6kl/os/linux/include/ar6xapi_linux.h        |  172 +-
 .../staging/ath6kl/os/linux/include/athdrv_linux.h |  299 +-
 .../ath6kl/os/linux/include/athtypes_linux.h       |    4 +-
 drivers/staging/ath6kl/os/linux/include/cfg80211.h |   28 +-
 .../staging/ath6kl/os/linux/include/config_linux.h |    2 +-
 .../staging/ath6kl/os/linux/include/debug_linux.h  |   53 +-
 .../ath6kl/os/linux/include/export_hci_transport.h |   50 +-
 .../ath6kl/os/linux/include/ieee80211_ioctl.h      |  110 +-
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |  243 +-
 .../staging/ath6kl/os/linux/include/wlan_config.h  |   20 +-
 .../ath6kl/os/linux/include/wmi_filter_linux.h     |   12 +-
 drivers/staging/ath6kl/os/linux/ioctl.c            | 7781 ++++++++---------
 drivers/staging/ath6kl/os/linux/netbuf.c           |  140 +-
 drivers/staging/ath6kl/os/linux/wireless_ext.c     | 4302 +++++-----
 drivers/staging/ath6kl/reorder/aggr_rx_internal.h  |   82 +-
 drivers/staging/ath6kl/reorder/rcv_aggr.c          | 1012 +--
 drivers/staging/ath6kl/wlan/include/ieee80211.h    |  219 +-
 .../staging/ath6kl/wlan/include/ieee80211_node.h   |   43 +-
 drivers/staging/ath6kl/wlan/src/wlan_node.c        |  833 +-
 drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c |  253 +-
 drivers/staging/ath6kl/wlan/src/wlan_utils.c       |   41 +-
 drivers/staging/ath6kl/wmi/wmi.c                   | 9408 +++++++++----------
 drivers/staging/ath6kl/wmi/wmi_host.h              |   66 +-
 152 files changed, 37473 insertions(+), 38938 deletions(-)



