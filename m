Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751505AbcIJMZh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Sep 2016 08:25:37 -0400
From: Jes.Sorensen@redhat.com
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, Larry.Finger@lwfinger.net,
        linux-wireless@vger.kernel.org,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH - FYI - do not apply] staging: Remove rtl8723au driver
Date: Sat, 10 Sep 2016 08:25:33 -0400
Message-Id: <1473510333-26497-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160910_142548_594067_271BA5BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

I sent Greg the full version of this patch, removing the old rtl8723au
driver. I didn't want to spam the list with a 2M+ patch so this is the
summary version. 

Cheers,
Jes

This driver is superseded by rtl8xxxu and has been marked as scheduled
for deletion since 4.6

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 MAINTAINERS                                        |     7 -
 drivers/staging/Kconfig                            |     2 -
 drivers/staging/Makefile                           |     1 -
 drivers/staging/rtl8723au/Kconfig                  |    33 -
 drivers/staging/rtl8723au/Makefile                 |    53 -
 drivers/staging/rtl8723au/TODO                     |    16 -
 drivers/staging/rtl8723au/core/rtw_ap.c            |  1738 ---
 drivers/staging/rtl8723au/core/rtw_cmd.c           |  1470 ---
 drivers/staging/rtl8723au/core/rtw_efuse.c         |   538 -
 drivers/staging/rtl8723au/core/rtw_ieee80211.c     |   855 --
 drivers/staging/rtl8723au/core/rtw_mlme.c          |  2314 ----
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c      |  6187 ----------
 drivers/staging/rtl8723au/core/rtw_pwrctrl.c       |   607 -
 drivers/staging/rtl8723au/core/rtw_recv.c          |  2204 ----
 drivers/staging/rtl8723au/core/rtw_security.c      |  1630 ---
 drivers/staging/rtl8723au/core/rtw_sreset.c        |   214 -
 drivers/staging/rtl8723au/core/rtw_sta_mgt.c       |   439 -
 drivers/staging/rtl8723au/core/rtw_wlan_util.c     |  1537 ---
 drivers/staging/rtl8723au/core/rtw_xmit.c          |  2337 ----
 drivers/staging/rtl8723au/hal/Hal8723PwrSeq.c      |    80 -
 drivers/staging/rtl8723au/hal/Hal8723UHWImg_CE.c   |   136 -
 .../staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c    |  1097 --
 drivers/staging/rtl8723au/hal/HalHWImg8723A_BB.c   |   565 -
 drivers/staging/rtl8723au/hal/HalHWImg8723A_MAC.c  |   187 -
 drivers/staging/rtl8723au/hal/HalHWImg8723A_RF.c   |   259 -
 drivers/staging/rtl8723au/hal/HalPwrSeqCmd.c       |   156 -
 drivers/staging/rtl8723au/hal/hal_com.c            |   853 --
 drivers/staging/rtl8723au/hal/hal_intf.c           |    42 -
 drivers/staging/rtl8723au/hal/odm.c                |  1732 ---
 drivers/staging/rtl8723au/hal/odm_HWConfig.c       |   396 -
 drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c |    88 -
 drivers/staging/rtl8723au/hal/odm_debug.c          |    39 -
 drivers/staging/rtl8723au/hal/odm_interface.c      |    49 -
 .../staging/rtl8723au/hal/rtl8723a_bt-coexist.c    | 11265 -------------------
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c       |   755 --
 drivers/staging/rtl8723au/hal/rtl8723a_dm.c        |   194 -
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c  |  2076 ----
 drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c    |   961 --
 drivers/staging/rtl8723au/hal/rtl8723a_rf6052.c    |   503 -
 drivers/staging/rtl8723au/hal/rtl8723a_rxdesc.c    |    69 -
 drivers/staging/rtl8723au/hal/rtl8723a_sreset.c    |    55 -
 drivers/staging/rtl8723au/hal/rtl8723au_recv.c     |   267 -
 drivers/staging/rtl8723au/hal/rtl8723au_xmit.c     |   520 -
 drivers/staging/rtl8723au/hal/usb_halinit.c        |  1269 ---
 drivers/staging/rtl8723au/hal/usb_ops_linux.c      |   690 --
 drivers/staging/rtl8723au/include/Hal8723APhyCfg.h |   162 -
 drivers/staging/rtl8723au/include/Hal8723APhyReg.h |  1078 --
 drivers/staging/rtl8723au/include/Hal8723PwrSeq.h  |   126 -
 .../staging/rtl8723au/include/Hal8723UHWImg_CE.h   |    29 -
 .../staging/rtl8723au/include/HalDMOutSrc8723A.h   |    64 -
 .../staging/rtl8723au/include/HalHWImg8723A_BB.h   |    38 -
 .../staging/rtl8723au/include/HalHWImg8723A_FW.h   |    28 -
 .../staging/rtl8723au/include/HalHWImg8723A_MAC.h  |    26 -
 .../staging/rtl8723au/include/HalHWImg8723A_RF.h   |    25 -
 drivers/staging/rtl8723au/include/HalPwrSeqCmd.h   |   130 -
 drivers/staging/rtl8723au/include/HalVerDef.h      |   114 -
 drivers/staging/rtl8723au/include/drv_types.h      |   274 -
 drivers/staging/rtl8723au/include/hal_com.h        |   182 -
 drivers/staging/rtl8723au/include/hal_intf.h       |   115 -
 drivers/staging/rtl8723au/include/ieee80211.h      |   341 -
 drivers/staging/rtl8723au/include/ioctl_cfg80211.h |    66 -
 drivers/staging/rtl8723au/include/mlme_osdep.h     |    24 -
 drivers/staging/rtl8723au/include/odm.h            |   860 --
 drivers/staging/rtl8723au/include/odm_HWConfig.h   |   153 -
 .../staging/rtl8723au/include/odm_RegConfig8723A.h |    27 -
 .../staging/rtl8723au/include/odm_RegDefine11N.h   |   165 -
 drivers/staging/rtl8723au/include/odm_debug.h      |   117 -
 drivers/staging/rtl8723au/include/odm_interface.h  |    62 -
 drivers/staging/rtl8723au/include/odm_precomp.h    |    49 -
 drivers/staging/rtl8723au/include/odm_reg.h        |   111 -
 drivers/staging/rtl8723au/include/osdep_intf.h     |    45 -
 drivers/staging/rtl8723au/include/osdep_service.h  |    87 -
 drivers/staging/rtl8723au/include/recv_osdep.h     |    36 -
 .../rtl8723au/include/rtl8723a_bt-coexist.h        |  1627 ---
 .../staging/rtl8723au/include/rtl8723a_bt_intf.h   |    69 -
 drivers/staging/rtl8723au/include/rtl8723a_cmd.h   |   158 -
 drivers/staging/rtl8723au/include/rtl8723a_dm.h    |   137 -
 drivers/staging/rtl8723au/include/rtl8723a_hal.h   |   538 -
 drivers/staging/rtl8723au/include/rtl8723a_pg.h    |    98 -
 drivers/staging/rtl8723au/include/rtl8723a_recv.h  |    65 -
 drivers/staging/rtl8723au/include/rtl8723a_rf.h    |    58 -
 drivers/staging/rtl8723au/include/rtl8723a_spec.h  |  2148 ----
 .../staging/rtl8723au/include/rtl8723a_sreset.h    |    24 -
 drivers/staging/rtl8723au/include/rtl8723a_xmit.h  |   225 -
 drivers/staging/rtl8723au/include/rtw_ap.h         |    51 -
 drivers/staging/rtl8723au/include/rtw_cmd.h        |   815 --
 drivers/staging/rtl8723au/include/rtw_debug.h      |   191 -
 drivers/staging/rtl8723au/include/rtw_eeprom.h     |   135 -
 drivers/staging/rtl8723au/include/rtw_efuse.h      |   109 -
 drivers/staging/rtl8723au/include/rtw_event.h      |    74 -
 drivers/staging/rtl8723au/include/rtw_ht.h         |    42 -
 drivers/staging/rtl8723au/include/rtw_io.h         |   235 -
 drivers/staging/rtl8723au/include/rtw_mlme.h       |   340 -
 drivers/staging/rtl8723au/include/rtw_mlme_ext.h   |   683 --
 drivers/staging/rtl8723au/include/rtw_pwrctrl.h    |   242 -
 drivers/staging/rtl8723au/include/rtw_recv.h       |   305 -
 drivers/staging/rtl8723au/include/rtw_rf.h         |   102 -
 drivers/staging/rtl8723au/include/rtw_security.h   |   331 -
 drivers/staging/rtl8723au/include/rtw_sreset.h     |    36 -
 drivers/staging/rtl8723au/include/rtw_version.h    |     1 -
 drivers/staging/rtl8723au/include/rtw_xmit.h       |   380 -
 drivers/staging/rtl8723au/include/sta_info.h       |   373 -
 drivers/staging/rtl8723au/include/usb_ops.h        |    68 -
 drivers/staging/rtl8723au/include/usb_ops_linux.h  |    41 -
 drivers/staging/rtl8723au/include/wifi.h           |    84 -
 drivers/staging/rtl8723au/include/wlan_bssdef.h    |   123 -
 drivers/staging/rtl8723au/include/xmit_osdep.h     |    38 -
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  |  3348 ------
 drivers/staging/rtl8723au/os_dep/mlme_linux.c      |    81 -
 drivers/staging/rtl8723au/os_dep/os_intfs.c        |   852 --
 drivers/staging/rtl8723au/os_dep/recv_linux.c      |   165 -
 drivers/staging/rtl8723au/os_dep/usb_intf.c        |   628 --
 drivers/staging/rtl8723au/os_dep/usb_ops_linux.c   |   233 -
 drivers/staging/rtl8723au/os_dep/xmit_linux.c      |   154 -
 114 files changed, 66426 deletions(-)
 delete mode 100644 drivers/staging/rtl8723au/Kconfig
 delete mode 100644 drivers/staging/rtl8723au/Makefile
 delete mode 100644 drivers/staging/rtl8723au/TODO
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_ap.c
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_cmd.c
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_efuse.c
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_ieee80211.c
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_mlme.c
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_mlme_ext.c
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_pwrctrl.c
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_recv.c
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_security.c
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_sreset.c
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_sta_mgt.c
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_wlan_util.c
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_xmit.c
 delete mode 100644 drivers/staging/rtl8723au/hal/Hal8723PwrSeq.c
 delete mode 100644 drivers/staging/rtl8723au/hal/Hal8723UHWImg_CE.c
 delete mode 100644 drivers/staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c
 delete mode 100644 drivers/staging/rtl8723au/hal/HalHWImg8723A_BB.c
 delete mode 100644 drivers/staging/rtl8723au/hal/HalHWImg8723A_MAC.c
 delete mode 100644 drivers/staging/rtl8723au/hal/HalHWImg8723A_RF.c
 delete mode 100644 drivers/staging/rtl8723au/hal/HalPwrSeqCmd.c
 delete mode 100644 drivers/staging/rtl8723au/hal/hal_com.c
 delete mode 100644 drivers/staging/rtl8723au/hal/hal_intf.c
 delete mode 100644 drivers/staging/rtl8723au/hal/odm.c
 delete mode 100644 drivers/staging/rtl8723au/hal/odm_HWConfig.c
 delete mode 100644 drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
 delete mode 100644 drivers/staging/rtl8723au/hal/odm_debug.c
 delete mode 100644 drivers/staging/rtl8723au/hal/odm_interface.c
 delete mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
 delete mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
 delete mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_dm.c
 delete mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
 delete mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c
 delete mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_rf6052.c
 delete mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_rxdesc.c
 delete mode 100644 drivers/staging/rtl8723au/hal/rtl8723a_sreset.c
 delete mode 100644 drivers/staging/rtl8723au/hal/rtl8723au_recv.c
 delete mode 100644 drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
 delete mode 100644 drivers/staging/rtl8723au/hal/usb_halinit.c
 delete mode 100644 drivers/staging/rtl8723au/hal/usb_ops_linux.c
 delete mode 100644 drivers/staging/rtl8723au/include/Hal8723APhyCfg.h
 delete mode 100644 drivers/staging/rtl8723au/include/Hal8723APhyReg.h
 delete mode 100644 drivers/staging/rtl8723au/include/Hal8723PwrSeq.h
 delete mode 100644 drivers/staging/rtl8723au/include/Hal8723UHWImg_CE.h
 delete mode 100644 drivers/staging/rtl8723au/include/HalDMOutSrc8723A.h
 delete mode 100644 drivers/staging/rtl8723au/include/HalHWImg8723A_BB.h
 delete mode 100644 drivers/staging/rtl8723au/include/HalHWImg8723A_FW.h
 delete mode 100644 drivers/staging/rtl8723au/include/HalHWImg8723A_MAC.h
 delete mode 100644 drivers/staging/rtl8723au/include/HalHWImg8723A_RF.h
 delete mode 100644 drivers/staging/rtl8723au/include/HalPwrSeqCmd.h
 delete mode 100644 drivers/staging/rtl8723au/include/HalVerDef.h
 delete mode 100644 drivers/staging/rtl8723au/include/drv_types.h
 delete mode 100644 drivers/staging/rtl8723au/include/hal_com.h
 delete mode 100644 drivers/staging/rtl8723au/include/hal_intf.h
 delete mode 100644 drivers/staging/rtl8723au/include/ieee80211.h
 delete mode 100644 drivers/staging/rtl8723au/include/ioctl_cfg80211.h
 delete mode 100644 drivers/staging/rtl8723au/include/mlme_osdep.h
 delete mode 100644 drivers/staging/rtl8723au/include/odm.h
 delete mode 100644 drivers/staging/rtl8723au/include/odm_HWConfig.h
 delete mode 100644 drivers/staging/rtl8723au/include/odm_RegConfig8723A.h
 delete mode 100644 drivers/staging/rtl8723au/include/odm_RegDefine11N.h
 delete mode 100644 drivers/staging/rtl8723au/include/odm_debug.h
 delete mode 100644 drivers/staging/rtl8723au/include/odm_interface.h
 delete mode 100644 drivers/staging/rtl8723au/include/odm_precomp.h
 delete mode 100644 drivers/staging/rtl8723au/include/odm_reg.h
 delete mode 100644 drivers/staging/rtl8723au/include/osdep_intf.h
 delete mode 100644 drivers/staging/rtl8723au/include/osdep_service.h
 delete mode 100644 drivers/staging/rtl8723au/include/recv_osdep.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtl8723a_bt-coexist.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtl8723a_bt_intf.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtl8723a_cmd.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtl8723a_dm.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtl8723a_hal.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtl8723a_pg.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtl8723a_recv.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtl8723a_rf.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtl8723a_spec.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtl8723a_sreset.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtl8723a_xmit.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_ap.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_cmd.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_debug.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_eeprom.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_efuse.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_event.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_ht.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_io.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_mlme.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_mlme_ext.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_pwrctrl.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_recv.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_rf.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_security.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_sreset.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_version.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_xmit.h
 delete mode 100644 drivers/staging/rtl8723au/include/sta_info.h
 delete mode 100644 drivers/staging/rtl8723au/include/usb_ops.h
 delete mode 100644 drivers/staging/rtl8723au/include/usb_ops_linux.h
 delete mode 100644 drivers/staging/rtl8723au/include/wifi.h
 delete mode 100644 drivers/staging/rtl8723au/include/wlan_bssdef.h
 delete mode 100644 drivers/staging/rtl8723au/include/xmit_osdep.h
 delete mode 100644 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
 delete mode 100644 drivers/staging/rtl8723au/os_dep/mlme_linux.c
 delete mode 100644 drivers/staging/rtl8723au/os_dep/os_intfs.c
 delete mode 100644 drivers/staging/rtl8723au/os_dep/recv_linux.c
 delete mode 100644 drivers/staging/rtl8723au/os_dep/usb_intf.c
 delete mode 100644 drivers/staging/rtl8723au/os_dep/usb_ops_linux.c
 delete mode 100644 drivers/staging/rtl8723au/os_dep/xmit_linux.c

