Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:36675 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751502AbeD0Fob (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 01:44:31 -0400
From: Pkshih <pkshih@realtek.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v3 00/19] rtlwifi: halmac: Add new module halmac
Date: Fri, 27 Apr 2018 05:44:16 +0000
Message-ID: <5B2DA6FDDF928F4E855344EE0A5C39D13BEBF231@RTITMBSV07.realtek.com.tw> (sfid-20180427_074435_814113_D072EB08)
References: <20180425020820.6141-1-pkshih@realtek.com>
 <87lgdbagb2.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87lgdbagb2.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Wednesday, April 25, 2018 3:36 PM
> To: Pkshih
> Cc: Larry.Finger@lwfinger.net; linux-wireless@vger.kernel.org
> Subject: Re: [PATCH v3 00/19] rtlwifi: halmac: Add new module halmac
> 
> <pkshih@realtek.com> writes:
> 
> > From: Ping-Ke Shih <pkshih@realtek.com>
> >
> > v3: patch 06/17 in v2 is too big, so mail server may block the mail.
> >     In this patchset, I decompose the patch into three patches 06/19-08/19,
> >     so in patchset view v2 and v3 are identical.
> 
> I can confirm, all patches made it to patchwork now.
> 
> > v2: remove indirection to get halmac ops
> >     Only patches 1/17 and 11/17 are changed.
> >
> > Patches 1/19-3/19 are added structure to support this module.
> > Patches 4/19-18/19 add new files.
> > Patch 19/19 add this module to Makefile and Kconfig.
> >
> > Ping-Ke Shih (19):
> >   rtlwifi: add halmac structure to wifi.h
> >   rtlwifi: add debug ID COMP_HALMAC
> >   rtlwifi: add dmdef.h to share with driver and other modules
> >   rtlwifi: halmac: add main definition used by halmac
> >   rtlwifi: halmac: describe number and size of chip functions
> >   rtlwifi: halmac: add register definitions
> >   rtlwifi: halmac: add bit field definitions
> >   rtlwifi: halmac: add bit field definitions of rtl8822b
> >   rtlwifi: halmac: add definition of TX/RX descriptor
> >   rtlwifi: halmac: add GPIO pin/pinmux definitions
> >   rtlwifi: halmac: add power sequence to turn on/off wifi card
> >   rtlwifi: halmac: access efuse through halmac helper functions
> >   rtlwifi: halmac: add files to implement halmac ops
> >   rtlwifi: halmac: add halmac init/deinit functions
> >   rtlwifi: halmac: add firmware related functions and definitions
> >   rtlwifi: halmac: add bus interface commands
> >   rtlwifi: halmac: add to control WiFi mac functions and registers
> >   rtlwifi: halmac: add to support BB and RF functions
> >   rtlwifi: add halmac to Makefile and Kconfig
> 
> You are adding a new component to rtlwifi but there's no introduction in
> the cover letter. Why is this needed? For what hardware is it for? What
> new features does it bring?
> 
> >  77 files changed, 64201 insertions(+)
> 
> This is a huge patchset, I'm not even sure if I want to start reviewing
> this. Especially when I have no clue about the big picture (which should
> be described in the cover letter).
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#too_many_patches
> 
I know the number of patches in a patchset should be within 10-12, but I
think that all files are new and full source can give you whole picture
if you want to know code flow between them.

> And I even read all 19 commit logs and there was no mention of why this
> is needed either. I cannot just blindly apply patches without knowing
> what they do.
> 

This new module halmac is an abstract layer for Realtek WiFi MAC to provide
common interfaces to access WiFi MAC and register set. If driver (I use 'driver'
in this mail indicates part of rtlwifi excluded from this module.) uses the API,
it's not necessary to control related register directly. If API isn't implemented,
driver can use the registers defined by halmac to manipulate MAC function.

The registers reside in driver causes error frequently, because MAC register
is maintained by Realtek's MAC team so they create this module to avoid mistakes.
Another benefit is to make it possible to become a thin driver, because many
common functions are provided, so duplicate code will be reduced.

Currently, this module is aim to rtl8822be, and it will extend to support
more chips so hierarchical directory is adopted. It looks like
   rtlwifi/halmac/halmac_88xx
   rtlwifi/halmac/halmac_88xx/halmac_8822b
   rtlwifi/halmac/halmac_88xx/halmac_8821c (future chip)
The directory halmac_88xx puts common functions of rtl8822b and rtl8821c, and
halmac_88xx/halmac_8822b puts rtl8822b specific functions.
To access API abstractly, it provides hook pointers to specific chip during
initialization.