diff --git a/MAINTAINERS b/MAINTAINERS
index b53c828..0c554b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11210,13 +11210,6 @@ M:	Florian Schilhabel <florian.c.schilhabel@googlemail.com>.
 S:	Odd Fixes
 F:	drivers/staging/rtl8712/
 
-STAGING - REALTEK RTL8723U WIRELESS DRIVER
-M:	Larry Finger <Larry.Finger@lwfinger.net>
-M:	Jes Sorensen <Jes.Sorensen@redhat.com>
-L:	linux-wireless@vger.kernel.org
-S:	Maintained
-F:	drivers/staging/rtl8723au/
-
 STAGING - SILICON MOTION SM750 FRAME BUFFER DRIVER
 M:	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
 M:	Teddy Wang <teddy.wang@siliconmotion.com>
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index af94764..5ebaf00 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -40,8 +40,6 @@ source "drivers/staging/rtl8712/Kconfig"
 
 source "drivers/staging/rtl8188eu/Kconfig"
 
-source "drivers/staging/rtl8723au/Kconfig"
-
 source "drivers/staging/rts5208/Kconfig"
 
 source "drivers/staging/octeon/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 9f6009d..29a1672 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -9,7 +9,6 @@ obj-$(CONFIG_RTL8192U)		+= rtl8192u/
 obj-$(CONFIG_RTL8192E)		+= rtl8192e/
 obj-$(CONFIG_R8712U)		+= rtl8712/
 obj-$(CONFIG_R8188EU)		+= rtl8188eu/