In order to illustrate the functions, I list *.c files and short description:

   halmac/rtl_halmac.c
     We implement a facade-like (facade is a term in design pattern) by
     halmac_ops in this file, so we can check halmac_ops to know halmac functions.
     The functions, for examples, are init/deinit, power on/off, read efuse,
     c2h handler, iqk assistant function etc. Each function may call one or more 
     halmac API to achieve.
                      
   halmac/halmac_api.c
   halmac/halmac_88xx/halmac_init_88xx.c
   halmac/halmac_88xx/halmac_8822b/halmac_init_8822b.c
     The init/deinit and mount hook pointers are existing in these files.

   halmac/halmac_88xx/halmac_usb_88xx.c
   halmac/halmac_88xx/halmac_sdio_88xx.c
   halmac/halmac_88xx/halmac_pcie_88xx.c
   halmac/halmac_88xx/halmac_8822b/halmac_usb_8822b.c
   halmac/halmac_88xx/halmac_8822b/halmac_sdio_8822b.c
   halmac/halmac_88xx/halmac_8822b/halmac_pcie_8822b.c
   halmac/halmac_88xx/halmac_8822b/halmac_phy_8822b.c
     Each chip has three types of bus interfaces, and each interface
     uses different IO functions, capabilities and phy parameters.
     In order to reuse code, this module will hook pointers to bus operations
     combined with halmac API.

   halmac/halmac_88xx/halmac_mimo_88xx.c
     Control MIMO register in MAC layer to assist with BB/RF.

   halmac/halmac_88xx/halmac_bb_rf_88xx.c
     Some BB/RF functions are implemented in firmware, so we trigger them through 
     H2C commands.

   halmac/halmac_88xx/halmac_cfg_wmac_88xx.c
   halmac/halmac_88xx/halmac_8822b/halmac_cfg_wmac_8822b.c
     Control WiFi MAC registers. For examples, channel, channel bandwidth, bssid,
     TSF, beacon function, ...

   halmac/halmac_88xx/halmac_gpio_88xx.c
   halmac/halmac_88xx/halmac_8822b/halmac_gpio_8822b.c
     Use GPIO to control LED that indicates packet traffic.
     WoWlan outband notification.

   halmac/halmac_88xx/halmac_fw_88xx.c
     Download firmware and send basic information provided by driver to firmware.

   halmac/halmac_88xx/halmac_flash_88xx.c
     Read/download/erase flash functions.

   halmac/halmac_88xx/halmac_efuse_88xx.c
     Manipulate efuse functions such as read, write, dump etc.

   halmac/halmac_88xx/halmac_8822b/halmac_pwr_seq_8822b.c
     Power on/off sequence tables.

   halmac/halmac_88xx/halmac_common_88xx.c
   halmac/halmac_88xx/halmac_8822b/halmac_common_8822b.c
     Other functions.


There are three main struct are defiend within halmac:
   struct halmac_adapter *halmac;
     This is halmac's context that stores halmac's state containing mutex, parameter,
     following two struct, etc.

  struct halmac_api *api;
     According to specific chip, hook function pointers to this struct.

  struct halmac_platform_api *pf_api
     Driver (platform) assistant functions needed by halmac.

There are two main struct are defined by wifi.h (driver):
  struct rtl_halmac *rtl_halmac;
     There are three member pointers point to halmac's context (struct halmac_adapter *),
     halmac ops (struct rtl_halmac_ops *), and a completion struct for halmac events.

  struct rtl_halmac_ops *halmac_ops;
     Driver access halmac through this ops set, and the ops functions implemented
     in halmac/rtl_halmac.c.


The relation between hook pointers and ops is shown in below figure:

  driver              halmac/rtl_halmac.c                   halmac functions
  ======              ===================                   ================
    |                         |                                    |
    | struct rtl_halmac_ops * |                                    |
    | ----------------------> | struct halmac_api *api             |
    |                         | (one or more)                      |
    |                         | ---------------------------------> |
    |                         |                                    |
    |                         |                                    |
    |                         | struct halmac_platform_api *pf_api |
    |                         | <--------------------------------- |
    | direct function call, or|                                    |
    | prior defined ops       |                                    |
    | <---------------------- |                                    |
    |                         |                                    |

An usage example related to above struct and figure:

   rtlpriv->halmac.ops->halmac_init_hal(rtlpriv);
   (struct rtl_halmac_ops *halmac_ops)
   (called by 8822be; not submitted yet)
                  |
   rtl_halmac_init_hal(rtlpriv, ...)
   (ops implemented in halmac/rtl_halmac.c)
                  |
               ......
                  |
   api->halmac_download_firmware(halmac, ...)
   (struct halmac_api *api)
   (halmac/rtl_halmac.c)
                  |
   download_firmware_88xx(halmac, ...)
   (hook function implemented in halmac/halmac_88xx/halmac_fw_88xx.c)
                  |
               ......
                  |
   PLTFM_SEND_RSVD_PAGE(...)
                  |
   adapter->pltfm_api->SEND_RSVD_PAGE(adapter->drv_adapter, ...)
   (struct halmac_platform_api *pf_api)
   (a macro defined in halmac/halmac_type.h)
                  |
   _halmac_write_data_rsvd_page(rtlpriv, ...)
   (hook function implemented in halmac/rtl_halmac.c)


Regards
PK