-obj-$(CONFIG_R8723AU)		+= rtl8723au/
 obj-$(CONFIG_RTS5208)		+= rts5208/
 obj-$(CONFIG_NETLOGIC_XLR_NET)	+= netlogic/
 obj-$(CONFIG_OCTEON_ETHERNET)	+= octeon/
diff --git a/drivers/staging/rtl8723au/Kconfig b/drivers/staging/rtl8723au/Kconfig
deleted file mode 100644
index 277c1ab..0000000
diff --git a/drivers/staging/rtl8723au/Makefile b/drivers/staging/rtl8723au/Makefile
deleted file mode 100644
index 3e89890..0000000
diff --git a/drivers/staging/rtl8723au/TODO b/drivers/staging/rtl8723au/TODO
deleted file mode 100644
index 42b86e4..0000000
diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
deleted file mode 100644
index aad686d..0000000
diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
deleted file mode 100644
index cd4e0f0..0000000
diff --git a/drivers/staging/rtl8723au/core/rtw_efuse.c b/drivers/staging/rtl8723au/core/rtw_efuse.c
deleted file mode 100644
index 359ef41..0000000
diff --git a/drivers/staging/rtl8723au/core/rtw_ieee80211.c b/drivers/staging/rtl8723au/core/rtw_ieee80211.c
deleted file mode 100644
index 9fa0ef1..0000000
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
deleted file mode 100644
index a786fc4..0000000
diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
deleted file mode 100644
index 7dd1540..0000000
diff --git a/drivers/staging/rtl8723au/core/rtw_pwrctrl.c b/drivers/staging/rtl8723au/core/rtw_pwrctrl.c
deleted file mode 100644
index 2d43958..0000000
diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
deleted file mode 100644
index 150dabc..0000000
diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
deleted file mode 100644
index 5a4cfdf..0000000
diff --git a/drivers/staging/rtl8723au/core/rtw_sreset.c b/drivers/staging/rtl8723au/core/rtw_sreset.c
deleted file mode 100644
index 29a29d9..0000000
diff --git a/drivers/staging/rtl8723au/core/rtw_sta_mgt.c b/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
deleted file mode 100644
index a9b778c..0000000
diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
deleted file mode 100644
index 694cf17..0000000
diff --git a/drivers/staging/rtl8723au/core/rtw_xmit.c b/drivers/staging/rtl8723au/core/rtw_xmit.c
deleted file mode 100644
index 003576d..0000000
diff --git a/drivers/staging/rtl8723au/hal/Hal8723PwrSeq.c b/drivers/staging/rtl8723au/hal/Hal8723PwrSeq.c
deleted file mode 100644
index 747f86c..0000000
diff --git a/drivers/staging/rtl8723au/hal/Hal8723UHWImg_CE.c b/drivers/staging/rtl8723au/hal/Hal8723UHWImg_CE.c
deleted file mode 100644
index 56833da..0000000
diff --git a/drivers/staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c b/drivers/staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c
deleted file mode 100644
index 3f9ec9e0..0000000
diff --git a/drivers/staging/rtl8723au/hal/HalHWImg8723A_BB.c b/drivers/staging/rtl8723au/hal/HalHWImg8723A_BB.c
deleted file mode 100644
index 8d3ea6c..0000000
diff --git a/drivers/staging/rtl8723au/hal/HalHWImg8723A_MAC.c b/drivers/staging/rtl8723au/hal/HalHWImg8723A_MAC.c
deleted file mode 100644
index 9bf6859..0000000
diff --git a/drivers/staging/rtl8723au/hal/HalHWImg8723A_RF.c b/drivers/staging/rtl8723au/hal/HalHWImg8723A_RF.c
deleted file mode 100644
index 286f3ea..0000000
diff --git a/drivers/staging/rtl8723au/hal/HalPwrSeqCmd.c b/drivers/staging/rtl8723au/hal/HalPwrSeqCmd.c
deleted file mode 100644
index 0a3d96e..0000000
diff --git a/drivers/staging/rtl8723au/hal/hal_com.c b/drivers/staging/rtl8723au/hal/hal_com.c
deleted file mode 100644
index 9d7b11b..0000000
diff --git a/drivers/staging/rtl8723au/hal/hal_intf.c b/drivers/staging/rtl8723au/hal/hal_intf.c
deleted file mode 100644
index 5383e69..0000000
diff --git a/drivers/staging/rtl8723au/hal/odm.c b/drivers/staging/rtl8723au/hal/odm.c
deleted file mode 100644
index e279c34..0000000
diff --git a/drivers/staging/rtl8723au/hal/odm_HWConfig.c b/drivers/staging/rtl8723au/hal/odm_HWConfig.c
deleted file mode 100644
index 0562f61..0000000
diff --git a/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c b/drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c
deleted file mode 100644
index a63c6cb..0000000
diff --git a/drivers/staging/rtl8723au/hal/odm_debug.c b/drivers/staging/rtl8723au/hal/odm_debug.c
deleted file mode 100644
index cb2bdda..0000000
diff --git a/drivers/staging/rtl8723au/hal/odm_interface.c b/drivers/staging/rtl8723au/hal/odm_interface.c
deleted file mode 100644
index d8f6790..0000000
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
deleted file mode 100644
index 47e8d69..0000000
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
deleted file mode 100644
index 2230f4c..0000000
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_dm.c b/drivers/staging/rtl8723au/hal/rtl8723a_dm.c
deleted file mode 100644
index 1e831f2..0000000
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
deleted file mode 100644
index 1ea0af4..0000000
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c b/drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c
deleted file mode 100644
index 06a6c3e..0000000
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_rf6052.c b/drivers/staging/rtl8723au/hal/rtl8723a_rf6052.c
deleted file mode 100644
index 24c0ff3..0000000
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_rxdesc.c b/drivers/staging/rtl8723au/hal/rtl8723a_rxdesc.c
deleted file mode 100644
index 81b5efe..0000000
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_sreset.c b/drivers/staging/rtl8723au/hal/rtl8723a_sreset.c
deleted file mode 100644
index 3c46294..0000000
diff --git a/drivers/staging/rtl8723au/hal/rtl8723au_recv.c b/drivers/staging/rtl8723au/hal/rtl8723au_recv.c
deleted file mode 100644
index 0fec84b..0000000
diff --git a/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c b/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
deleted file mode 100644
index 14746dd..0000000
diff --git a/drivers/staging/rtl8723au/hal/usb_halinit.c b/drivers/staging/rtl8723au/hal/usb_halinit.c
deleted file mode 100644
index fa47aeb..0000000
diff --git a/drivers/staging/rtl8723au/hal/usb_ops_linux.c b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
deleted file mode 100644
index 5c81ff4..0000000
diff --git a/drivers/staging/rtl8723au/include/Hal8723APhyCfg.h b/drivers/staging/rtl8723au/include/Hal8723APhyCfg.h
deleted file mode 100644
index bcf3657..0000000
diff --git a/drivers/staging/rtl8723au/include/Hal8723APhyReg.h b/drivers/staging/rtl8723au/include/Hal8723APhyReg.h
deleted file mode 100644
index 759928f..0000000
diff --git a/drivers/staging/rtl8723au/include/Hal8723PwrSeq.h b/drivers/staging/rtl8723au/include/Hal8723PwrSeq.h
deleted file mode 100644
index 3771d6b..0000000
diff --git a/drivers/staging/rtl8723au/include/Hal8723UHWImg_CE.h b/drivers/staging/rtl8723au/include/Hal8723UHWImg_CE.h
deleted file mode 100644
index c834b3a..0000000
diff --git a/drivers/staging/rtl8723au/include/HalDMOutSrc8723A.h b/drivers/staging/rtl8723au/include/HalDMOutSrc8723A.h
deleted file mode 100644
index d7651f7..0000000
diff --git a/drivers/staging/rtl8723au/include/HalHWImg8723A_BB.h b/drivers/staging/rtl8723au/include/HalHWImg8723A_BB.h
deleted file mode 100644
index 1276094..0000000
diff --git a/drivers/staging/rtl8723au/include/HalHWImg8723A_FW.h b/drivers/staging/rtl8723au/include/HalHWImg8723A_FW.h
deleted file mode 100644
index 7ee363b..0000000
diff --git a/drivers/staging/rtl8723au/include/HalHWImg8723A_MAC.h b/drivers/staging/rtl8723au/include/HalHWImg8723A_MAC.h
deleted file mode 100644
index 201be1f..0000000
diff --git a/drivers/staging/rtl8723au/include/HalHWImg8723A_RF.h b/drivers/staging/rtl8723au/include/HalHWImg8723A_RF.h
deleted file mode 100644
index c9af1c3..0000000
diff --git a/drivers/staging/rtl8723au/include/HalPwrSeqCmd.h b/drivers/staging/rtl8723au/include/HalPwrSeqCmd.h
deleted file mode 100644
index 12e03a3..0000000
diff --git a/drivers/staging/rtl8723au/include/HalVerDef.h b/drivers/staging/rtl8723au/include/HalVerDef.h
deleted file mode 100644
index 2a0e4ea..0000000
diff --git a/drivers/staging/rtl8723au/include/drv_types.h b/drivers/staging/rtl8723au/include/drv_types.h
deleted file mode 100644
index e83463a..0000000
diff --git a/drivers/staging/rtl8723au/include/hal_com.h b/drivers/staging/rtl8723au/include/hal_com.h
deleted file mode 100644
index 9c50320..0000000
diff --git a/drivers/staging/rtl8723au/include/hal_intf.h b/drivers/staging/rtl8723au/include/hal_intf.h
deleted file mode 100644
index b924d47..0000000
diff --git a/drivers/staging/rtl8723au/include/ieee80211.h b/drivers/staging/rtl8723au/include/ieee80211.h
deleted file mode 100644
index 634102e..0000000
diff --git a/drivers/staging/rtl8723au/include/ioctl_cfg80211.h b/drivers/staging/rtl8723au/include/ioctl_cfg80211.h
deleted file mode 100644
index 3a4ead5..0000000
diff --git a/drivers/staging/rtl8723au/include/mlme_osdep.h b/drivers/staging/rtl8723au/include/mlme_osdep.h
deleted file mode 100644
index 4bb5525..0000000
diff --git a/drivers/staging/rtl8723au/include/odm.h b/drivers/staging/rtl8723au/include/odm.h
deleted file mode 100644
index 24f2f28..0000000
diff --git a/drivers/staging/rtl8723au/include/odm_HWConfig.h b/drivers/staging/rtl8723au/include/odm_HWConfig.h
deleted file mode 100644
index c748d5f..0000000
diff --git a/drivers/staging/rtl8723au/include/odm_RegConfig8723A.h b/drivers/staging/rtl8723au/include/odm_RegConfig8723A.h
deleted file mode 100644
index f2a54d8..0000000
diff --git a/drivers/staging/rtl8723au/include/odm_RegDefine11N.h b/drivers/staging/rtl8723au/include/odm_RegDefine11N.h
deleted file mode 100644
index 2778215..0000000
diff --git a/drivers/staging/rtl8723au/include/odm_debug.h b/drivers/staging/rtl8723au/include/odm_debug.h
deleted file mode 100644
index c4b375a..0000000
diff --git a/drivers/staging/rtl8723au/include/odm_interface.h b/drivers/staging/rtl8723au/include/odm_interface.h
deleted file mode 100644
index 1d3bf03..0000000
diff --git a/drivers/staging/rtl8723au/include/odm_precomp.h b/drivers/staging/rtl8723au/include/odm_precomp.h
deleted file mode 100644
index fb793c8..0000000
diff --git a/drivers/staging/rtl8723au/include/odm_reg.h b/drivers/staging/rtl8723au/include/odm_reg.h
deleted file mode 100644
index c1843312..0000000
diff --git a/drivers/staging/rtl8723au/include/osdep_intf.h b/drivers/staging/rtl8723au/include/osdep_intf.h
deleted file mode 100644
index a157eb2..0000000
diff --git a/drivers/staging/rtl8723au/include/osdep_service.h b/drivers/staging/rtl8723au/include/osdep_service.h
deleted file mode 100644
index 33ecb9c..0000000
diff --git a/drivers/staging/rtl8723au/include/recv_osdep.h b/drivers/staging/rtl8723au/include/recv_osdep.h
deleted file mode 100644
index c2d3f1b..0000000
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_bt-coexist.h b/drivers/staging/rtl8723au/include/rtl8723a_bt-coexist.h
deleted file mode 100644
index 7add5df..0000000
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_bt_intf.h b/drivers/staging/rtl8723au/include/rtl8723a_bt_intf.h
deleted file mode 100644
index 4733559..0000000
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_cmd.h b/drivers/staging/rtl8723au/include/rtl8723a_cmd.h
deleted file mode 100644
index f95535a..0000000
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_dm.h b/drivers/staging/rtl8723au/include/rtl8723a_dm.h
deleted file mode 100644
index bf236e8..0000000
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_hal.h b/drivers/staging/rtl8723au/include/rtl8723a_hal.h
deleted file mode 100644
index 77a0fd4..0000000
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_pg.h b/drivers/staging/rtl8723au/include/rtl8723a_pg.h
deleted file mode 100644
index 5c2ec44..0000000
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_recv.h b/drivers/staging/rtl8723au/include/rtl8723a_recv.h
deleted file mode 100644
index 875d37b..0000000
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_rf.h b/drivers/staging/rtl8723au/include/rtl8723a_rf.h
deleted file mode 100644
index 0432799..0000000
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_spec.h b/drivers/staging/rtl8723au/include/rtl8723a_spec.h
deleted file mode 100644
index 2f18689..0000000
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_sreset.h b/drivers/staging/rtl8723au/include/rtl8723a_sreset.h
deleted file mode 100644
index 6197910..0000000
diff --git a/drivers/staging/rtl8723au/include/rtl8723a_xmit.h b/drivers/staging/rtl8723au/include/rtl8723a_xmit.h
deleted file mode 100644
index 7db29f4..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_ap.h b/drivers/staging/rtl8723au/include/rtw_ap.h
deleted file mode 100644
index 55a708f..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_cmd.h b/drivers/staging/rtl8723au/include/rtw_cmd.h
deleted file mode 100644
index d1fa95d..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_debug.h b/drivers/staging/rtl8723au/include/rtw_debug.h
deleted file mode 100644
index 159183e..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_eeprom.h b/drivers/staging/rtl8723au/include/rtw_eeprom.h
deleted file mode 100644
index a86f36e..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_efuse.h b/drivers/staging/rtl8723au/include/rtw_efuse.h
deleted file mode 100644
index c577e26..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_event.h b/drivers/staging/rtl8723au/include/rtw_event.h
deleted file mode 100644
index 4557aec..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_ht.h b/drivers/staging/rtl8723au/include/rtw_ht.h
deleted file mode 100644
index 780eb89..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_io.h b/drivers/staging/rtl8723au/include/rtw_io.h
deleted file mode 100644
index d875e9e..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_mlme.h b/drivers/staging/rtl8723au/include/rtw_mlme.h
deleted file mode 100644
index dbd3a5f..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_mlme_ext.h b/drivers/staging/rtl8723au/include/rtw_mlme_ext.h
deleted file mode 100644
index 0e7d3da..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_pwrctrl.h b/drivers/staging/rtl8723au/include/rtw_pwrctrl.h
deleted file mode 100644
index 699b9f3..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_recv.h b/drivers/staging/rtl8723au/include/rtw_recv.h
deleted file mode 100644
index 85a5edb..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_rf.h b/drivers/staging/rtl8723au/include/rtw_rf.h
deleted file mode 100644
index a7de714..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_security.h b/drivers/staging/rtl8723au/include/rtw_security.h
deleted file mode 100644
index 624a9d7..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_sreset.h b/drivers/staging/rtl8723au/include/rtw_sreset.h
deleted file mode 100644
index 60fa829..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_version.h b/drivers/staging/rtl8723au/include/rtw_version.h
deleted file mode 100644
index c947733..0000000
diff --git a/drivers/staging/rtl8723au/include/rtw_xmit.h b/drivers/staging/rtl8723au/include/rtw_xmit.h
deleted file mode 100644
index 24f326b..0000000
diff --git a/drivers/staging/rtl8723au/include/sta_info.h b/drivers/staging/rtl8723au/include/sta_info.h
deleted file mode 100644
index e726005..0000000
diff --git a/drivers/staging/rtl8723au/include/usb_ops.h b/drivers/staging/rtl8723au/include/usb_ops.h
deleted file mode 100644
index ff11e13..0000000
diff --git a/drivers/staging/rtl8723au/include/usb_ops_linux.h b/drivers/staging/rtl8723au/include/usb_ops_linux.h
deleted file mode 100644
index af2f14b..0000000
diff --git a/drivers/staging/rtl8723au/include/wifi.h b/drivers/staging/rtl8723au/include/wifi.h
deleted file mode 100644
index 25d573c..0000000
diff --git a/drivers/staging/rtl8723au/include/wlan_bssdef.h b/drivers/staging/rtl8723au/include/wlan_bssdef.h
deleted file mode 100644
index 95b32e1..0000000
diff --git a/drivers/staging/rtl8723au/include/xmit_osdep.h b/drivers/staging/rtl8723au/include/xmit_osdep.h
deleted file mode 100644
index 2be04c48..0000000
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
deleted file mode 100644
index d0ba377..0000000
diff --git a/drivers/staging/rtl8723au/os_dep/mlme_linux.c b/drivers/staging/rtl8723au/os_dep/mlme_linux.c
deleted file mode 100644
index ca24369..0000000
diff --git a/drivers/staging/rtl8723au/os_dep/os_intfs.c b/drivers/staging/rtl8723au/os_dep/os_intfs.c
deleted file mode 100644
index b8848c2..0000000
diff --git a/drivers/staging/rtl8723au/os_dep/recv_linux.c b/drivers/staging/rtl8723au/os_dep/recv_linux.c
deleted file mode 100644
index 084b506..0000000
diff --git a/drivers/staging/rtl8723au/os_dep/usb_intf.c b/drivers/staging/rtl8723au/os_dep/usb_intf.c
deleted file mode 100644
index fa7dda5..0000000
diff --git a/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c b/drivers/staging/rtl8723au/os_dep/usb_ops_linux.c
deleted file mode 100644
index cf4a506..0000000
diff --git a/drivers/staging/rtl8723au/os_dep/xmit_linux.c b/drivers/staging/rtl8723au/os_dep/xmit_linux.c
deleted file mode 100644
index 64be72a..0000000
-- 
2.7.4
