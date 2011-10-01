Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43696 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab1JATYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 15:24:34 -0400
Received: by yxl31 with SMTP id 31so2485530yxl.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 Oct 2011 12:24:33 -0700 (PDT)
Message-ID: <4E8768EC.9040900@lwfinger.net> (sfid-20111001_212517_090857_A1F4426E)
Date: Sat, 01 Oct 2011 14:24:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Ian Jeffray <ian@emobix.co.uk>, linux-wireless@vger.kernel.org
Subject: Re: r8712u driver - on ARM
References: <4E81ED65.7060703@emobix.co.uk> <4E8757A8.1010302@emobix.co.uk> <4E87609E.5030002@lwfinger.net> <201110012054.42461.chunkeey@googlemail.com>
In-Reply-To: <201110012054.42461.chunkeey@googlemail.com>
Content-Type: multipart/mixed;
 boundary="------------050601010004010508060703"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050601010004010508060703
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 10/01/2011 01:54 PM, Christian Lamparter wrote:
> well, it looks like Realtek did a better job then and unfortunately
> your problem is related to something else.
>
> Regards,
> 	Chr

Onwards. Thanks Christian for your suggestions. At least we were able to 
eliminate one source of the problem.

BTW, netperf shows that r8712u can transmit at ~80 and receive at ~60 Mbps when 
connected to a 270 Mbps AP. As Realtek lists this as capable of 150 Mbps, x86_64 
is getting the max transmit rate that we might expect.

@Ian: Ali Bahar submitted a number of patches to GregKH updating the driver to 
the latest Realtek version. As the git repo is not available due to kernel.org, 
and I have not found an alternate location that Greg has established, I am 
attaching them here.

Larry



--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0001-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Cop.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Cop.pa";
 filename*1="tch"

>From 35a3512d7d279075be2c1857bf791c8279f43ad0 Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sat, 3 Sep 2011 14:14:00 -0500
Subject: [PATCH 01/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 Copyright banners.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

Only copyright banners have been added to these files. No functional changes.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/basic_types.h       |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/drv_types.h         |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/ieee80211.h         |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/osdep_intf.h        |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/osdep_service.h     |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/rtl8712_cmd.h       |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/rtl8712_event.h     |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/rtl8712_recv.h      |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/rtl8712_xmit.h      |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/rtl871x_cmd.h       |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/rtl871x_debug.h     |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/rtl871x_io.h        |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/rtl871x_ioctl_rtl.h |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/rtl871x_led.h       |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/rtl871x_mlme.h      |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/rtl871x_mp.c        |   26 ++++++++++++++++++--------
 drivers/staging/rtl8712/rtl871x_mp_ioctl.h  |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/rtl871x_xmit.h      |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/sta_info.h          |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/wifi.h              |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/wlan_bssdef.h       |   25 +++++++++++++++++++++++++
 drivers/staging/rtl8712/xmit_osdep.h        |   25 +++++++++++++++++++++++++
 22 files changed, 543 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8712/basic_types.h b/drivers/staging/rtl8712/basic_types.h
index a0538a8..7561bed 100644
--- a/drivers/staging/rtl8712/basic_types.h
+++ b/drivers/staging/rtl8712/basic_types.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef __BASIC_TYPES_H__
 #define __BASIC_TYPES_H__
 
diff --git a/drivers/staging/rtl8712/drv_types.h b/drivers/staging/rtl8712/drv_types.h
index c5303c3..6e16d58 100644
--- a/drivers/staging/rtl8712/drv_types.h
+++ b/drivers/staging/rtl8712/drv_types.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 /*---------------------------------------------------------------------
 
 	For type defines and data structure defines
diff --git a/drivers/staging/rtl8712/ieee80211.h b/drivers/staging/rtl8712/ieee80211.h
index d62c6ac..d1d0868 100644
--- a/drivers/staging/rtl8712/ieee80211.h
+++ b/drivers/staging/rtl8712/ieee80211.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef __IEEE80211_H
 #define __IEEE80211_H
 
diff --git a/drivers/staging/rtl8712/osdep_intf.h b/drivers/staging/rtl8712/osdep_intf.h
index 3bc2025..aa0ec74 100644
--- a/drivers/staging/rtl8712/osdep_intf.h
+++ b/drivers/staging/rtl8712/osdep_intf.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef __OSDEP_INTF_H_
 #define __OSDEP_INTF_H_
 
diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index aac97bb..e85774c 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef __OSDEP_SERVICE_H_
 #define __OSDEP_SERVICE_H_
 
diff --git a/drivers/staging/rtl8712/rtl8712_cmd.h b/drivers/staging/rtl8712/rtl8712_cmd.h
index 13ef062..a4eecc6 100644
--- a/drivers/staging/rtl8712/rtl8712_cmd.h
+++ b/drivers/staging/rtl8712/rtl8712_cmd.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef __RTL8712_CMD_H_
 #define __RTL8712_CMD_H_
 
diff --git a/drivers/staging/rtl8712/rtl8712_event.h b/drivers/staging/rtl8712/rtl8712_event.h
index 2731693..3d7f79e 100644
--- a/drivers/staging/rtl8712/rtl8712_event.h
+++ b/drivers/staging/rtl8712/rtl8712_event.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef _RTL8712_EVENT_H_
 #define _RTL8712_EVENT_H_
 
diff --git a/drivers/staging/rtl8712/rtl8712_recv.h b/drivers/staging/rtl8712/rtl8712_recv.h
index c48757f..1d6c9c7 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.h
+++ b/drivers/staging/rtl8712/rtl8712_recv.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef _RTL8712_RECV_H_
 #define _RTL8712_RECV_H_
 
diff --git a/drivers/staging/rtl8712/rtl8712_xmit.h b/drivers/staging/rtl8712/rtl8712_xmit.h
index 12a080f..1e8f3fe 100644
--- a/drivers/staging/rtl8712/rtl8712_xmit.h
+++ b/drivers/staging/rtl8712/rtl8712_xmit.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef _RTL8712_XMIT_H_
 #define _RTL8712_XMIT_H_
 
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.h b/drivers/staging/rtl8712/rtl871x_cmd.h
index dcf256d..25ef848 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.h
+++ b/drivers/staging/rtl8712/rtl871x_cmd.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef __RTL871X_CMD_H_
 #define __RTL871X_CMD_H_
 
diff --git a/drivers/staging/rtl8712/rtl871x_debug.h b/drivers/staging/rtl8712/rtl871x_debug.h
index c392fd9..74468b0 100644
--- a/drivers/staging/rtl8712/rtl871x_debug.h
+++ b/drivers/staging/rtl8712/rtl871x_debug.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef __RTL871X_DEBUG_H__
 #define __RTL871X_DEBUG_H__
 
diff --git a/drivers/staging/rtl8712/rtl871x_io.h b/drivers/staging/rtl8712/rtl871x_io.h
index b70cb2b..86308a0 100644
--- a/drivers/staging/rtl8712/rtl871x_io.h
+++ b/drivers/staging/rtl8712/rtl871x_io.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef _IO_H_
 #define _IO_H_
 
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_rtl.h b/drivers/staging/rtl8712/rtl871x_ioctl_rtl.h
index 4f1aa87..3bcceae 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_rtl.h
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_rtl.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef _RTL871X_IOCTL_RTL_H
 #define _RTL871X_IOCTL_RTL_H
 
diff --git a/drivers/staging/rtl8712/rtl871x_led.h b/drivers/staging/rtl8712/rtl871x_led.h
index 8085e5e..1a90c7f 100644
--- a/drivers/staging/rtl8712/rtl871x_led.h
+++ b/drivers/staging/rtl8712/rtl871x_led.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef __RTL8712_LED_H
 #define __RTL8712_LED_H
 
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.h b/drivers/staging/rtl8712/rtl871x_mlme.h
index 2794804..b8810a9 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.h
+++ b/drivers/staging/rtl8712/rtl871x_mlme.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef __RTL871X_MLME_H_
 #define __RTL871X_MLME_H_
 
diff --git a/drivers/staging/rtl8712/rtl871x_mp.c b/drivers/staging/rtl8712/rtl871x_mp.c
index 41e00a2..5638d5e 100644
--- a/drivers/staging/rtl8712/rtl871x_mp.c
+++ b/drivers/staging/rtl8712/rtl871x_mp.c
@@ -1,18 +1,28 @@
 /******************************************************************************
- * rtl871x_mp.c
  *
- * Description :
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
  *
- * Author :
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
  *
- * History :
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
  *
- * Copyright 2007, Realtek Corp.
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
  *
- * The contents of this file is the sole property of Realtek Corp. It can not be
- * be used, copied or modified without written permission from Realtek Corp.
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
  *
-*******************************************************************************/
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #define _RTL871X_MP_C_
 
 #include "osdep_service.h"
diff --git a/drivers/staging/rtl8712/rtl871x_mp_ioctl.h b/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
index 67759c3..b5ddcb6 100644
--- a/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
+++ b/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef _RTL871X_MP_IOCTL_H
 #define _RTL871X_MP_IOCTL_H
 
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.h b/drivers/staging/rtl8712/rtl871x_xmit.h
index df13e67..6304100 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.h
+++ b/drivers/staging/rtl8712/rtl871x_xmit.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef _RTL871X_XMIT_H_
 #define _RTL871X_XMIT_H_
 
diff --git a/drivers/staging/rtl8712/sta_info.h b/drivers/staging/rtl8712/sta_info.h
index 79ad159..2ac8d33 100644
--- a/drivers/staging/rtl8712/sta_info.h
+++ b/drivers/staging/rtl8712/sta_info.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef __STA_INFO_H_
 #define __STA_INFO_H_
 
diff --git a/drivers/staging/rtl8712/wifi.h b/drivers/staging/rtl8712/wifi.h
index 427ab7e..277398c 100644
--- a/drivers/staging/rtl8712/wifi.h
+++ b/drivers/staging/rtl8712/wifi.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef _WIFI_H_
 #define _WIFI_H_
 
diff --git a/drivers/staging/rtl8712/wlan_bssdef.h b/drivers/staging/rtl8712/wlan_bssdef.h
index 0d90e1f..2ea8a3d 100644
--- a/drivers/staging/rtl8712/wlan_bssdef.h
+++ b/drivers/staging/rtl8712/wlan_bssdef.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef __WLAN_BSSDEF_H__
 #define __WLAN_BSSDEF_H__
 
diff --git a/drivers/staging/rtl8712/xmit_osdep.h b/drivers/staging/rtl8712/xmit_osdep.h
index ca43937..19f6f3c 100644
--- a/drivers/staging/rtl8712/xmit_osdep.h
+++ b/drivers/staging/rtl8712/xmit_osdep.h
@@ -1,3 +1,28 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * Modifications for inclusion into the Linux staging tree are
+ * Copyright(c) 2010 Larry Finger. All rights reserved.
+ *
+ * Contact information:
+ * WLAN FAE <wlanfae@realtek.com>
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ ******************************************************************************/
 #ifndef __XMIT_OSDEP_H_
 #define __XMIT_OSDEP_H_
 
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0002-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Ren.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Ren.pa";
 filename*1="tch"

>From c1fd55ba743332fd851d1421794e5b381175c8b5 Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:05 +0800
Subject: [PATCH 02/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 Renamed _netdev_priv.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

Renamed _netdev_priv to netdev_priv.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/os_intfs.c            |   10 ++--
 drivers/staging/rtl8712/osdep_service.h       |    5 --
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |   68 ++++++++++++------------
 drivers/staging/rtl8712/usb_intf.c            |    2 +-
 drivers/staging/rtl8712/xmit_linux.c          |    2 +-
 5 files changed, 41 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index 6697941..90949cf 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -177,7 +177,7 @@ static uint loadparam(struct _adapter *padapter, struct  net_device *pnetdev)
 
 static int r871x_net_set_mac_address(struct net_device *pnetdev, void *p)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(pnetdev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(pnetdev);
 	struct sockaddr *addr = p;
 
 	if (padapter->bup == false)
@@ -187,7 +187,7 @@ static int r871x_net_set_mac_address(struct net_device *pnetdev, void *p)
 
 static struct net_device_stats *r871x_net_get_stats(struct net_device *pnetdev)
 {
-	struct _adapter *padapter = (struct _adapter *) _netdev_priv(pnetdev);
+	struct _adapter *padapter = (struct _adapter *) netdev_priv(pnetdev);
 	struct xmit_priv *pxmitpriv = &(padapter->xmitpriv);
 	struct recv_priv *precvpriv = &(padapter->recvpriv);
 
@@ -221,7 +221,7 @@ struct net_device *r8712_init_netdev(void)
 		strcpy(ifname, "wlan%d");
 		dev_alloc_name(pnetdev, ifname);
 	}
-	padapter = (struct _adapter *) _netdev_priv(pnetdev);
+	padapter = (struct _adapter *) netdev_priv(pnetdev);
 	padapter->pnetdev = pnetdev;
 	printk(KERN_INFO "r8712u: register rtl8712_netdev_ops to"
 	       " netdev_ops\n");
@@ -383,7 +383,7 @@ static void enable_video_mode(struct _adapter *padapter, int cbw40_value)
  */
 static int netdev_open(struct net_device *pnetdev)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(pnetdev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(pnetdev);
 
 	if (padapter->bup == false) {
 		padapter->bDriverStopped = false;
@@ -448,7 +448,7 @@ netdev_open_error:
  */
 static int netdev_close(struct net_device *pnetdev)
 {
-	struct _adapter *padapter = (struct _adapter *) _netdev_priv(pnetdev);
+	struct _adapter *padapter = (struct _adapter *) netdev_priv(pnetdev);
 
 	/* Close LED*/
 	padapter->ledpriv.LedControlHandler(padapter, LED_CTL_POWER_OFF);
diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index e85774c..60e586c 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -78,11 +78,6 @@ struct	__queue	{
 		spin_lock_init(&((pqueue)->lock));	\
 	} while (0)
 
-static inline void *_netdev_priv(struct net_device *dev)
-{
-	return netdev_priv(dev);
-}
-
 static inline void os_free_netdev(struct net_device *dev)
 {
 	free_netdev(dev);
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index d310a61..ba70081 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -363,7 +363,7 @@ static inline char *translate_scan(struct _adapter *padapter,
 
 static int wpa_set_auth_algs(struct net_device *dev, u32 value)
 {
-	struct _adapter *padapter = (struct _adapter *) _netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *) netdev_priv(dev);
 	int ret = 0;
 
 	if ((value & AUTH_ALG_SHARED_KEY) && (value & AUTH_ALG_OPEN_SYSTEM)) {
@@ -395,7 +395,7 @@ static int wpa_set_encryption(struct net_device *dev, struct ieee_param *param,
 	int ret = 0;
 	u32 wep_key_idx, wep_key_len = 0;
 	struct NDIS_802_11_WEP	 *pwep = NULL;
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
 
@@ -637,7 +637,7 @@ static int r8711_wx_get_name(struct net_device *dev,
 			     struct iw_request_info *info,
 			     union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	u32 ht_ielen = 0;
 	char *p;
 	u8 ht_cap = false;
@@ -693,7 +693,7 @@ static int r8711_wx_set_freq(struct net_device *dev,
 			     struct iw_request_info *info,
 			     union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct iw_freq *fwrq = &wrqu->freq;
 	int rc = 0;
 
@@ -727,7 +727,7 @@ static int r8711_wx_get_freq(struct net_device *dev,
 			     struct iw_request_info *info,
 			     union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct ndis_wlan_bssid_ex *pcur_bss = &pmlmepriv->cur_network.network;
 
@@ -745,7 +745,7 @@ static int r8711_wx_set_mode(struct net_device *dev,
 			     struct iw_request_info *a,
 			     union iwreq_data *wrqu, char *b)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	enum NDIS_802_11_NETWORK_INFRASTRUCTURE networkType;
 
 	switch (wrqu->mode) {
@@ -776,7 +776,7 @@ static int r8711_wx_set_mode(struct net_device *dev,
 static int r8711_wx_get_mode(struct net_device *dev, struct iw_request_info *a,
 			     union iwreq_data *wrqu, char *b)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 
 	if (check_fwstate(pmlmepriv, WIFI_STATION_STATE) == true)
@@ -795,7 +795,7 @@ static int r871x_wx_set_pmkid(struct net_device *dev,
 			     struct iw_request_info *a,
 			     union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
 	struct iw_pmksa *pPMK = (struct iw_pmksa *) extra;
 	u8 strZeroMacAddress[ETH_ALEN] = {0x00};
@@ -989,7 +989,7 @@ static int r8711_wx_set_wap(struct net_device *dev,
 			 char *extra)
 {
 	int ret = -EINPROGRESS;
-	struct _adapter *padapter = (struct _adapter *) _netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *) netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct  __queue *queue = &pmlmepriv->scanned_queue;
 	struct sockaddr *temp = (struct sockaddr *)awrq;
@@ -1039,7 +1039,7 @@ static int r8711_wx_get_wap(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct ndis_wlan_bssid_ex *pcur_bss = &pmlmepriv->cur_network.network;
 
@@ -1058,7 +1058,7 @@ static int r871x_wx_set_mlme(struct net_device *dev,
 {
 	int ret = 0;
 	u16 reason;
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct iw_mlme *mlme = (struct iw_mlme *) extra;
 
 	if (mlme == NULL)
@@ -1091,7 +1091,7 @@ static int r8711_wx_set_scan(struct net_device *dev,
 			struct iw_request_info *a,
 			union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	u8 status = true;
 
@@ -1139,7 +1139,7 @@ static int r8711_wx_get_scan(struct net_device *dev,
 				struct iw_request_info *a,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct  __queue *queue = &pmlmepriv->scanned_queue;
 	struct wlan_network *pnetwork = NULL;
@@ -1193,7 +1193,7 @@ static int r8711_wx_set_essid(struct net_device *dev,
 				struct iw_request_info *a,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct  __queue *queue = &pmlmepriv->scanned_queue;
 	struct wlan_network *pnetwork = NULL;
@@ -1246,7 +1246,7 @@ static int r8711_wx_get_essid(struct net_device *dev,
 				struct iw_request_info *a,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct ndis_wlan_bssid_ex *pcur_bss = &pmlmepriv->cur_network.network;
 	u32 len, ret = 0;
@@ -1265,7 +1265,7 @@ static int r8711_wx_set_rate(struct net_device *dev,
 				struct iw_request_info *a,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	u32 target_rate = wrqu->bitrate.value;
 	u32 fixed = wrqu->bitrate.fixed;
 	u32 ratevalue = 0;
@@ -1337,7 +1337,7 @@ static int r8711_wx_get_rate(struct net_device *dev,
 			     struct iw_request_info *info,
 			     union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct ndis_wlan_bssid_ex *pcur_bss = &pmlmepriv->cur_network.network;
 	struct ieee80211_ht_cap *pht_capie;
@@ -1396,7 +1396,7 @@ static int r8711_wx_get_rts(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 
 	wrqu->rts.value = padapter->registrypriv.rts_thresh;
 	wrqu->rts.fixed = 0;	/* no auto select */
@@ -1407,7 +1407,7 @@ static int r8711_wx_set_frag(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 
 	if (wrqu->frag.disabled)
 		padapter->xmitpriv.frag_len = MAX_FRAG_THRESHOLD;
@@ -1424,7 +1424,7 @@ static int r8711_wx_get_frag(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *) _netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *) netdev_priv(dev);
 
 	wrqu->frag.value = padapter->xmitpriv.frag_len;
 	wrqu->frag.fixed = 0;	/* no auto select */
@@ -1450,7 +1450,7 @@ static int r8711_wx_set_enc(struct net_device *dev,
 	struct NDIS_802_11_WEP	 wep;
 	enum NDIS_802_11_AUTHENTICATION_MODE authmode;
 	struct iw_point *erq = &(wrqu->encoding);
-	struct _adapter *padapter = (struct _adapter *) _netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *) netdev_priv(dev);
 
 	key = erq->flags & IW_ENCODE_INDEX;
 	memset(&wep, 0, sizeof(struct NDIS_802_11_WEP));
@@ -1544,7 +1544,7 @@ static int r8711_wx_get_enc(struct net_device *dev,
 				union iwreq_data *wrqu, char *keybuf)
 {
 	uint key, ret = 0;
-	struct _adapter *padapter = (struct _adapter *) _netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *) netdev_priv(dev);
 	struct iw_point *erq = &(wrqu->encoding);
 	struct	mlme_priv	*pmlmepriv = &(padapter->mlmepriv);
 
@@ -1616,7 +1616,7 @@ static int r871x_wx_set_gen_ie(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 
 	return r871x_set_wpa_ie(padapter, extra, wrqu->data.length);
 }
@@ -1625,7 +1625,7 @@ static int r871x_wx_set_auth(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct iw_param *param = (struct iw_param *)&(wrqu->param);
 	int paramid;
 	int paramval;
@@ -1771,7 +1771,7 @@ static int r8711_wx_read32(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *keybuf)
 {
-	struct _adapter *padapter = (struct _adapter *) _netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *) netdev_priv(dev);
 	u32 addr;
 	u32 data32;
 
@@ -1788,7 +1788,7 @@ static int r8711_wx_write32(struct net_device *dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *wrqu, char *keybuf)
 {
-	struct _adapter *padapter = (struct _adapter *) _netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *) netdev_priv(dev);
 	u32 addr;
 	u32 data32;
 
@@ -1816,7 +1816,7 @@ static int r871x_mp_ioctl_hdl(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct iw_point *p = &wrqu->data;
 	struct oid_par_priv oid_par;
 	struct mp_ioctl_handler *phandler;
@@ -1899,7 +1899,7 @@ static int r871x_get_ap_info(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct  __queue *queue = &pmlmepriv->scanned_queue;
 	struct iw_point *pdata = &wrqu->data;
@@ -1970,7 +1970,7 @@ static int r871x_set_pid(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *) _netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *) netdev_priv(dev);
 	struct iw_point *pdata = &wrqu->data;
 
 	if ((padapter->bDriverStopped) || (pdata == NULL))
@@ -1984,7 +1984,7 @@ static int r871x_wps_start(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
 {
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(dev);
 	struct iw_point *pdata = &wrqu->data;
 	u32   u32wps_start = 0;
 
@@ -2008,7 +2008,7 @@ static int r871x_wps_start(struct net_device *dev,
 
 static int wpa_set_param(struct net_device *dev, u8 name, u32 value)
 {
-	struct _adapter *padapter = (struct _adapter *) _netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *) netdev_priv(dev);
 
 	switch (name) {
 	case IEEE_PARAM_WPA_ENABLED:
@@ -2061,7 +2061,7 @@ static int wpa_set_param(struct net_device *dev, u8 name, u32 value)
 
 static int wpa_mlme(struct net_device *dev, u32 command, u32 reason)
 {
-	struct _adapter *padapter = (struct _adapter *) _netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *) netdev_priv(dev);
 
 	switch (command) {
 	case IEEE_MLME_STA_DEAUTH:
@@ -2082,7 +2082,7 @@ static int wpa_supplicant_ioctl(struct net_device *dev, struct iw_point *p)
 {
 	struct ieee_param *param;
 	int ret = 0;
-	struct _adapter *padapter = (struct _adapter *) _netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *) netdev_priv(dev);
 
 	if (p->length < sizeof(struct ieee_param) || !p->pointer)
 		return -EINVAL;
@@ -2234,7 +2234,7 @@ static iw_handler r8711_private_handler[] = {
 
 static struct iw_statistics *r871x_get_wireless_stats(struct net_device *dev)
 {
-	struct _adapter *padapter = (struct _adapter *) _netdev_priv(dev);
+	struct _adapter *padapter = (struct _adapter *) netdev_priv(dev);
 	struct iw_statistics *piwstats = &padapter->iwstats;
 	int tmp_level = 0;
 	int tmp_qual = 0;
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 21ce2af..e590ebd 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -378,7 +378,7 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 	pnetdev = r8712_init_netdev();
 	if (!pnetdev)
 		goto error;
-	padapter = (struct _adapter *)_netdev_priv(pnetdev);
+	padapter = (struct _adapter *)netdev_priv(pnetdev);
 	disable_ht_for_spec_devid(pdid, padapter);
 	pdvobjpriv = &padapter->dvobjpriv;
 	pdvobjpriv->padapter = padapter;
diff --git a/drivers/staging/rtl8712/xmit_linux.c b/drivers/staging/rtl8712/xmit_linux.c
index 7dea8b5..3efebeb 100644
--- a/drivers/staging/rtl8712/xmit_linux.c
+++ b/drivers/staging/rtl8712/xmit_linux.c
@@ -146,7 +146,7 @@ void r8712_xmit_complete(struct _adapter *padapter, struct xmit_frame *pxframe)
 int r8712_xmit_entry(_pkt *pkt, struct  net_device *pnetdev)
 {
 	struct xmit_frame *pxmitframe = NULL;
-	struct _adapter *padapter = (struct _adapter *)_netdev_priv(pnetdev);
+	struct _adapter *padapter = (struct _adapter *)netdev_priv(pnetdev);
 	struct xmit_priv *pxmitpriv = &(padapter->xmitpriv);
 	int ret = 0;
 
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0003-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Rem.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Rem.pa";
 filename*1="tch"

>From 54f5d333cb434ad51d94e56b229c309cd603aaff Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sat, 3 Sep 2011 14:14:00 -0500
Subject: [PATCH 03/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 Removed os_free_netdev.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

Replaced (Realtek's)  os_free_netdev by (linux's own) free_netdev.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/os_intfs.c      |    2 +-
 drivers/staging/rtl8712/osdep_service.h |    5 -----
 drivers/staging/rtl8712/usb_intf.c      |    2 +-
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index 90949cf..a46d4bb 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -348,7 +348,7 @@ u8 r8712_free_drv_sw(struct _adapter *padapter)
 	_r8712_free_recv_priv(&padapter->recvpriv);
 	mp871xdeinit(padapter);
 	if (pnetdev)
-		os_free_netdev(pnetdev);
+		free_netdev(pnetdev);
 	return _SUCCESS;
 }
 
diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 60e586c..799ebac 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -78,11 +78,6 @@ struct	__queue	{
 		spin_lock_init(&((pqueue)->lock));	\
 	} while (0)
 
-static inline void os_free_netdev(struct net_device *dev)
-{
-	free_netdev(dev);
-}
-
 static inline struct list_head *get_next(struct list_head *list)
 {
 	return list->next;
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index e590ebd..263a4b5 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -599,7 +599,7 @@ error:
 	if (padapter->dvobj_deinit != NULL)
 		padapter->dvobj_deinit(padapter);
 	if (pnetdev)
-		os_free_netdev(pnetdev);
+		free_netdev(pnetdev);
 	return -ENODEV;
 }
 
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0004-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Rem.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0004-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Rem.pa";
 filename*1="tch"

>From 8efd687e5e4382c12293dc6e8469f6419d39e399 Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:07 +0800
Subject: [PATCH 04/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 Removed _usb_alloc_urb.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

Replaced (Realtek's) _usb_alloc_urb by (linux's own) usb_alloc_urb.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/osdep_service.h |    1 -
 drivers/staging/rtl8712/recv_linux.c    |    2 +-
 drivers/staging/rtl8712/usb_ops_linux.c |    2 +-
 drivers/staging/rtl8712/xmit_linux.c    |    2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 799ebac..72bb195 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -58,7 +58,6 @@
 #include "ethernet.h"
 #include <linux/if_arp.h>
 #include <linux/firmware.h>
-#define   _usb_alloc_urb(x, y)       usb_alloc_urb(x, y)
 #define   _usb_submit_urb(x, y)     usb_submit_urb(x, y)
 
 struct	__queue	{
diff --git a/drivers/staging/rtl8712/recv_linux.c b/drivers/staging/rtl8712/recv_linux.c
index 1f0949e..1e5c59b 100644
--- a/drivers/staging/rtl8712/recv_linux.c
+++ b/drivers/staging/rtl8712/recv_linux.c
@@ -51,7 +51,7 @@ int r8712_os_recvbuf_resource_alloc(struct _adapter *padapter,
 	int res = _SUCCESS;
 
 	precvbuf->irp_pending = false;
-	precvbuf->purb = _usb_alloc_urb(0, GFP_KERNEL);
+	precvbuf->purb = usb_alloc_urb(0, GFP_KERNEL);
 	if (precvbuf->purb == NULL)
 		res = _FAIL;
 	precvbuf->pskb = NULL;
diff --git a/drivers/staging/rtl8712/usb_ops_linux.c b/drivers/staging/rtl8712/usb_ops_linux.c
index 7933ea4..509b81a 100644
--- a/drivers/staging/rtl8712/usb_ops_linux.c
+++ b/drivers/staging/rtl8712/usb_ops_linux.c
@@ -48,7 +48,7 @@ struct zero_bulkout_context {
 
 uint r8712_usb_init_intf_priv(struct intf_priv *pintfpriv)
 {
-	pintfpriv->piorw_urb = _usb_alloc_urb(0, GFP_ATOMIC);
+	pintfpriv->piorw_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!pintfpriv->piorw_urb)
 		return _FAIL;
 	sema_init(&(pintfpriv->io_retevt), 0);
diff --git a/drivers/staging/rtl8712/xmit_linux.c b/drivers/staging/rtl8712/xmit_linux.c
index 3efebeb..6b7987d 100644
--- a/drivers/staging/rtl8712/xmit_linux.c
+++ b/drivers/staging/rtl8712/xmit_linux.c
@@ -113,7 +113,7 @@ int r8712_xmit_resource_alloc(struct _adapter *padapter,
 	int i;
 
 	for (i = 0; i < 8; i++) {
-		pxmitbuf->pxmit_urb[i] = _usb_alloc_urb(0, GFP_KERNEL);
+		pxmitbuf->pxmit_urb[i] = usb_alloc_urb(0, GFP_KERNEL);
 		if (pxmitbuf->pxmit_urb[i] == NULL) {
 			printk(KERN_ERR "r8712u: pxmitbuf->pxmit_urb[i]"
 			    " == NULL");
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0005-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Rem.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Rem.pa";
 filename*1="tch"

>From cd36dba91ede39db73a9fb5dc82b9b0dd7811995 Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:08 +0800
Subject: [PATCH 05/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 Removed _usb_submit_urb.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

Replaced (Realtek's) _usb_submit_urb by (linux's own) usb_submit_urb.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/osdep_service.h |    1 -
 drivers/staging/rtl8712/usb_ops_linux.c |    6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 72bb195..4847a68 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -58,7 +58,6 @@
 #include "ethernet.h"
 #include <linux/if_arp.h>
 #include <linux/firmware.h>
-#define   _usb_submit_urb(x, y)     usb_submit_urb(x, y)
 
 struct	__queue	{
 	struct	list_head	queue;
diff --git a/drivers/staging/rtl8712/usb_ops_linux.c b/drivers/staging/rtl8712/usb_ops_linux.c
index 509b81a..54757dd 100644
--- a/drivers/staging/rtl8712/usb_ops_linux.c
+++ b/drivers/staging/rtl8712/usb_ops_linux.c
@@ -187,7 +187,7 @@ void r8712_usb_write_mem(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *wmem)
 	usb_fill_bulk_urb(piorw_urb, pusbd, pipe,
 			  wmem, cnt, usb_write_mem_complete,
 			  pio_queue);
-	status = _usb_submit_urb(piorw_urb, GFP_ATOMIC);
+	status = usb_submit_urb(piorw_urb, GFP_ATOMIC);
 	_down_sema(&pintfpriv->io_retevt);
 }
 
@@ -305,7 +305,7 @@ u32 r8712_usb_read_port(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *rmem)
 				  precvbuf->pbuf, MAX_RECVBUF_SZ,
 				  r8712_usb_read_port_complete,
 				  precvbuf);
-		err = _usb_submit_urb(purb, GFP_ATOMIC);
+		err = usb_submit_urb(purb, GFP_ATOMIC);
 		if ((err) && (err != (-EPERM)))
 			ret = _FAIL;
 	} else
@@ -462,7 +462,7 @@ u32 r8712_usb_write_port(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *wmem)
 			  pxmitframe->mem_addr,
 			  cnt, usb_write_port_complete,
 			  pxmitframe); /* context is xmit_frame */
-	status = _usb_submit_urb(purb, GFP_ATOMIC);
+	status = usb_submit_urb(purb, GFP_ATOMIC);
 	if (!status)
 		ret = _SUCCESS;
 	else
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0006-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Rem.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0006-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Rem.pa";
 filename*1="tch"

>From 1cdb4f423bc84ab0e5db7a273e820c469e8e482c Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:09 +0800
Subject: [PATCH 06/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 Removed unused MSECS.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

MSECS was never used in this driver. So removed.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/osdep_service.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 4847a68..6619560 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -68,7 +68,6 @@ struct	__queue	{
 #define _buffer unsigned char
 #define thread_exit() complete_and_exit(NULL, 0)
 #define _workitem struct work_struct
-#define MSECS(t)        (HZ * ((t) / 1000) + (HZ * ((t) % 1000)) / 1000)
 
 #define _init_queue(pqueue)				\
 	do {						\
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0007-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Red.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0007-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Red.pa";
 filename*1="tch"

>From 1c0d2ef68eceb8afef10d553a36cb057f73a8ed9 Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:10 +0800
Subject: [PATCH 07/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 Redundant NULL check.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

Removed the redundant NULL check in LedControl871x.
As noted by Dan Carpenter, the address of a stack variable is never NULL.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/rtl8712_led.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl8712_led.c b/drivers/staging/rtl8712/rtl8712_led.c
index cb1751e..bac56e5 100644
--- a/drivers/staging/rtl8712/rtl8712_led.c
+++ b/drivers/staging/rtl8712/rtl8712_led.c
@@ -1786,7 +1786,7 @@ void LedControl871x(struct _adapter *padapter, enum LED_CTL_MODE LedAction)
 {
 	struct led_priv	*ledpriv = &(padapter->ledpriv);
 
-	if (ledpriv == NULL || ledpriv->bRegUseLed == false)
+	if (ledpriv->bRegUseLed == false)
 		return;
 	switch (ledpriv->LedStrategy) {
 	case SW_LED_MODE0:
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0008-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Upd.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0008-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Upd.pa";
 filename*1="tch"

>From 559d156c7214779a2630c8d37ef2d76c2e85bcfd Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:11 +0800
Subject: [PATCH 08/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 Updated include directives.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

These are the new include directives for header files.
The following were (somehow!) not explicity in Realtek's, but proved necessary:
"linux/usb.h" is needed for usb_alloc_urb();
"linux/interrupt.h" is needed for tasklet_struct. It was often a nested
include.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/hal_init.c            |    5 ++++
 drivers/staging/rtl8712/osdep_service.h       |   30 +++++-------------------
 drivers/staging/rtl8712/recv_linux.c          |    4 +++
 drivers/staging/rtl8712/rtl8712_cmd.c         |   18 +++++++++++++++
 drivers/staging/rtl8712/rtl871x_cmd.c         |   18 +++++++++++++++
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    9 +++++++
 drivers/staging/rtl8712/rtl871x_security.c    |   15 ++++++++++++
 drivers/staging/rtl8712/usb_intf.c            |    2 +
 drivers/staging/rtl8712/usb_ops_linux.c       |    2 +
 drivers/staging/rtl8712/xmit_linux.c          |    2 +
 10 files changed, 82 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index 1411c7bf..1bd9c37 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -28,6 +28,11 @@
 
 #define _HAL_INIT_C_
 
+#include <linux/usb.h>
+#include <linux/device.h>
+#include <linux/usb/ch9.h>
+#include <linux/firmware.h>
+
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "rtl871x_byteorder.h"
diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 6619560..1ee943a 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -29,35 +29,19 @@
 #define _SUCCESS	1
 #define _FAIL		0
 
-#include "basic_types.h"
+#include <linux/version.h>
 #include <linux/spinlock.h>
+
+#include <linux/interrupt.h>
 #include <linux/semaphore.h>
+#include <linux/sched.h>
 #include <linux/sem.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <net/iw_handler.h>
-#include <linux/proc_fs.h>	/* Necessary because we use the proc fs */
-#include <linux/compiler.h>
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/kref.h>
-#include <linux/skbuff.h>
-#include <linux/usb.h>
-#include <linux/usb/ch9.h>
-#include <linux/io.h>
-#include <linux/circ_buf.h>
-#include <linux/uaccess.h>
-#include <asm/byteorder.h>
-#include <linux/atomic.h>
-#include <linux/wireless.h>
-#include <linux/rtnetlink.h>
-#include "ethernet.h"
-#include <linux/if_arp.h>
-#include <linux/firmware.h>
+#include <linux/proc_fs.h>      /* Necessary because we use the proc fs */
+
+#include "basic_types.h"
 
 struct	__queue	{
 	struct	list_head	queue;
diff --git a/drivers/staging/rtl8712/recv_linux.c b/drivers/staging/rtl8712/recv_linux.c
index 1e5c59b..0e26d5f 100644
--- a/drivers/staging/rtl8712/recv_linux.c
+++ b/drivers/staging/rtl8712/recv_linux.c
@@ -28,11 +28,15 @@
 
 #define _RECV_OSDEP_C_
 
+#include <linux/usb.h>
+
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "wifi.h"
 #include "recv_osdep.h"
 #include "osdep_intf.h"
+#include "ethernet.h"
+#include <linux/if_arp.h>
 #include "usb_ops.h"
 
 /*init os related resource in struct recv_priv*/
diff --git a/drivers/staging/rtl8712/rtl8712_cmd.c b/drivers/staging/rtl8712/rtl8712_cmd.c
index 26c605e..9f6ebc4 100644
--- a/drivers/staging/rtl8712/rtl8712_cmd.c
+++ b/drivers/staging/rtl8712/rtl8712_cmd.c
@@ -28,6 +28,24 @@
 
 #define _RTL8712_CMD_C_
 
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/kref.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/usb.h>
+#include <linux/usb/ch9.h>
+#include <linux/circ_buf.h>
+#include <linux/uaccess.h>
+#include <asm/byteorder.h>
+#include <linux/atomic.h>
+#include <linux/semaphore.h>
+#include <linux/rtnetlink.h>
+
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "recv_osdep.h"
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index ba92762..e188d8d 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -28,6 +28,24 @@
 
 #define _RTL871X_CMD_C_
 
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/kref.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/usb.h>
+#include <linux/usb/ch9.h>
+#include <linux/circ_buf.h>
+#include <linux/uaccess.h>
+#include <asm/byteorder.h>
+#include <linux/atomic.h>
+#include <linux/semaphore.h>
+#include <linux/rtnetlink.h>
+
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "recv_osdep.h"
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index ba70081..ec58b66 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -39,6 +39,15 @@
 #include "rtl871x_ioctl_set.h"
 #include "rtl871x_mp_ioctl.h"
 #include "mlme_osdep.h"
+#include <linux/wireless.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/version.h>
+#include <linux/io.h>
+#include <linux/semaphore.h>
+#include <net/iw_handler.h>
+#include <linux/if_arp.h>
 
 #define RTL_IOCTL_WPA_SUPPLICANT	(SIOCIWFIRSTPRIV + 30)
 
diff --git a/drivers/staging/rtl8712/rtl871x_security.c b/drivers/staging/rtl8712/rtl871x_security.c
index 65321be..7b92927 100644
--- a/drivers/staging/rtl8712/rtl871x_security.c
+++ b/drivers/staging/rtl8712/rtl871x_security.c
@@ -28,6 +28,21 @@
 
 #define  _RTL871X_SECURITY_C_
 
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/kref.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/circ_buf.h>
+#include <linux/uaccess.h>
+#include <asm/byteorder.h>
+#include <linux/atomic.h>
+#include <linux/semaphore.h>
+
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "wifi.h"
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 263a4b5..3447d75 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -28,6 +28,8 @@
 
 #define _HCI_INTF_C_
 
+#include <linux/usb.h>
+
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "recv_osdep.h"
diff --git a/drivers/staging/rtl8712/usb_ops_linux.c b/drivers/staging/rtl8712/usb_ops_linux.c
index 54757dd..b796c6b 100644
--- a/drivers/staging/rtl8712/usb_ops_linux.c
+++ b/drivers/staging/rtl8712/usb_ops_linux.c
@@ -28,6 +28,8 @@
 
 #define _HCI_OPS_OS_C_
 
+#include <linux/usb.h>
+
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "osdep_intf.h"
diff --git a/drivers/staging/rtl8712/xmit_linux.c b/drivers/staging/rtl8712/xmit_linux.c
index 6b7987d..d3535ba 100644
--- a/drivers/staging/rtl8712/xmit_linux.c
+++ b/drivers/staging/rtl8712/xmit_linux.c
@@ -28,6 +28,8 @@
 
 #define _XMIT_OSDEP_C_
 
+#include <linux/usb.h>
+
 #include "osdep_service.h"
 #include "drv_types.h"
 
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0009-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Rem.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0009-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Rem.pa";
 filename*1="tch"

>From a89cce402b114fef758ec705d1ee3a12a9d2f27c Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:12 +0800
Subject: [PATCH 09/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 Removed redundant .mem.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

recv_frame.mem
mp_xmit_frame.mem
mp_xmit_packet.mem were not used, and so are now removed.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/rtl8712_recv.h     |    1 -
 drivers/staging/rtl8712/rtl871x_mp.h       |    1 -
 drivers/staging/rtl8712/rtl871x_mp_ioctl.h |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl8712_recv.h b/drivers/staging/rtl8712/rtl8712_recv.h
index 1d6c9c7..6626c8f 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.h
+++ b/drivers/staging/rtl8712/rtl8712_recv.h
@@ -140,7 +140,6 @@ union recv_frame {
 	union {
 		struct list_head list;
 		struct recv_frame_hdr hdr;
-		addr_t mem[RECVFRAME_HDR_ALIGN>>2];
 	} u;
 };
 
diff --git a/drivers/staging/rtl8712/rtl871x_mp.h b/drivers/staging/rtl8712/rtl871x_mp.h
index a42d4f4..255dc94 100644
--- a/drivers/staging/rtl8712/rtl871x_mp.h
+++ b/drivers/staging/rtl8712/rtl871x_mp.h
@@ -126,7 +126,6 @@ struct mp_xmit_frame {
 	struct urb *pxmit_urb[8];
 	u8 bpending[8];
 	u8 last[8];
-	uint mem[(MAX_MP_XMITBUF_SZ >> 2)];
 };
 
 struct mp_wiparam {
diff --git a/drivers/staging/rtl8712/rtl871x_mp_ioctl.h b/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
index b5ddcb6..1c38a11 100644
--- a/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
+++ b/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
@@ -332,7 +332,6 @@ struct rfintfs_parm {
 
 struct mp_xmit_packet {
 	unsigned int len;
-	unsigned int mem[MAX_MP_XMITBUF_SZ >> 2];
 };
 
 struct psmode_param {
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0010-staging-r8712u-Tracking-kmemleak-false-positives.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0010-staging-r8712u-Tracking-kmemleak-false-positives.patch"

>From a93ee13a642f0ff03c99926bb798560dd6a38ea9 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 4 Sep 2011 03:14:23 +0800
Subject: [PATCH 10/20] staging: r8712u: Tracking kmemleak false positives.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

The frame buffers allocated in _r8712_init_recv_priv() are not tracked
by kmemleak, but they are freed when the driver is unloaded. To help
find any real leaks, these false positives are annotated for kmemleak.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Ali Bahar <ali@internetDog.org>
---
 drivers/staging/rtl8712/rtl871x_recv.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
index aec83dd..7069f06 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.c
+++ b/drivers/staging/rtl8712/rtl871x_recv.c
@@ -28,6 +28,9 @@
 
 #define _RTL871X_RECV_C_
 
+#include <linux/slab.h>
+#include <linux/kmemleak.h>
+
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "recv_osdep.h"
@@ -73,6 +76,7 @@ sint _r8712_init_recv_priv(struct recv_priv *precvpriv,
 					   RXFRAME_ALIGN_SZ);
 	if (precvpriv->pallocated_frame_buf == NULL)
 		return _FAIL;
+	kmemleak_not_leak(precvpriv->pallocated_frame_buf);
 	memset(precvpriv->pallocated_frame_buf, 0, NR_RECVFRAME *
 		sizeof(union recv_frame) + RXFRAME_ALIGN_SZ);
 	precvpriv->precv_frame_buf = precvpriv->pallocated_frame_buf +
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0011-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-No-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0011-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-No-.pa";
 filename*1="tch"

>From c5ff4182e4fa9a0d82542a0960f7860088887471 Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:13 +0800
Subject: [PATCH 11/20] staging: r8712u: Merging Realtek's latest (v2.6.6). No
 power tracking OID.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

The call to oid_rt_pro_set_power_tracking_hdl() is no longer available.
The function's definition remains, though it is currently unused.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/rtl871x_mp_ioctl.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_mp_ioctl.h b/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
index 1c38a11..850143d 100644
--- a/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
+++ b/drivers/staging/rtl8712/rtl871x_mp_ioctl.h
@@ -434,8 +434,7 @@ static struct mp_ioctl_handler mp_ioctl_hdl[] = {
 	{sizeof(struct psmode_param), NULL, 0},/*13*/
 	{sizeof(struct eeprom_rw_param), NULL, 0},/*14*/
 	{sizeof(struct eeprom_rw_param), NULL, 0},/*15*/
-	{sizeof(u8), oid_rt_pro_set_power_tracking_hdl,
-			     OID_RT_PRO_SET_POWER_TRACKING},/*16*/
+	{sizeof(unsigned char), NULL, 0},/*16*/
 	{sizeof(u32), NULL, 0},/*17*/
 	{sizeof(u32), oid_rt_pro_set_continuous_tx_hdl,
 			     OID_RT_PRO_SET_CONTINUOUS_TX},/*18*/
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0012-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-sto.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0012-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-sto.pa";
 filename*1="tch"

>From 319fad2d5e3782f7b97c88cec25f296bb32fa5c0 Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:14 +0800
Subject: [PATCH 12/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 stop_drv_timers moved.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

stop_drv_timers() is now done in r871xu_dev_remove(), not netdev_close().

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/os_intfs.c   |    4 +---
 drivers/staging/rtl8712/usb_intf.c   |    2 ++
 drivers/staging/rtl8712/usb_osintf.h |    1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index a46d4bb..961d6e5 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -261,7 +261,7 @@ static void start_drv_timers(struct _adapter *padapter)
 	_set_timer(&padapter->mlmepriv.wdg_timer, 2000);
 }
 
-static void stop_drv_timers(struct _adapter *padapter)
+void r8712_stop_drv_timers(struct _adapter *padapter)
 {
 	_cancel_timer_ex(&padapter->mlmepriv.assoc_timer);
 	_cancel_timer_ex(&padapter->mlmepriv.sitesurveyctrl.
@@ -468,8 +468,6 @@ static int netdev_close(struct net_device *pnetdev)
 	r8712_free_assoc_resources(padapter);
 	/*s2-4.*/
 	r8712_free_network_queue(padapter);
-	/*Stop driver mlme relation timer*/
-	stop_drv_timers(padapter);
 	/* The interface is no longer Up: */
 	padapter->bup = false;
 	return 0;
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 3447d75..3bcb669 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -622,6 +622,8 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 		}
 		flush_scheduled_work();
 		udelay(1);
+		/*Stop driver mlme relation timer */
+		r8712_stop_drv_timers(padapter);
 		r871x_dev_unload(padapter);
 		r8712_free_drv_sw(padapter);
 	}
diff --git a/drivers/staging/rtl8712/usb_osintf.h b/drivers/staging/rtl8712/usb_osintf.h
index d397a82..d95797aa 100644
--- a/drivers/staging/rtl8712/usb_osintf.h
+++ b/drivers/staging/rtl8712/usb_osintf.h
@@ -42,6 +42,7 @@ uint rtl8712_hal_deinit(struct _adapter *padapter);
 void rtl871x_intf_stop(struct _adapter *padapter);
 void r871x_dev_unload(struct _adapter *padapter);
 void r8712_stop_drv_threads(struct _adapter *padapter);
+void r8712_stop_drv_timers(struct _adapter *padapter);
 u8 r8712_init_drv_sw(struct _adapter *padapter);
 u8 r8712_free_drv_sw(struct _adapter *padapter);
 struct net_device *r8712_init_netdev(void);
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0013-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Use.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0013-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Use.pa";
 filename*1="tch"

>From 99f832092dafb731742357e83918358fd23fb8d5 Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:15 +0800
Subject: [PATCH 13/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 Use stack, not malloc.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

translate_scan() now uses the stack for some variables, instead of mallocing.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index ec58b66..4522553 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -169,10 +169,6 @@ static inline char *translate_scan(struct _adapter *padapter,
 	struct iw_event iwe;
 	struct ieee80211_ht_cap *pht_capie;
 	char *current_val;
-	u8 *buf = (u8 *)_malloc(pnetwork->network.IELength * 2);
-	u8 *wpa_ie = (u8 *)_malloc(255);
-	u8 *rsn_ie = (u8 *)_malloc(255);
-	u8 *wps_ie = (u8 *)_malloc(MAX_WPS_IE_LEN);
 	s8 *p;
 	u32 i = 0, ht_ielen = 0;
 	u16	cap, ht_cap = false, mcs_rate;
@@ -289,6 +285,8 @@ static inline char *translate_scan(struct _adapter *padapter,
 		start = current_val;
 	/* parsing WPA/WPA2 IE */
 	{
+		u8 buf[MAX_WPA_IE_LEN];
+		u8 wpa_ie[255], rsn_ie[255];
 		u16 wpa_len = 0, rsn_len = 0;
 		int n;
 		sint out_len = 0;
@@ -339,6 +337,7 @@ static inline char *translate_scan(struct _adapter *padapter,
 	}
 
 	{ /* parsing WPS IE */
+		u8 wps_ie[512];
 		uint wps_ielen;
 
 		if (r8712_get_wps_ie(pnetwork->network.IEs,
@@ -363,10 +362,6 @@ static inline char *translate_scan(struct _adapter *padapter,
 	iwe.u.qual.noise = 0; /* noise level */
 	start = iwe_stream_add_event(info, start, stop, &iwe, IW_EV_QUAL_LEN);
 	/* how to translate rssi to ?% */
-	kfree(buf);
-	kfree(wpa_ie);
-	kfree(rsn_ie);
-	kfree(wps_ie);
 	return start;
 }
 
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0014-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Tx-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0014-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Tx-.pa";
 filename*1="tch"

>From ddf302586efd871e1aed91e097825d13d8e1b211 Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:16 +0800
Subject: [PATCH 14/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 Tx-code refactoring.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

Refactor the TX code to prepare for aggregation.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/rtl8712_xmit.c |   48 ++++++++++++++++----------------
 drivers/staging/rtl8712/rtl871x_xmit.c |   17 +++++++++--
 drivers/staging/rtl8712/rtl871x_xmit.h |    5 +++
 3 files changed, 43 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl8712_xmit.c b/drivers/staging/rtl8712/rtl8712_xmit.c
index 88a1504..c1e4784 100644
--- a/drivers/staging/rtl8712/rtl8712_xmit.c
+++ b/drivers/staging/rtl8712/rtl8712_xmit.c
@@ -423,31 +423,31 @@ int r8712_xmitframe_complete(struct _adapter *padapter,
 		if (!pxmitbuf)
 			return false;
 	}
-	do {
-		pxmitframe = dequeue_xframe_ex(pxmitpriv, phwxmits, hwentry);
-		if (pxmitframe) {
-			pxmitframe->pxmitbuf = pxmitbuf;
-			pxmitframe->pxmit_urb[0] = pxmitbuf->pxmit_urb[0];
-			pxmitframe->buf_addr = pxmitbuf->pbuf;
-			if (pxmitframe->frame_tag == DATA_FRAMETAG) {
-				if (pxmitframe->attrib.priority <= 15)
-					res = r8712_xmitframe_coalesce(padapter,
-					      pxmitframe->pkt, pxmitframe);
-				/* always return ndis_packet after
-				 *  r8712_xmitframe_coalesce */
-				r8712_xmit_complete(padapter, pxmitframe);
-			}
-			if (res == _SUCCESS)
-				dump_xframe(padapter, pxmitframe);
-			else
-				r8712_free_xmitframe_ex(pxmitpriv, pxmitframe);
-			xcnt++;
-		} else {
-			r8712_free_xmitbuf(pxmitpriv, pxmitbuf);
-			return false;
+	/* 1st frame dequeued */
+	pxmitframe = dequeue_xframe_ex(pxmitpriv, phwxmits, hwentry);
+	/* need to remember the 1st frame */
+	if (pxmitframe != NULL) {
+
+
+		xmitframe_xmitbuf_attach(pxmitframe, pxmitbuf);
+		if (pxmitframe->frame_tag == DATA_FRAMETAG) {
+			if (pxmitframe->attrib.priority <= 15)
+				res = r8712_xmitframe_coalesce(padapter,
+					pxmitframe->pkt, pxmitframe);
+			/* always return ndis_packet after
+			 * r8712_xmitframe_coalesce */
+			r8712_xmit_complete(padapter, pxmitframe);
 		}
-		break;
-	} while (0);
+		if (res == _SUCCESS)
+			dump_xframe(padapter, pxmitframe);
+		else
+			r8712_free_xmitframe_ex(pxmitpriv, pxmitframe);
+		xcnt++;
+
+	} else { /* pxmitframe == NULL && p2ndxmitframe == NULL */
+		r8712_free_xmitbuf(pxmitpriv, pxmitbuf);
+		return false;
+	}
 	return true;
 }
 
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index ccf0891..073493b 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -1011,6 +1011,19 @@ static void init_hwxmits(struct hw_xmit *phwxmit, sint entry)
 	}
 }
 
+void xmitframe_xmitbuf_attach(struct xmit_frame *pxmitframe,
+			struct xmit_buf *pxmitbuf)
+{
+	/* pxmitbuf attach to pxmitframe */
+	pxmitframe->pxmitbuf = pxmitbuf;
+	/* urb and irp connection */
+	pxmitframe->pxmit_urb[0] = pxmitbuf->pxmit_urb[0];
+	/* buffer addr assoc */
+	pxmitframe->buf_addr = pxmitbuf->pbuf;
+	/* pxmitframe attach to pxmitbuf */
+	pxmitbuf->priv_data = pxmitframe;
+}
+
 /*
  * tx_action == 0 == no frames to transmit
  * tx_action > 0 ==> we have frames to transmit
@@ -1042,9 +1055,7 @@ int r8712_pre_xmit(struct _adapter *padapter, struct xmit_frame *pxmitframe)
 	} else { /*dump packet directly*/
 		spin_unlock_irqrestore(&pxmitpriv->lock, irqL);
 		ret = true;
-		pxmitframe->pxmitbuf = pxmitbuf;
-		pxmitframe->pxmit_urb[0] = pxmitbuf->pxmit_urb[0];
-		pxmitframe->buf_addr = pxmitbuf->pbuf;
+		xmitframe_xmitbuf_attach(pxmitframe, pxmitbuf);
 		r8712_xmit_direct(padapter, pxmitframe);
 	}
 	return ret;
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.h b/drivers/staging/rtl8712/rtl871x_xmit.h
index 6304100..8198778 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.h
+++ b/drivers/staging/rtl8712/rtl871x_xmit.h
@@ -135,7 +135,9 @@ struct xmit_buf {
 
 	u8 *pallocated_buf;
 	u8 *pbuf;
+	void *priv_data;
 	struct urb *pxmit_urb[8];
+	u32 aggr_nr;
 };
 
 struct xmit_frame {
@@ -280,6 +282,9 @@ int r8712_xmit_enqueue(struct _adapter *padapter,
 int r8712_xmit_direct(struct _adapter *padapter, struct xmit_frame *pxmitframe);
 void r8712_xmit_bh(void *priv);
 
+void xmitframe_xmitbuf_attach(struct xmit_frame *pxmitframe,
+			struct xmit_buf *pxmitbuf);
+
 #include "rtl8712_xmit.h"
 
 #endif	/*_RTL871X_XMIT_H_*/
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0015-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Rew.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0015-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Rew.pa";
 filename*1="tch"

>From df217160d2ce7ea74d9707dddd48ce84831aaac5 Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:17 +0800
Subject: [PATCH 15/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 Rework efuse data handling.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

Rework efuse data handling.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/rtl8712_efuse.c |   75 +++++++++++++++++--------------
 1 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl8712_efuse.c b/drivers/staging/rtl8712/rtl8712_efuse.c
index 1dc12b7..b08e9a2 100644
--- a/drivers/staging/rtl8712/rtl8712_efuse.c
+++ b/drivers/staging/rtl8712/rtl8712_efuse.c
@@ -307,21 +307,25 @@ static u8 fix_header(struct _adapter *padapter, u8 header, u16 header_addr)
 			continue;
 		}
 		for (i = 0; i < PGPKG_MAX_WORDS; i++) {
-			if (BIT(i) & word_en)
-				continue;
-			if (!(BIT(i) & pkt.word_en)) {
-				if (efuse_one_byte_read(padapter, addr,
-				    &value) == true)
-					pkt.data[i*2] = value;
-				else
-					return false;
-				if (efuse_one_byte_read(padapter, addr + 1,
-				    &value) == true)
-					pkt.data[i*2 + 1] = value;
-				else
-					return false;
+			if (BIT(i) & word_en) {
+				if (BIT(i) & pkt.word_en) {
+					if (efuse_one_byte_read(
+							padapter, addr,
+							&value) == true)
+						pkt.data[i*2] = value;
+					else
+						return false;
+					if (efuse_one_byte_read(
+							padapter,
+							addr + 1,
+							&value) == true)
+						pkt.data[i*2 + 1] =
+							value;
+					else
+						return false;
+				}
+				addr += 2;
 			}
-			addr += 2;
 		}
 	}
 	if (addr != header_addr)
@@ -329,26 +333,29 @@ static u8 fix_header(struct _adapter *padapter, u8 header, u16 header_addr)
 	addr++;
 	/* fill original data */
 	for (i = 0; i < PGPKG_MAX_WORDS; i++) {
-		if (BIT(i) & pkt.word_en)
-			continue;
-		efuse_one_byte_write(padapter, addr, pkt.data[i*2]);
-		efuse_one_byte_write(padapter, addr+1, pkt.data[i*2 + 1]);
-		/* additional check */
-		if (efuse_one_byte_read(padapter, addr, &value) == false)
-			ret = false;
-		else if (pkt.data[i*2] != value) {
-			ret = false;
-			if (0xFF == value) /* write again */
-				efuse_one_byte_write(padapter, addr,
-						     pkt.data[i * 2]);
-		}
-		if (efuse_one_byte_read(padapter, addr+1, &value) == false)
-			ret = false;
-		else if (pkt.data[i*2 + 1] != value) {
-			ret = false;
-			if (0xFF == value) /* write again */
-				efuse_one_byte_write(padapter, addr+1,
-						     pkt.data[i*2 + 1]);
+		if (BIT(i) & pkt.word_en) {
+			efuse_one_byte_write(padapter, addr, pkt.data[i*2]);
+			efuse_one_byte_write(padapter, addr+1,
+					pkt.data[i*2 + 1]);
+			/* additional check */
+			if (efuse_one_byte_read(padapter, addr, &value)
+				== false)
+				ret = false;
+			else if (pkt.data[i*2] != value) {
+				ret = false;
+				if (0xFF == value) /* write again */
+					efuse_one_byte_write(padapter, addr,
+							pkt.data[i * 2]);
+			}
+			if (efuse_one_byte_read(padapter, addr+1, &value) ==
+				false)
+				ret = false;
+			else if (pkt.data[i*2 + 1] != value) {
+				ret = false;
+				if (0xFF == value) /* write again */
+					efuse_one_byte_write(padapter, addr+1,
+							pkt.data[i*2 + 1]);
+			}
 		}
 		addr += 2;
 	}
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0016-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-tx-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0016-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-tx-.pa";
 filename*1="tch"

>From 4048212b282b176eb5550e87c8ea326ede61b80f Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:18 +0800
Subject: [PATCH 16/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 tx: NULL _in_ spin lock.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

In transmit path, r8712_free_xmitframe(), the pkt pointer is now
NULLed _within_ the spin lock.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/drv_types.h    |    3 +++
 drivers/staging/rtl8712/rtl871x_xmit.c |   14 +++++++++-----
 drivers/staging/rtl8712/xmit_linux.c   |   21 ++++++++++++++++++++-
 drivers/staging/rtl8712/xmit_osdep.h   |    1 +
 4 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8712/drv_types.h b/drivers/staging/rtl8712/drv_types.h
index 6e16d58..9b5d771 100644
--- a/drivers/staging/rtl8712/drv_types.h
+++ b/drivers/staging/rtl8712/drv_types.h
@@ -181,6 +181,9 @@ struct _adapter {
 	struct net_device_stats stats;
 	struct iw_statistics iwstats;
 	int pid; /*process id from UI*/
+	_workitem wkFilterRxFF0;
+	u8 blnEnableRxFF0Filter;
+	spinlock_t lockRxFF0Filter;
 };
 
 static inline u8 *myid(struct eeprom_priv *peepriv)
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index 073493b..8bbdee7 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -152,11 +152,12 @@ sint _r8712_init_xmit_priv(struct xmit_priv *pxmitpriv,
 		pxmitbuf++;
 	}
 	pxmitpriv->free_xmitbuf_cnt = NR_XMITBUFF;
+	_init_workitem(&padapter->wkFilterRxFF0, r8712_SetFilter, padapter);
 	alloc_hwxmits(padapter);
 	init_hwxmits(pxmitpriv->hwxmits, pxmitpriv->hwxmit_entry);
 	tasklet_init(&pxmitpriv->xmit_tasklet,
-	     (void(*)(addr_t))r8712_xmit_bh,
-	     (addr_t)padapter);
+		(void(*)(unsigned long))r8712_xmit_bh,
+		(unsigned long)padapter);
 	return _SUCCESS;
 }
 
@@ -612,7 +613,7 @@ sint r8712_xmitframe_coalesce(struct _adapter *padapter, _pkt *pkt,
 	if (make_wlanhdr(padapter, mem_start, pattrib) == _FAIL)
 		return _FAIL;
 	_r8712_open_pktfile(pkt, &pktfile);
-	_r8712_pktfile_read(&pktfile, NULL, pattrib->pkt_hdrlen);
+	_r8712_pktfile_read(&pktfile, NULL, (uint) pattrib->pkt_hdrlen);
 	if (check_fwstate(pmlmepriv, WIFI_MP_STATE) == true) {
 		/* truncate TXDESC_SIZE bytes txcmd if at mp mode for 871x */
 		if (pattrib->ether_type == 0x8712) {
@@ -826,13 +827,16 @@ void r8712_free_xmitframe(struct xmit_priv *pxmitpriv,
 	unsigned long irqL;
 	struct  __queue *pfree_xmit_queue = &pxmitpriv->free_xmit_queue;
 	struct _adapter *padapter = pxmitpriv->adapter;
+	struct sk_buff *pndis_pkt = NULL;
 
 	if (pxmitframe == NULL)
 		return;
-	if (pxmitframe->pkt)
-		r8712_xmit_complete(padapter, pxmitframe);
 	spin_lock_irqsave(&pfree_xmit_queue->lock, irqL);
 	list_delete(&pxmitframe->list);
+	if (pxmitframe->pkt) {
+		pndis_pkt = pxmitframe->pkt;
+		pxmitframe->pkt = NULL;
+	}
 	list_insert_tail(&pxmitframe->list, get_list_head(pfree_xmit_queue));
 	pxmitpriv->free_xmitframe_cnt++;
 	spin_unlock_irqrestore(&pfree_xmit_queue->lock, irqL);
diff --git a/drivers/staging/rtl8712/xmit_linux.c b/drivers/staging/rtl8712/xmit_linux.c
index d3535ba..c970362 100644
--- a/drivers/staging/rtl8712/xmit_linux.c
+++ b/drivers/staging/rtl8712/xmit_linux.c
@@ -44,7 +44,6 @@
 
 static uint remainder_len(struct pkt_file *pfile)
 {
-	/* Kovich: Need to extend the buf_len to 64 bit ?(unsigned long long) */
 	return (uint)(pfile->buf_len - ((addr_t)(pfile->cur_addr) -
 	       (addr_t)(pfile->buf_start)));
 }
@@ -109,6 +108,26 @@ void r8712_set_qos(struct pkt_file *ppktfile, struct pkt_attrib *pattrib)
 	pattrib->subtype = WIFI_QOS_DATA_TYPE;
 }
 
+void r8712_SetFilter(struct work_struct *work)
+{
+	struct _adapter *padapter = container_of(work, struct _adapter,
+						wkFilterRxFF0);
+	u8  oldvalue = 0x00, newvalue = 0x00;
+	unsigned long irqL;
+
+	oldvalue = r8712_read8(padapter, 0x117);
+	newvalue = oldvalue & 0xfe;
+	r8712_write8(padapter, 0x117, newvalue);
+
+	spin_lock_irqsave(&padapter->lockRxFF0Filter, irqL);
+	padapter->blnEnableRxFF0Filter = 1;
+	spin_unlock_irqrestore(&padapter->lockRxFF0Filter, irqL);
+	do {
+		msleep(100);
+	} while (padapter->blnEnableRxFF0Filter == 1);
+	r8712_write8(padapter, 0x117, oldvalue);
+}
+
 int r8712_xmit_resource_alloc(struct _adapter *padapter,
 			      struct xmit_buf *pxmitbuf)
 {
diff --git a/drivers/staging/rtl8712/xmit_osdep.h b/drivers/staging/rtl8712/xmit_osdep.h
index 19f6f3c..8eba7ca 100644
--- a/drivers/staging/rtl8712/xmit_osdep.h
+++ b/drivers/staging/rtl8712/xmit_osdep.h
@@ -47,6 +47,7 @@ struct xmit_frame;
 struct xmit_buf;
 
 int r8712_xmit_entry(_pkt *pkt, struct  net_device *pnetdev);
+void r8712_SetFilter(struct work_struct *work);
 int r8712_xmit_resource_alloc(struct _adapter *padapter,
 			   struct xmit_buf *pxmitbuf);
 void r8712_xmit_resource_free(struct _adapter *padapter,
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0017-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-New.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0017-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-New.pa";
 filename*1="tch"

>From 7bf584c5546a30c062d7b0c8519cd13f6206b4b0 Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:19 +0800
Subject: [PATCH 17/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 New decl's and defines.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

Removed unnecessary casts in kfree calls.
A few new types, defines and prototypes.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/rtl8712_cmd.h |   62 +++++++++++++++++++++++++++++++++
 drivers/staging/rtl8712/rtl871x_cmd.c |   13 ++++++-
 drivers/staging/rtl8712/rtl871x_cmd.h |    4 ++
 3 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl8712_cmd.h b/drivers/staging/rtl8712/rtl8712_cmd.h
index a4eecc6..766a646 100644
--- a/drivers/staging/rtl8712/rtl8712_cmd.h
+++ b/drivers/staging/rtl8712/rtl8712_cmd.h
@@ -26,9 +26,15 @@
 #ifndef __RTL8712_CMD_H_
 #define __RTL8712_CMD_H_
 
+#define CMD_HDR_SZ      8
+
 u8 r8712_fw_cmd(struct _adapter *pAdapter, u32 cmd);
 void r8712_fw_cmd_data(struct _adapter *pAdapter, u32 *value, u8 flag);
 
+struct cmd_hdr {
+	u32 cmd_dw0;
+	u32 cmd_dw1;
+};
 
 enum rtl8712_h2c_cmd {
 	GEN_CMD_CODE(_Read_MACREG),	/*0*/
@@ -97,6 +103,40 @@ enum rtl8712_h2c_cmd {
 	GEN_CMD_CODE(_SetPowerTracking),
 	GEN_CMD_CODE(_AMSDU_TO_AMPDU), /*57*/
 	GEN_CMD_CODE(_SetMacAddress), /*58*/
+
+	GEN_CMD_CODE(_DisconnectCtrl), /*59*/
+	GEN_CMD_CODE(_SetChannelPlan), /*60*/
+	GEN_CMD_CODE(_DisconnectCtrlEx), /*61*/
+
+	/* To do, modify these h2c cmd, add or delete */
+	GEN_CMD_CODE(_GetH2cLbk) ,
+
+	/* WPS extra IE */
+	GEN_CMD_CODE(_SetProbeReqExtraIE) ,
+	GEN_CMD_CODE(_SetAssocReqExtraIE) ,
+	GEN_CMD_CODE(_SetProbeRspExtraIE) ,
+	GEN_CMD_CODE(_SetAssocRspExtraIE) ,
+
+	/* the following is driver will do */
+	GEN_CMD_CODE(_GetCurDataRate) ,
+
+	GEN_CMD_CODE(_GetTxRetrycnt),  /* to record times that Tx retry to
+					* transmmit packet after association
+					*/
+	GEN_CMD_CODE(_GetRxRetrycnt),  /* to record total number of the
+					* received frame with ReTry bit set in
+					* the WLAN header
+					*/
+
+	GEN_CMD_CODE(_GetBCNOKcnt),
+	GEN_CMD_CODE(_GetBCNERRcnt),
+	GEN_CMD_CODE(_GetCurTxPwrLevel),
+
+	GEN_CMD_CODE(_SetDIG),
+	GEN_CMD_CODE(_SetRA),
+	GEN_CMD_CODE(_SetPT),
+	GEN_CMD_CODE(_ReadTSSI),
+
 	MAX_H2CCMD
 };
 
@@ -176,6 +216,28 @@ static struct _cmd_callback	cmd_callback[] = {
 	{GEN_CMD_CODE(_SetPowerTracking), NULL},
 	{GEN_CMD_CODE(_AMSDU_TO_AMPDU), NULL}, /*57*/
 	{GEN_CMD_CODE(_SetMacAddress), NULL}, /*58*/
+
+	{GEN_CMD_CODE(_DisconnectCtrl), NULL}, /*59*/
+	{GEN_CMD_CODE(_SetChannelPlan), NULL}, /*60*/
+	{GEN_CMD_CODE(_DisconnectCtrlEx), NULL}, /*61*/
+
+	/* To do, modify these h2c cmd, add or delete */
+	{GEN_CMD_CODE(_GetH2cLbk), NULL},
+
+	{_SetProbeReqExtraIE_CMD_, NULL},
+	{_SetAssocReqExtraIE_CMD_, NULL},
+	{_SetProbeRspExtraIE_CMD_, NULL},
+	{_SetAssocRspExtraIE_CMD_, NULL},
+	{_GetCurDataRate_CMD_, NULL},
+	{_GetTxRetrycnt_CMD_, NULL},
+	{_GetRxRetrycnt_CMD_, NULL},
+	{_GetBCNOKcnt_CMD_, NULL},
+	{_GetBCNERRcnt_CMD_, NULL},
+	{_GetCurTxPwrLevel_CMD_, NULL},
+	{_SetDIG_CMD_, NULL},
+	{_SetRA_CMD_, NULL},
+	{_SetPT_CMD_, NULL},
+	{GEN_CMD_CODE(_ReadTSSI), &r8712_readtssi_cmdrsp_callback}
 };
 #endif
 
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index e188d8d..c416ee3 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -371,8 +371,17 @@ u8 r8712_getrfreg_cmd(struct _adapter *padapter, u8 offset, u8 *pval)
 void r8712_getbbrfreg_cmdrsp_callback(struct _adapter *padapter,
 				      struct cmd_obj *pcmd)
 {
-	kfree((unsigned char *) pcmd->parmbuf);
-	kfree((unsigned char *) pcmd);
+	kfree(pcmd->parmbuf);
+	kfree(pcmd);
+	padapter->mppriv.workparam.bcompleted = true;
+}
+
+void r8712_readtssi_cmdrsp_callback(struct _adapter *padapter,
+				struct cmd_obj *pcmd)
+{
+	kfree(pcmd->parmbuf);
+	kfree(pcmd);
+
 	padapter->mppriv.workparam.bcompleted = true;
 }
 
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.h b/drivers/staging/rtl8712/rtl871x_cmd.h
index 25ef848..2aab78a 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.h
+++ b/drivers/staging/rtl8712/rtl871x_cmd.h
@@ -728,10 +728,14 @@ void r8712_createbss_cmd_callback(struct _adapter *padapter,
 				  struct cmd_obj *pcmd);
 void r8712_getbbrfreg_cmdrsp_callback(struct _adapter *padapter,
 				      struct cmd_obj *pcmd);
+void r8712_readtssi_cmdrsp_callback(struct _adapter *padapter,
+				struct cmd_obj *pcmd);
 void r8712_setstaKey_cmdrsp_callback(struct _adapter  *padapter,
 				     struct cmd_obj *pcmd);
 void r8712_setassocsta_cmdrsp_callback(struct _adapter  *padapter,
 				       struct cmd_obj *pcmd);
+u8 r8712_disconnectCtrlEx_cmd(struct _adapter *adapter, u32 enableDrvCtrl,
+			u32 tryPktCnt, u32 tryPktInterval, u32 firstStageTO);
 
 struct _cmd_callback {
 	u32	cmd_code;
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0018-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Var.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0018-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Var.pa";
 filename*1="tch"

>From 98ebdc5431e4979a07d55cb670a3a4ccc2f6750d Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:20 +0800
Subject: [PATCH 18/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 Various fixes.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

passive_mode added to private ioctls.
New private ioctls added for RSSI, link speed, mac address, scan type,
and DCE-D.
In r8711_wx_get_scan(), we now sleep only 100 times, instead of 1000.
In r8711_wx_set_essid(), added a check for Ad-Hoc state.
In r8711_wx_get_rate(), added a check for RTL8712_RF_2T2R RF type.
Added Set chplan.
In r871x_get_wireless_stats(), updated the mechanism for displaying
link quality.
Added SetDIG and SetRA commands.
r8712_joinbss_cmd() no longer checks for Ad-Hoc mode.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/rtl871x_cmd.c         |  111 +++++++++++++++++--
 drivers/staging/rtl8712/rtl871x_cmd.h         |   48 ++++++++-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |  144 +++++++++++++++++++++++-
 drivers/staging/rtl8712/rtl871x_mlme.h        |    3 +-
 4 files changed, 283 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index c416ee3..2d8f48c 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -277,6 +277,28 @@ u8 r8712_setdatarate_cmd(struct _adapter *padapter, u8 *rateset)
 	return _SUCCESS;
 }
 
+u8 r8712_set_chplan_cmd(struct _adapter *padapter, int chplan)
+{
+	struct cmd_obj *ph2c;
+	struct SetChannelPlan_param *psetchplanpara;
+	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
+
+	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	if (ph2c == NULL)
+		return _FAIL;
+	psetchplanpara = (struct SetChannelPlan_param *)
+		_malloc(sizeof(struct SetChannelPlan_param));
+	if (psetchplanpara == NULL) {
+		kfree((u8 *) ph2c);
+		return _FAIL;
+	}
+	init_h2fwcmd_w_parm_no_rsp(ph2c, psetchplanpara,
+				GEN_CMD_CODE(_SetChannelPlan));
+	psetchplanpara->ChannelPlan = chplan;
+	r8712_enqueue_cmd(pcmdpriv, ph2c);
+	return _SUCCESS;
+}
+
 u8 r8712_setbasicrate_cmd(struct _adapter *padapter, u8 *rateset)
 {
 	struct cmd_obj *ph2c;
@@ -303,20 +325,62 @@ u8 r8712_setbasicrate_cmd(struct _adapter *padapter, u8 *rateset)
 u8 r8712_setptm_cmd(struct _adapter *padapter, u8 type)
 {
 	struct cmd_obj		*ph2c;
-	struct PT_param		*pptparm;
+	struct writePTM_parm	*pwriteptmparm;
 	struct cmd_priv		*pcmdpriv = &padapter->cmdpriv;
 
 	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
 	if (ph2c == NULL)
 		return _FAIL;
-	pptparm = (struct PT_param *)_malloc(sizeof(struct PT_param));
-	if (pptparm == NULL) {
+	pwriteptmparm = (struct writePTM_parm *)
+		_malloc(sizeof(struct writePTM_parm));
+	if (pwriteptmparm == NULL) {
 		kfree((u8 *) ph2c);
 		return _FAIL;
 	}
-	init_h2fwcmd_w_parm_no_rsp(ph2c, pptparm,
-				   GEN_CMD_CODE(_SetPowerTracking));
-	pptparm->PT_En = type;
+	init_h2fwcmd_w_parm_no_rsp(ph2c, pwriteptmparm, GEN_CMD_CODE(_SetPT));
+	pwriteptmparm->type = type;
+	r8712_enqueue_cmd(pcmdpriv, ph2c);
+	return _SUCCESS;
+}
+
+u8 r8712_setfwdig_cmd(struct _adapter *padapter, u8 type)
+{
+	struct cmd_obj *ph2c;
+	struct writePTM_parm *pwriteptmparm;
+	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
+
+	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	if (ph2c == NULL)
+		return _FAIL;
+	pwriteptmparm = (struct writePTM_parm *)
+		_malloc(sizeof(struct setdig_parm));
+	if (pwriteptmparm == NULL) {
+		kfree((u8 *) ph2c);
+		return _FAIL;
+	}
+	init_h2fwcmd_w_parm_no_rsp(ph2c, pwriteptmparm, GEN_CMD_CODE(_SetDIG));
+	pwriteptmparm->type = type;
+	r8712_enqueue_cmd(pcmdpriv, ph2c);
+	return _SUCCESS;
+}
+
+u8 r8712_setfwra_cmd(struct _adapter *padapter, u8 type)
+{
+	struct cmd_obj *ph2c;
+	struct writePTM_parm *pwriteptmparm;
+	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
+
+	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	if (ph2c == NULL)
+		return _FAIL;
+	pwriteptmparm = (struct writePTM_parm *)
+		_malloc(sizeof(struct setra_parm));
+	if (pwriteptmparm == NULL) {
+		kfree((u8 *) ph2c);
+		return _FAIL;
+	}
+	init_h2fwcmd_w_parm_no_rsp(ph2c, pwriteptmparm, GEN_CMD_CODE(_SetRA));
+	pwriteptmparm->type = type;
 	r8712_enqueue_cmd(pcmdpriv, ph2c);
 	return _SUCCESS;
 }
@@ -512,12 +576,6 @@ u8 r8712_joinbss_cmd(struct _adapter  *padapter, struct wlan_network *pnetwork)
 						&psecnetwork->IEs[0],
 						pnetwork->network.IELength,
 						&psecnetwork->IELength);
-			if (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE))
-				r8712_add_ht_addt_info(padapter,
-						&pnetwork->network.IEs[0],
-						&psecnetwork->IEs[0],
-						pnetwork->network.IELength,
-						&psecnetwork->IELength);
 		}
 	}
 	psecuritypriv->supplicant_ie[0] = (u8)psecnetwork->IELength;
@@ -950,3 +1008,32 @@ void r8712_setassocsta_cmdrsp_callback(struct _adapter *padapter,
 	spin_unlock_irqrestore(&pmlmepriv->lock, irqL);
 	r8712_free_cmd_obj(pcmd);
 }
+
+u8 r8712_disconnectCtrlEx_cmd(struct _adapter *adapter, u32 enableDrvCtrl,
+			u32 tryPktCnt, u32 tryPktInterval, u32 firstStageTO)
+{
+	struct cmd_obj *ph2c;
+	struct DisconnectCtrlEx_param *param;
+	struct cmd_priv *pcmdpriv = &adapter->cmdpriv;
+
+	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	if (ph2c == NULL)
+		return _FAIL;
+	param = (struct DisconnectCtrlEx_param *)
+		_malloc(sizeof(struct DisconnectCtrlEx_param));
+	if (param == NULL) {
+		kfree((unsigned char *) ph2c);
+		return _FAIL;
+	}
+	memset(param, 0, sizeof(struct DisconnectCtrlEx_param));
+
+	param->EnableDrvCtrl = (unsigned char)enableDrvCtrl;
+	param->TryPktCnt = (unsigned char)tryPktCnt;
+	param->TryPktInterval = (unsigned char)tryPktInterval;
+	param->FirstStageTO = (unsigned int)firstStageTO;
+
+	init_h2fwcmd_w_parm_no_rsp(ph2c, param,
+				GEN_CMD_CODE(_DisconnectCtrlEx));
+	r8712_enqueue_cmd(pcmdpriv, ph2c);
+	return _SUCCESS;
+}
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.h b/drivers/staging/rtl8712/rtl871x_cmd.h
index 2aab78a..757ebf7 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.h
+++ b/drivers/staging/rtl8712/rtl871x_cmd.h
@@ -320,6 +320,35 @@ struct setdatarate_parm {
 	u8	datarates[NumRates];
 };
 
+enum _RT_CHANNEL_DOMAIN {
+	RT_CHANNEL_DOMAIN_FCC = 0,
+	RT_CHANNEL_DOMAIN_IC = 1,
+	RT_CHANNEL_DOMAIN_ETSI = 2,
+	RT_CHANNEL_DOMAIN_SPAIN = 3,
+	RT_CHANNEL_DOMAIN_FRANCE = 4,
+	RT_CHANNEL_DOMAIN_MKK = 5,
+	RT_CHANNEL_DOMAIN_MKK1 = 6,
+	RT_CHANNEL_DOMAIN_ISRAEL = 7,
+	RT_CHANNEL_DOMAIN_TELEC = 8,
+
+	/* Be compatible with old channel plan. No good! */
+	RT_CHANNEL_DOMAIN_MIC = 9,
+	RT_CHANNEL_DOMAIN_GLOBAL_DOAMIN = 10,
+	RT_CHANNEL_DOMAIN_WORLD_WIDE_13 = 11,
+	RT_CHANNEL_DOMAIN_TELEC_NETGEAR = 12,
+
+	RT_CHANNEL_DOMAIN_NCC = 13,
+	RT_CHANNEL_DOMAIN_5G = 14,
+	RT_CHANNEL_DOMAIN_5G_40M = 15,
+ /*===== Add new channel plan above this line===============*/
+	RT_CHANNEL_DOMAIN_MAX,
+};
+
+
+struct SetChannelPlan_param {
+	enum _RT_CHANNEL_DOMAIN ChannelPlan;
+};
+
 /*
 Caller Mode: Any
 
@@ -392,6 +421,10 @@ struct writeBB_parm {
 	u8	value;
 };
 
+struct writePTM_parm {
+	u8	type;
+};
+
 struct readRF_parm {
 	u8	offset;
 };
@@ -671,9 +704,14 @@ struct SetChannel_parm {
 	u32 curr_ch;
 };
 
-/*H2C Handler index: 56 */
-struct PT_param {
-	u8 PT_En;
+/*H2C Handler index: 61 */
+struct DisconnectCtrlEx_param {
+	/* MAXTIME = (2 * FirstStageTO) + (TryPktCnt * TryPktInterval) */
+	unsigned char EnableDrvCtrl;
+	unsigned char TryPktCnt;
+	unsigned char TryPktInterval; /* Unit: ms */
+	unsigned char rsvd;
+	unsigned int  FirstStageTO; /* Unit: ms */
 };
 
 #define GEN_CMD_CODE(cmd)	cmd ## _CMD_
@@ -709,13 +747,17 @@ u8 r8712_disassoc_cmd(struct _adapter *padapter);
 u8 r8712_setopmode_cmd(struct _adapter *padapter,
 		 enum NDIS_802_11_NETWORK_INFRASTRUCTURE networktype);
 u8 r8712_setdatarate_cmd(struct _adapter *padapter, u8 *rateset);
+u8 r8712_set_chplan_cmd(struct _adapter  *padapter, int chplan);
 u8 r8712_setbasicrate_cmd(struct _adapter *padapter, u8 *rateset);
 u8 r8712_getrfreg_cmd(struct _adapter *padapter, u8 offset, u8 * pval);
 u8 r8712_setrfintfs_cmd(struct _adapter *padapter, u8 mode);
 u8 r8712_setrfreg_cmd(struct _adapter  *padapter, u8 offset, u32 val);
 u8 r8712_setrttbl_cmd(struct _adapter  *padapter,
 		      struct setratable_parm *prate_table);
+u8 r8712_gettssi_cmd(struct _adapter  *padapter, u8 offset, u8 *pval);
 u8 r8712_setptm_cmd(struct _adapter *padapter, u8 type);
+u8 r8712_setfwdig_cmd(struct _adapter *padapter, u8 type);
+u8 r8712_setfwra_cmd(struct _adapter *padapter, u8 type);
 u8 r8712_addbareq_cmd(struct _adapter *padapter, u8 tid);
 u8 r8712_wdg_wk_cmd(struct _adapter *padapter);
 void r8712_survey_cmd_callback(struct _adapter  *padapter,
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 4522553..6b15ab8 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -49,7 +49,7 @@
 #include <net/iw_handler.h>
 #include <linux/if_arp.h>
 
-#define RTL_IOCTL_WPA_SUPPLICANT	(SIOCIWFIRSTPRIV + 30)
+#define RTL_IOCTL_WPA_SUPPLICANT	(SIOCIWFIRSTPRIV + 0x1E)
 
 #define SCAN_ITEM_SIZE 768
 #define MAX_CUSTOM_LEN 64
@@ -953,6 +953,10 @@ static int r8711_wx_get_range(struct net_device *dev,
 	return 0;
 }
 
+static int r8711_wx_get_rate(struct net_device *dev,
+			     struct iw_request_info *info,
+			     union iwreq_data *wrqu, char *extra);
+
 static int r871x_wx_set_priv(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *awrq,
@@ -960,6 +964,7 @@ static int r871x_wx_set_priv(struct net_device *dev,
 {
 	int ret = 0, len = 0;
 	char *ext;
+	struct _adapter *padapter = netdev_priv(dev);
 	struct iw_point *dwrq = (struct iw_point *)awrq;
 
 	len = dwrq->length;
@@ -970,6 +975,87 @@ static int r871x_wx_set_priv(struct net_device *dev,
 		kfree(ext);
 		return -EFAULT;
 	}
+
+	if (0 == strcasecmp(ext, "RSSI")) {
+		/*Return received signal strength indicator in -db for */
+		/* current AP */
+		/*<ssid> Rssi xx */
+		struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
+		struct wlan_network *pcur_network = &pmlmepriv->cur_network;
+		/*static u8 xxxx; */
+		if (check_fwstate(pmlmepriv, _FW_LINKED) == true) {
+			sprintf(ext, "%s rssi %d",
+				pcur_network->network.Ssid.Ssid,
+				/*(xxxx=xxxx+10) */
+				((padapter->recvpriv.fw_rssi)>>1)-95
+				/*pcur_network->network.Rssi */
+				);
+		} else {
+			sprintf(ext, "OK");
+		}
+	} else if (0 == strcasecmp(ext, "LINKSPEED")) {
+		/*Return link speed in MBPS */
+		/*LinkSpeed xx */
+		union iwreq_data wrqd;
+		int ret_inner;
+		int mbps;
+
+		ret_inner = r8711_wx_get_rate(dev, info, &wrqd, extra);
+		if (0 != ret_inner)
+			mbps = 0;
+		else
+			mbps = wrqd.bitrate.value / 1000000;
+		sprintf(ext, "LINKSPEED %d", mbps);
+	} else if (0 == strcasecmp(ext, "MACADDR")) {
+		/*Return mac address of the station */
+		/*Macaddr = xx.xx.xx.xx.xx.xx */
+		sprintf(ext,
+			"MACADDR = %02x.%02x.%02x.%02x.%02x.%02x",
+			*(dev->dev_addr), *(dev->dev_addr+1),
+			*(dev->dev_addr+2), *(dev->dev_addr+3),
+			*(dev->dev_addr+4), *(dev->dev_addr+5));
+	} else if (0 == strcasecmp(ext, "SCAN-ACTIVE")) {
+		/*Set scan type to active */
+		/*OK if successful */
+		struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
+		pmlmepriv->passive_mode = 1;
+		sprintf(ext, "OK");
+	} else if (0 == strcasecmp(ext, "SCAN-PASSIVE")) {
+		/*Set scan type to passive */
+		/*OK if successful */
+		struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
+		pmlmepriv->passive_mode = 0;
+		sprintf(ext, "OK");
+	} else if (0 == strncmp(ext, "DCE-E", 5)) {
+		/*Set scan type to passive */
+		/*OK if successful */
+		r8712_disconnectCtrlEx_cmd(padapter
+			, 1 /*u32 enableDrvCtrl */
+			, 5 /*u32 tryPktCnt */
+			, 100 /*u32 tryPktInterval */
+			, 5000 /*u32 firstStageTO */
+		);
+		sprintf(ext, "OK");
+	} else if (0 == strncmp(ext, "DCE-D", 5)) {
+		/*Set scan type to passive */
+		/*OK if successfu */
+		r8712_disconnectCtrlEx_cmd(padapter
+			, 0 /*u32 enableDrvCtrl */
+			, 5 /*u32 tryPktCnt */
+			, 100 /*u32 tryPktInterval */
+			, 5000 /*u32 firstStageTO */
+		);
+		sprintf(ext, "OK");
+	} else {
+		printk(KERN_INFO "r8712u: r871x_wx_set_priv: unknown Command"
+		       " %s.\n", ext);
+		goto FREE_EXT;
+	}
+	if (copy_to_user(dwrq->pointer, ext,
+				min(dwrq->length, (__u16)(strlen(ext)+1))))
+		ret = -EFAULT;
+
+FREE_EXT:
 	kfree(ext);
 	return ret;
 }
@@ -1158,7 +1244,7 @@ static int r8711_wx_get_scan(struct net_device *dev,
 	while (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY|_FW_UNDER_LINKING)) {
 		msleep(30);
 		cnt++;
-		if (cnt > 1000)
+		if (cnt > 100)
 			break;
 	}
 	spin_lock_irqsave(&queue->lock, irqL);
@@ -1233,6 +1319,17 @@ static int r8711_wx_set_essid(struct net_device *dev,
 			if ((!memcmp(dst_ssid, src_ssid, ndis_ssid.SsidLength))
 			    && (pnetwork->network.Ssid.SsidLength ==
 			     ndis_ssid.SsidLength)) {
+				if (check_fwstate(pmlmepriv,
+							WIFI_ADHOC_STATE)) {
+					if (pnetwork->network.
+						InfrastructureMode
+						!=
+						padapter->mlmepriv.
+						cur_network.network.
+						InfrastructureMode)
+						continue;
+				}
+
 				if (!r8712_set_802_11_infrastructure_mode(
 				     padapter,
 				     pnetwork->network.InfrastructureMode))
@@ -1345,6 +1442,7 @@ static int r8711_wx_get_rate(struct net_device *dev,
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct ndis_wlan_bssid_ex *pcur_bss = &pmlmepriv->cur_network.network;
 	struct ieee80211_ht_cap *pht_capie;
+	unsigned char rf_type = padapter->registrypriv.rf_config;
 	int i;
 	u8 *p;
 	u16 rate, max_rate = 0, ht_cap = false;
@@ -1377,7 +1475,9 @@ static int r8711_wx_get_rate(struct net_device *dev,
 			i++;
 		}
 		if (ht_cap == true) {
-			if (mcs_rate & 0x8000) /* MCS15 */
+			if (mcs_rate & 0x8000 /* MCS15 */
+				&&
+				RTL8712_RF_2T2R == rf_type)
 				max_rate = (bw_40MHz) ? ((short_GI) ? 300 :
 					    270) : ((short_GI) ? 144 : 130);
 			else if (mcs_rate & 0x0080) /* MCS7 */
@@ -1984,6 +2084,27 @@ static int r871x_set_pid(struct net_device *dev,
 	return 0;
 }
 
+static int r871x_set_chplan(struct net_device *dev,
+				struct iw_request_info *info,
+				union iwreq_data *wrqu, char *extra)
+{
+	int ret = 0;
+	struct _adapter *padapter = (struct _adapter *) netdev_priv(dev);
+	struct iw_point *pdata = &wrqu->data;
+	int ch_plan = -1;
+
+	if ((padapter->bDriverStopped) || (pdata == NULL)) {
+		ret = -EINVAL;
+		goto exit;
+	}
+	ch_plan = (int)*extra;
+	r8712_set_chplan_cmd(padapter, ch_plan);
+
+exit:
+
+	return ret;
+}
+
 static int r871x_wps_start(struct net_device *dev,
 			   struct iw_request_info *info,
 			   union iwreq_data *wrqu, char *extra)
@@ -2223,6 +2344,10 @@ static const struct iw_priv_args r8711_private_args[] = {
 	{
 		SIOCIWFIRSTPRIV + 0x6,
 		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "wps_start"
+	},
+	{
+		SIOCIWFIRSTPRIV + 0x7,
+		IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "chplan"
 	}
 };
 
@@ -2233,7 +2358,8 @@ static iw_handler r8711_private_handler[] = {
 	r871x_mp_ioctl_hdl,
 	r871x_get_ap_info, /*for MM DTV platform*/
 	r871x_set_pid,
-	 r871x_wps_start,
+	r871x_wps_start,
+	r871x_set_chplan
 };
 
 static struct iw_statistics *r871x_get_wireless_stats(struct net_device *dev)
@@ -2254,7 +2380,13 @@ static struct iw_statistics *r871x_get_wireless_stats(struct net_device *dev)
 		tmp_qual = padapter->recvpriv.signal;
 		tmp_noise = padapter->recvpriv.noise;
 		piwstats->qual.level = tmp_level;
-		piwstats->qual.qual = tmp_qual;
+		/*piwstats->qual.qual = tmp_qual;
+		 * The NetworkManager of Fedora 10, 13 will use the link
+		 * quality for its display.
+		 * So, use the fw_rssi on link quality variable because
+		 * fw_rssi will be updated per 2 seconds.
+		 */
+		piwstats->qual.qual = tmp_level;
 		piwstats->qual.noise = tmp_noise;
 	}
 	piwstats->qual.updated = IW_QUAL_ALL_UPDATED;
@@ -2269,5 +2401,5 @@ struct iw_handler_def r871x_handlers_def = {
 	.num_private = sizeof(r8711_private_handler) / sizeof(iw_handler),
 	.num_private_args = sizeof(r8711_private_args) /
 			    sizeof(struct iw_priv_args),
-	.get_wireless_stats = r871x_get_wireless_stats,
+	.get_wireless_stats = r871x_get_wireless_stats
 };
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.h b/drivers/staging/rtl8712/rtl871x_mlme.h
index b8810a9..71ca013 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.h
+++ b/drivers/staging/rtl8712/rtl871x_mlme.h
@@ -95,6 +95,7 @@ struct mlme_priv {
 	struct  __queue scanned_queue;
 	u8 *free_bss_buf;
 	unsigned long num_of_scanned;
+	u8 passive_mode; /*add for Android's SCAN-ACTIVE/SCAN-PASSIVE */
 	struct ndis_802_11_ssid	assoc_ssid;
 	u8 assoc_bssid[6];
 	struct wlan_network cur_network;
@@ -226,8 +227,6 @@ void r8712_joinbss_reset(struct _adapter *padapter);
 unsigned int r8712_restructure_ht_ie(struct _adapter *padapter, u8 *in_ie,
 				     u8 *out_ie, uint in_len, uint *pout_len);
 void r8712_issue_addbareq_cmd(struct _adapter *padapter, int priority);
-unsigned int r8712_add_ht_addt_info(struct _adapter *padapter, u8 *in_ie,
-				    u8 *out_ie, uint in_len, uint *pout_len);
 int r8712_is_same_ibss(struct _adapter *adapter, struct wlan_network *pnetwork);
 
 #endif /*__RTL871X_MLME_H_*/
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0019-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Var.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0019-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Var.pa";
 filename*1="tch"

>From f090d930761cb30174aa2386c6216e0c340ae23d Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:21 +0800
Subject: [PATCH 19/20] staging: r8712u: Merging Realtek's latest (v2.6.6).
 Various fixes.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

In r8712_generate_ie(), HT check is no longer done.
Removed r8712_add_ht_addt_info().
Changes to defragmentation handling, and queue selection.
Get TSSI command.
Added an Ad-Hoc check to is_desired_network()
r8712_ind_disconnect() now checks for Linked state.
r8712_xmit_bh() now schedules an xmit tasklet.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/ieee80211.c     |   35 +------------------
 drivers/staging/rtl8712/ieee80211.h     |    6 +--
 drivers/staging/rtl8712/os_intfs.c      |    3 ++
 drivers/staging/rtl8712/rtl8712_recv.c  |   24 +++++++------
 drivers/staging/rtl8712/rtl8712_recv.h  |    5 +++
 drivers/staging/rtl8712/rtl8712_xmit.c  |   20 ++++++++--
 drivers/staging/rtl8712/rtl8712_xmit.h  |    5 +++
 drivers/staging/rtl8712/rtl871x_cmd.c   |   30 +++++++++++++++-
 drivers/staging/rtl8712/rtl871x_mlme.c  |   58 ++++++++----------------------
 drivers/staging/rtl8712/rtl871x_xmit.h  |    7 +++-
 drivers/staging/rtl8712/sta_info.h      |    4 +-
 drivers/staging/rtl8712/usb_intf.c      |   12 ++++--
 drivers/staging/rtl8712/usb_ops_linux.c |   19 +++++-----
 13 files changed, 114 insertions(+), 114 deletions(-)

diff --git a/drivers/staging/rtl8712/ieee80211.c b/drivers/staging/rtl8712/ieee80211.c
index f06addc..cc68d97 100644
--- a/drivers/staging/rtl8712/ieee80211.c
+++ b/drivers/staging/rtl8712/ieee80211.c
@@ -170,17 +170,11 @@ static uint r8712_get_rateset_len(u8 *rateset)
 	return i;
 }
 
-int r8712_generate_ie(struct registry_priv *pregistrypriv,
-		      struct _adapter *padapter)
+int r8712_generate_ie(struct registry_priv *pregistrypriv)
 {
 	int sz = 0, rateLen;
 	struct wlan_bssid_ex *pdev_network = &pregistrypriv->dev_network;
 	u8 *ie = pdev_network->IEs;
-	struct ieee80211_ht_cap ht_capie;
-	struct ieee80211_ht_addt_info ht_addt_info;
-	unsigned char WMM_IE[] = {0x00, 0x50, 0xf2, 0x02, 0x00, 0x01, 0x00};
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-	struct qos_priv *pqospriv = &pmlmepriv->qospriv;
 
 	/*timestamp will be inserted by hardware*/
 	sz += 8;
@@ -219,33 +213,6 @@ int r8712_generate_ie(struct registry_priv *pregistrypriv,
 	/*IBSS Parameter Set*/
 	ie = r8712_set_ie(ie, _IBSS_PARA_IE_, 2,
 		    (u8 *)&(pdev_network->Configuration.ATIMWindow), &sz);
-	if (pregistrypriv->ht_enable == 1) {
-		if (pqospriv->qos_option == 0) {
-			ie = r8712_set_ie(ie, _VENDOR_SPECIFIC_IE_,
-					   _WMM_IE_Length_, WMM_IE, &sz);
-			pqospriv->qos_option = 1;
-		}
-		memset(&ht_capie, 0, sizeof(struct ieee80211_ht_cap));
-		ht_capie.cap_info = IEEE80211_HT_CAP_SUP_WIDTH |
-				    IEEE80211_HT_CAP_SGI_20 |
-				    IEEE80211_HT_CAP_SGI_40 |
-				    IEEE80211_HT_CAP_TX_STBC |
-				    IEEE80211_HT_CAP_MAX_AMSDU |
-				    IEEE80211_HT_CAP_DSSSCCK40;
-		ht_capie.ampdu_params_info = (IEEE80211_HT_CAP_AMPDU_FACTOR &
-				0x03) | (IEEE80211_HT_CAP_AMPDU_DENSITY & 0x00);
-		ie = r8712_set_ie(ie, _HT_CAPABILITY_IE_,
-			    sizeof(struct ieee80211_ht_cap),
-			    (unsigned char *)&ht_capie, &sz);
-		/*add HT info ie*/
-		memset(&ht_addt_info, 0,
-			sizeof(struct ieee80211_ht_addt_info));
-		/*need to add the HT additional IEs*/
-		ht_addt_info.control_chan = pregistrypriv->channel;
-		ie = r8712_set_ie(ie, _HT_ADD_INFO_IE_,
-			    sizeof(struct ieee80211_ht_addt_info),
-			    (unsigned char *)&ht_addt_info, &sz);
-	}
 	return sz;
 }
 
diff --git a/drivers/staging/rtl8712/ieee80211.h b/drivers/staging/rtl8712/ieee80211.h
index d1d0868..3c0092b 100644
--- a/drivers/staging/rtl8712/ieee80211.h
+++ b/drivers/staging/rtl8712/ieee80211.h
@@ -137,7 +137,7 @@ struct ieee_ibss_seq {
 	u8 mac[ETH_ALEN];
 	u16 seq_num;
 	u16 frag_num;
-	unsigned int packet_time;
+	unsigned long packet_time;
 	struct list_head list;
 };
 
@@ -669,7 +669,6 @@ struct ieee80211_txb {
 #define CRC_LENGTH                 4U
 
 #define MAX_WPA_IE_LEN 128
-#define MAX_WPS_IE_LEN 512
 
 #define NETWORK_EMPTY_ESSID (1<<0)
 #define NETWORK_HAS_OFDM    (1<<1)
@@ -789,8 +788,7 @@ int r8712_parse_wpa2_ie(u8 *wpa_ie, int wpa_ie_len, int *group_cipher,
 int r8712_get_sec_ie(u8 *in_ie, uint in_len, u8 *rsn_ie, u16 *rsn_len,
 		     u8 *wpa_ie, u16 *wpa_len);
 int r8712_get_wps_ie(u8 *in_ie, uint in_len, u8 *wps_ie, uint *wps_ielen);
-int r8712_generate_ie(struct registry_priv *pregistrypriv,
-		      struct _adapter *padapter);
+int r8712_generate_ie(struct registry_priv *pregistrypriv);
 uint r8712_is_cckrates_included(u8 *rate);
 uint r8712_is_cckratesonly_included(u8 *rate);
 
diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index 961d6e5..9a75c6d 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -286,6 +286,9 @@ static u8 init_default_value(struct _adapter *padapter)
 	pxmitpriv->vcs_type = pregistrypriv->vcs_type;
 	pxmitpriv->rts_thresh = pregistrypriv->rts_thresh;
 	pxmitpriv->frag_len = pregistrypriv->frag_thresh;
+	/* mlme_priv */
+	/* Maybe someday we should rename this variable to "active_mode"(Jeff)*/
+	pmlmepriv->passive_mode = 1; /* 1: active, 0: passive. */
 	/*ht_priv*/
 	{
 		int i;
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index 625a8a0..6d69265 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -192,7 +192,7 @@ static void update_recvframe_attrib_from_recvstat(struct rx_pkt_attrib *pattrib,
 	} else
 		pattrib->tcpchk_valid = 0; /* invalid */
 	pattrib->mcs_rate = (u8)((le32_to_cpu(prxstat->rxdw3)) & 0x3f);
-	pattrib->htc = (u8)((le32_to_cpu(prxstat->rxdw3) >> 6) & 0x1);
+	pattrib->htc = (u8)((le32_to_cpu(prxstat->rxdw3) >> 14) & 0x1);
 	/*Offset 16*/
 	/*Offset 20*/
 	/*phy_info*/
@@ -207,7 +207,7 @@ static union recv_frame *recvframe_defrag(struct _adapter *adapter,
 				   struct  __queue *defrag_q)
 {
 	struct list_head *plist, *phead;
-	u8	wlanhdr_offset;
+	u8	*data, wlanhdr_offset;
 	u8	curfragnum;
 	struct recv_frame_hdr *pfhdr, *pnfhdr;
 	union recv_frame *prframe, *pnextrframe;
@@ -224,22 +224,25 @@ static union recv_frame *recvframe_defrag(struct _adapter *adapter,
 		/*the first fragment number must be 0
 		 *free the whole queue*/
 		r8712_free_recvframe(prframe, pfree_recv_queue);
-		prframe = NULL;
-		goto exit;
+		r8712_free_recvframe_queue(defrag_q, pfree_recv_queue);
+		return NULL;
 	}
-	plist = get_next(phead);
+	curfragnum++;
+	plist = get_list_head(defrag_q);
+	plist = get_next(plist);
+	data = get_recvframe_data(prframe);
 	while (end_of_queue_search(phead, plist) == false) {
 		pnextrframe = LIST_CONTAINOR(plist, union recv_frame, u);
-		/*check the fragment sequence  (2nd ~n fragment frame) */
 		pnfhdr = &pnextrframe->u.hdr;
-		curfragnum++;
+		/*check the fragment sequence  (2nd ~n fragment frame) */
 		if (curfragnum != pnfhdr->attrib.frag_num) {
 			/* the fragment number must increase  (after decache)
 			 * release the defrag_q & prframe */
 			r8712_free_recvframe(prframe, pfree_recv_queue);
-			prframe = NULL;
-			goto exit;
+			r8712_free_recvframe_queue(defrag_q, pfree_recv_queue);
+			return NULL;
 		}
+		curfragnum++;
 		/* copy the 2nd~n fragment frame's payload to the first fragment
 		 * get the 2nd~last fragment frame's payload */
 		wlanhdr_offset = pnfhdr->attrib.hdrlen + pnfhdr->attrib.iv_len;
@@ -252,7 +255,6 @@ static union recv_frame *recvframe_defrag(struct _adapter *adapter,
 		pfhdr->attrib.icv_len = pnfhdr->attrib.icv_len;
 		plist = get_next(plist);
 	}
-exit:
 	/* free the defrag_q queue and return the prframe */
 	r8712_free_recvframe_queue(defrag_q, pfree_recv_queue);
 	return prframe;
@@ -1074,7 +1076,7 @@ static int recvbuf2recvframe(struct _adapter *padapter, struct sk_buff *pskb)
 		/* for first fragment packet, driver need allocate 1536 +
 		 * drvinfo_sz + RXDESC_SIZE to defrag packet. */
 		if ((mf == 1) && (frag == 0))
-			alloc_sz = 1658;
+			alloc_sz = 1658;/*1658+6=1664, 1664 is 128 alignment.*/
 		else
 			alloc_sz = tmp_len;
 		/* 2 is for IP header 4 bytes alignment in QoS packet case.
diff --git a/drivers/staging/rtl8712/rtl8712_recv.h b/drivers/staging/rtl8712/rtl8712_recv.h
index 6626c8f..8efbd1f 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.h
+++ b/drivers/staging/rtl8712/rtl8712_recv.h
@@ -29,7 +29,12 @@
 #include "osdep_service.h"
 #include "drv_types.h"
 
+/* Realtek's v2.6.6 reduced this to 4. However, under heavy network and CPU
+ * loads, even 8 receive buffers might not be enough; cutting it to 4 seemed
+ * unwise.
+ */
 #define NR_RECVBUFF (8)
+
 #define NR_PREALLOC_RECV_SKB (8)
 #define RXDESC_SIZE	24
 #define RXDESC_OFFSET RXDESC_SIZE
diff --git a/drivers/staging/rtl8712/rtl8712_xmit.c b/drivers/staging/rtl8712/rtl8712_xmit.c
index c1e4784..d09fbba 100644
--- a/drivers/staging/rtl8712/rtl8712_xmit.c
+++ b/drivers/staging/rtl8712/rtl8712_xmit.c
@@ -37,6 +37,7 @@
 
 static void dump_xframe(struct _adapter *padapter,
 			struct xmit_frame *pxmitframe);
+static void update_txdesc(struct xmit_frame *pxmitframe, uint *pmem, int sz);
 
 sint _r8712_init_hw_txqueue(struct hw_txqueue *phw_txqueue, u8 ac_tag)
 {
@@ -238,13 +239,24 @@ exit_dequeue_xframe_ex:
 void r8712_do_queue_select(struct _adapter *padapter,
 			   struct pkt_attrib *pattrib)
 {
-	u8 qsel = 0;
+	unsigned int qsel = 0;
 	struct dvobj_priv *pdvobj = (struct dvobj_priv *)&padapter->dvobjpriv;
 
 	if (pdvobj->nr_endpoint == 6)
-		qsel = pattrib->priority;
-	else if (pdvobj->nr_endpoint == 4)
-		qsel = pattrib->priority;
+		qsel = (unsigned int) pattrib->priority;
+	else if (pdvobj->nr_endpoint == 4) {
+		qsel = (unsigned int) pattrib->priority;
+		if (qsel == 0 || qsel == 3)
+			qsel = 3;
+		else if (qsel == 1 || qsel == 2)
+			qsel = 1;
+		else if (qsel == 4 || qsel == 5)
+			qsel = 5;
+		else if (qsel == 6 || qsel == 7)
+			qsel = 7;
+		else
+			qsel = 3;
+	}
 	pattrib->qsel = qsel;
 }
 
diff --git a/drivers/staging/rtl8712/rtl8712_xmit.h b/drivers/staging/rtl8712/rtl8712_xmit.h
index 1e8f3fe..db52d13 100644
--- a/drivers/staging/rtl8712/rtl8712_xmit.h
+++ b/drivers/staging/rtl8712/rtl8712_xmit.h
@@ -64,6 +64,8 @@
 #define OWN	BIT(31)
 #define FSG	BIT(27)
 #define LSG	BIT(26)
+#define TYPE_SHT (24)
+#define TYPE_MSK (0x03000000)
 
 /*OFFSET 4*/
 #define PKT_OFFSET_SZ (0)
@@ -74,6 +76,7 @@
 #define BMC BIT(7)
 #define BK BIT(30)
 #define AGG_EN BIT(29)
+#define RTS_RC_SHT (16)
 
 /*OFFSET 12*/
 #define SEQ_SHT (16)
@@ -83,6 +86,8 @@
 
 /*OFFSET 20*/
 #define DISFB BIT(15)
+#define RSVD6_MSK (0x00E00000)
+#define RSVD6_SHT (21)
 
 struct tx_desc {
 	/*DWORD 0*/
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index 2d8f48c..d77388b 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -240,7 +240,7 @@ u8 r8712_sitesurvey_cmd(struct _adapter *padapter,
 	init_h2fwcmd_w_parm_no_rsp(ph2c, psurveyPara,
 				   GEN_CMD_CODE(_SiteSurvey));
 	psurveyPara->bsslimit = cpu_to_le32(48);
-	psurveyPara->passive_mode = cpu_to_le32(1);
+	psurveyPara->passive_mode = cpu_to_le32(pmlmepriv->passive_mode);
 	psurveyPara->ss_ssidlen = 0;
 	memset(psurveyPara->ss_ssid, 0, IW_ESSID_MAX_SIZE + 1);
 	if ((pssid != NULL) && (pssid->SsidLength)) {
@@ -251,6 +251,7 @@ u8 r8712_sitesurvey_cmd(struct _adapter *padapter,
 	r8712_enqueue_cmd(pcmdpriv, ph2c);
 	_set_timer(&pmlmepriv->scan_to_timer, SCANNING_TIMEOUT);
 	padapter->ledpriv.LedControlHandler(padapter, LED_CTL_SITE_SURVEY);
+	padapter->blnEnableRxFF0Filter = 0;
 	return _SUCCESS;
 }
 
@@ -760,6 +761,33 @@ u8 r8712_setrttbl_cmd(struct _adapter *padapter,
 	return _SUCCESS;
 }
 
+u8 r8712_gettssi_cmd(struct _adapter *padapter, u8 offset, u8 *pval)
+{
+	struct cmd_priv *pcmdpriv = &padapter->cmdpriv;
+	struct cmd_obj *ph2c;
+	struct readTSSI_parm *prdtssiparm;
+
+	ph2c = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
+	if (ph2c == NULL)
+		return _FAIL;
+	prdtssiparm = (struct readTSSI_parm *)
+		_malloc(sizeof(struct readTSSI_parm));
+	if (prdtssiparm == NULL) {
+		kfree((unsigned char *) ph2c);
+		return _FAIL;
+	}
+	_init_listhead(&ph2c->list);
+	ph2c->cmdcode = GEN_CMD_CODE(_ReadTSSI);
+	ph2c->parmbuf = (unsigned char *)prdtssiparm;
+	ph2c->cmdsz = sizeof(struct readTSSI_parm);
+	ph2c->rsp = pval;
+	ph2c->rspsz = sizeof(struct readTSSI_rsp);
+
+	prdtssiparm->offset = offset;
+	r8712_enqueue_cmd(pcmdpriv, ph2c);
+	return _SUCCESS;
+}
+
 u8 r8712_setMacAddr_cmd(struct _adapter *padapter, u8 *mac_addr)
 {
 	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 866554d..c475b96 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -52,6 +52,8 @@ static sint _init_mlme_priv(struct _adapter *padapter)
 	pmlmepriv->fw_state = 0;
 	pmlmepriv->cur_network.network.InfrastructureMode =
 				 Ndis802_11AutoUnknown;
+	/* Maybe someday we should rename this variable to "active_mode"(Jeff)*/
+	pmlmepriv->passive_mode = 1; /* 1: active, 0: passive. */
 	spin_lock_init(&(pmlmepriv->lock));
 	spin_lock_init(&(pmlmepriv->lock2));
 	_init_queue(&(pmlmepriv->free_bss_pool));
@@ -485,6 +487,12 @@ static int is_desired_network(struct _adapter *adapter,
 	if ((psecuritypriv->PrivacyAlgrthm != _NO_PRIVACY_) &&
 		    (pnetwork->network.Privacy == 0))
 		bselected = false;
+	if (check_fwstate(&adapter->mlmepriv, WIFI_ADHOC_STATE) == true) {
+		if (pnetwork->network.InfrastructureMode !=
+			adapter->mlmepriv.cur_network.network.
+			InfrastructureMode)
+			bselected = false;
+	}
 	return bselected;
 }
 
@@ -683,9 +691,11 @@ void r8712_ind_disconnect(struct _adapter *padapter)
 {
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 
-	_clr_fwstate_(pmlmepriv, _FW_LINKED);
-	padapter->ledpriv.LedControlHandler(padapter, LED_CTL_NO_LINK);
-	r8712_os_indicate_disconnect(padapter);
+	if (check_fwstate(pmlmepriv, _FW_LINKED) == true) {
+		_clr_fwstate_(pmlmepriv, _FW_LINKED);
+		padapter->ledpriv.LedControlHandler(padapter, LED_CTL_NO_LINK);
+		r8712_os_indicate_disconnect(padapter);
+	}
 	if (padapter->pwrctrlpriv.pwr_mode !=
 	    padapter->registrypriv.power_mgnt) {
 		_cancel_timer_ex(&pmlmepriv->dhcp_timer);
@@ -718,9 +728,9 @@ void r8712_joinbss_event_callback(struct _adapter *adapter, u8 *pbuf)
 
 	if (sizeof(struct list_head) == 4 * sizeof(u32)) {
 		pnetwork = (struct wlan_network *)
-			   _malloc(sizeof(struct wlan_network));
+			_malloc(sizeof(struct wlan_network));
 		memcpy((u8 *)pnetwork+16, (u8 *)pbuf + 8,
-			 sizeof(struct wlan_network) - 16);
+			sizeof(struct wlan_network) - 16);
 	} else
 		pnetwork = (struct wlan_network *)pbuf;
 
@@ -1657,7 +1667,7 @@ void r8712_update_registrypriv_dev_network(struct _adapter *adapter)
 	/* 1. Supported rates
 	 * 2. IE
 	 */
-	sz = r8712_generate_ie(pregistrypriv, adapter);
+	sz = r8712_generate_ie(pregistrypriv);
 	pdev_network->IELength = sz;
 	pdev_network->Length = r8712_get_ndis_wlan_bssid_ex_sz(
 			      (struct ndis_wlan_bssid_ex *)pdev_network);
@@ -1802,39 +1812,3 @@ void r8712_issue_addbareq_cmd(struct _adapter *padapter, int priority)
 		}
 	}
 }
-
-/*the function is >= passive_level*/
-unsigned int r8712_add_ht_addt_info(struct _adapter *padapter,
-			      u8 *in_ie, u8 *out_ie,
-			      uint in_len, uint *pout_len)
-{
-	u32 ielen, out_len =  0;
-	unsigned char *p, *pframe;
-	struct ieee80211_ht_addt_info ht_addt_info;
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-	struct ht_priv *phtpriv = &pmlmepriv->htpriv;
-	struct registry_priv *pregistrypriv = &padapter->registrypriv;
-	out_len = *pout_len;
-
-	if (pregistrypriv->ht_enable == 1) {
-		p = r8712_get_ie(in_ie+12, _HT_ADD_INFO_IE_,
-				 &ielen, in_len - 12);
-		if (p && (ielen > 0)) {
-			; /* dummy branch */
-		} else {
-			if (p == NULL) {
-				int sz = sizeof(struct ieee80211_ht_addt_info);
-				memset(&ht_addt_info, 0, sz);
-				/*need to add the HT additional IEs*/
-				ht_addt_info.control_chan =
-						pregistrypriv->channel;
-				pframe = r8712_set_ie(out_ie + out_len,
-						_HT_ADD_INFO_IE_,
-						sz,
-						(unsigned char *)&ht_addt_info,
-						pout_len);
-			}
-		}
-	}
-	return phtpriv->ht_option;
-}
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.h b/drivers/staging/rtl8712/rtl871x_xmit.h
index 8198778..a1dccec 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.h
+++ b/drivers/staging/rtl8712/rtl871x_xmit.h
@@ -93,9 +93,9 @@ struct pkt_attrib {
 
 	u16	seqnum;
 	u16	ether_type;
-	u32	pktlen;		/* the original 802.3 pkt raw_data len
+	u16	pktlen;		/* the original 802.3 pkt raw_data len
 				 * (not include ether_hdr data) */
-	u32	last_txcmdsz;
+	u16	last_txcmdsz;
 
 	u8	pkt_hdrlen;	/*the original 802.3 pkt header len*/
 	u8	hdrlen;		/*the WLAN Header Len*/
@@ -225,6 +225,9 @@ struct	xmit_priv {
 	struct semaphore tx_retevt;/*all tx return event;*/
 	u8	txirp_cnt;
 	struct tasklet_struct xmit_tasklet;
+	_workitem xmit_pipe4_reset_wi;
+	_workitem xmit_pipe6_reset_wi;
+	_workitem xmit_piped_reset_wi;
 	/*per AC pending irp*/
 	int beq_cnt;
 	int bkq_cnt;
diff --git a/drivers/staging/rtl8712/sta_info.h b/drivers/staging/rtl8712/sta_info.h
index 2ac8d33..48d6a14 100644
--- a/drivers/staging/rtl8712/sta_info.h
+++ b/drivers/staging/rtl8712/sta_info.h
@@ -63,8 +63,8 @@ struct sta_info {
 	struct sta_recv_priv sta_recvpriv;
 	uint state;
 	uint aid;
-	u8	mac_id;
-	u8	qos_option;
+	uint	mac_id;
+	uint	qos_option;
 	u8	hwaddr[ETH_ALEN];
 	uint	ieee8021x_blocked;	/*0: allowed, 1:blocked */
 	uint	XPrivacy; /*aes, tkip...*/
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 3bcb669..0a2f274 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -368,23 +368,25 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 	struct _adapter *padapter = NULL;
 	struct dvobj_priv *pdvobjpriv;
 	struct net_device *pnetdev;
+	struct usb_device *udev;
 
 	printk(KERN_INFO "r8712u: DriverVersion: %s\n", DRVER);
 	/* In this probe function, O.S. will provide the usb interface pointer
 	 * to driver. We have to increase the reference count of the usb device
 	 * structure by using the usb_get_dev function.
 	 */
-	usb_get_dev(interface_to_usbdev(pusb_intf));
+	udev = interface_to_usbdev(pusb_intf);
+	usb_get_dev(udev);
 	pintf = pusb_intf;
 	/* step 1. */
 	pnetdev = r8712_init_netdev();
 	if (!pnetdev)
 		goto error;
-	padapter = (struct _adapter *)netdev_priv(pnetdev);
+	padapter = netdev_priv(pnetdev);
 	disable_ht_for_spec_devid(pdid, padapter);
 	pdvobjpriv = &padapter->dvobjpriv;
 	pdvobjpriv->padapter = padapter;
-	padapter->dvobjpriv.pusbdev = interface_to_usbdev(pusb_intf);
+	padapter->dvobjpriv.pusbdev = udev;
 	usb_set_intfdata(pusb_intf, pnetdev);
 	SET_NETDEV_DEV(pnetdev, &pusb_intf->dev);
 	/* step 2. */
@@ -594,9 +596,10 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 	/* step 6. Tell the network stack we exist */
 	if (register_netdev(pnetdev) != 0)
 		goto error;
+	spin_lock_init(&padapter->lockRxFF0Filter);
 	return 0;
 error:
-	usb_put_dev(interface_to_usbdev(pusb_intf));
+	usb_put_dev(udev);
 	usb_set_intfdata(pusb_intf, NULL);
 	if (padapter->dvobj_deinit != NULL)
 		padapter->dvobj_deinit(padapter);
@@ -613,6 +616,7 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 	struct _adapter *padapter = netdev_priv(pnetdev);
 	struct usb_device *udev = interface_to_usbdev(pusb_intf);
 
+	usb_set_intfdata(pusb_intf, NULL);
 	if (padapter) {
 		if (drvpriv.drv_registered == true)
 			padapter->bSurpriseRemoved = true;
diff --git a/drivers/staging/rtl8712/usb_ops_linux.c b/drivers/staging/rtl8712/usb_ops_linux.c
index b796c6b..24e1ec5 100644
--- a/drivers/staging/rtl8712/usb_ops_linux.c
+++ b/drivers/staging/rtl8712/usb_ops_linux.c
@@ -334,17 +334,16 @@ void r8712_xmit_bh(void *priv)
 	struct _adapter *padapter = (struct _adapter *)priv;
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 
-	while (1) {
-		if ((padapter->bDriverStopped == true) ||
-		    (padapter->bSurpriseRemoved == true)) {
-			printk(KERN_ERR "r8712u: xmit_bh => bDriverStopped"
-			       " or bSurpriseRemoved\n");
-			break;
-		}
-		ret = r8712_xmitframe_complete(padapter, pxmitpriv, NULL);
-		if (ret == false)
-			break;
+	if ((padapter->bDriverStopped == true) ||
+	    (padapter->bSurpriseRemoved == true)) {
+		printk(KERN_ERR "r8712u: xmit_bh => bDriverStopped"
+		       " or bSurpriseRemoved\n");
+		return;
 	}
+	ret = r8712_xmitframe_complete(padapter, pxmitpriv, NULL);
+	if (ret == false)
+		return;
+	tasklet_hi_schedule(&pxmitpriv->xmit_tasklet);
 }
 
 static void usb_write_port_complete(struct urb *purb)
-- 
1.7.6.4


--------------050601010004010508060703
Content-Type: text/x-patch;
 name="0020-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Tx-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0020-staging-r8712u-Merging-Realtek-s-latest-v2.6.6-.-Tx-.pa";
 filename*1="tch"

>From 0b8466b5f86da18f0a83c871c0b482ccb8c2e31b Mon Sep 17 00:00:00 2001
From: Ali Bahar <ali@internetdog.org>
Date: Sun, 4 Sep 2011 03:14:22 +0800
Subject: [PATCH 20/20] staging: r8712u: Merging Realtek's latest (v2.6.6). Tx
 aggregation.
To: gregkh@suse.de
Cc: mikem@ring3k.org,devel@driverdev.osuosl.org

Tx Aggregation (CONFIG_R8712_TX_AGGR, known as CONFIG_USB_TX_AGGR in the
Realtek tarball) is now added.

However, its tests have not been successful! The default in the Realtek
tarball is to not build it -- and the Release Notes does not seem to list this
as a feature. I have tested the driver with and without this feature; the
former does not successfully associate when WPA2 is used.

Signed-off-by: Ali Bahar <ali@internetDog.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/Kconfig        |    7 +
 drivers/staging/rtl8712/rtl8712_xmit.c |  239 ++++++++++++++++++++++++++++++++
 drivers/staging/rtl8712/rtl8712_xmit.h |    7 +
 drivers/staging/rtl8712/rtl871x_xmit.h |   15 ++-
 4 files changed, 266 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8712/Kconfig b/drivers/staging/rtl8712/Kconfig
index 041e1e8..ea37473 100644
--- a/drivers/staging/rtl8712/Kconfig
+++ b/drivers/staging/rtl8712/Kconfig
@@ -16,4 +16,11 @@ config R8712_AP
 	---help---
 	This option allows the Realtek RTL8712 USB device to be an Access Point.
 
+config R8712_TX_AGGR
+	bool "Realtek RTL8712U Transmit Aggregation code"
+	depends on R8712U && BROKEN
+	default N
+	---help---
+	This option provides transmit aggregation for the Realtek RTL8712 USB device.
+
 
diff --git a/drivers/staging/rtl8712/rtl8712_xmit.c b/drivers/staging/rtl8712/rtl8712_xmit.c
index d09fbba..6933319 100644
--- a/drivers/staging/rtl8712/rtl8712_xmit.c
+++ b/drivers/staging/rtl8712/rtl8712_xmit.c
@@ -260,6 +260,159 @@ void r8712_do_queue_select(struct _adapter *padapter,
 	pattrib->qsel = qsel;
 }
 
+#ifdef CONFIG_R8712_TX_AGGR
+u8 r8712_construct_txaggr_cmd_desc(struct xmit_buf *pxmitbuf)
+{
+	struct tx_desc *ptx_desc = (struct tx_desc *)pxmitbuf->pbuf;
+
+	/* Fill up TxCmd Descriptor according as USB FW Tx Aaggregation info.*/
+	/* dw0 */
+	ptx_desc->txdw0 = cpu_to_le32(CMD_HDR_SZ&0xffff);
+	ptx_desc->txdw0 |=
+		cpu_to_le32(((TXDESC_SIZE+OFFSET_SZ)<<OFFSET_SHT)&0x00ff0000);
+	ptx_desc->txdw0 |= cpu_to_le32(OWN | FSG | LSG);
+
+	/* dw1 */
+	ptx_desc->txdw1 |= cpu_to_le32((0x13<<QSEL_SHT)&0x00001f00);
+
+	return _SUCCESS;
+}
+
+u8 r8712_construct_txaggr_cmd_hdr(struct xmit_buf *pxmitbuf)
+{
+	struct xmit_frame *pxmitframe = (struct xmit_frame *)
+		pxmitbuf->priv_data;
+	struct _adapter *padapter = pxmitframe->padapter;
+	struct cmd_priv *pcmdpriv = &(padapter->cmdpriv);
+	struct cmd_hdr *pcmd_hdr = (struct cmd_hdr  *)
+		(pxmitbuf->pbuf + TXDESC_SIZE);
+
+	/* Fill up Cmd Header for USB FW Tx Aggregation.*/
+	/* dw0 */
+	pcmd_hdr->cmd_dw0 = cpu_to_le32((GEN_CMD_CODE(_AMSDU_TO_AMPDU) << 16) |
+					(pcmdpriv->cmd_seq << 24));
+	pcmdpriv->cmd_seq++;
+
+	return _SUCCESS;
+}
+
+u8 r8712_append_mpdu_unit(struct xmit_buf *pxmitbuf,
+			struct xmit_frame *pxmitframe)
+{
+	struct _adapter *padapter = pxmitframe->padapter;
+	struct tx_desc *ptx_desc = (struct tx_desc *)pxmitbuf->pbuf;
+	int last_txcmdsz = 0;
+	int padding_sz = 0;
+
+	/* 802.3->802.11 convertor */
+	r8712_xmitframe_coalesce(padapter, pxmitframe->pkt, pxmitframe);
+	/* free skb struct */
+	r8712_xmit_complete(padapter, pxmitframe);
+	if (pxmitframe->attrib.ether_type != 0x0806) {
+		if ((pxmitframe->attrib.ether_type != 0x888e) &&
+			(pxmitframe->attrib.dhcp_pkt != 1)) {
+			r8712_issue_addbareq_cmd(padapter,
+					pxmitframe->attrib.priority);
+		}
+	}
+	pxmitframe->last[0] = 1;
+	update_txdesc(pxmitframe, (uint *)(pxmitframe->buf_addr),
+		pxmitframe->attrib.last_txcmdsz);
+	/*padding zero */
+	last_txcmdsz = pxmitframe->attrib.last_txcmdsz;
+	padding_sz = (8 - (last_txcmdsz % 8));
+	if ((last_txcmdsz % 8) != 0) {
+		int i;
+		for (i = 0; i < padding_sz; i++)
+			*(pxmitframe->buf_addr+TXDESC_SIZE+last_txcmdsz+i) = 0;
+	}
+	/* Add the new mpdu's length */
+	ptx_desc->txdw0 = cpu_to_le32((ptx_desc->txdw0&0xffff0000) |
+		((ptx_desc->txdw0&0x0000ffff)+
+			((TXDESC_SIZE+last_txcmdsz+padding_sz)&0x0000ffff)));
+
+	return _SUCCESS;
+}
+
+
+u8 r8712_xmitframe_aggr_1st(struct xmit_buf *pxmitbuf,
+			struct xmit_frame *pxmitframe)
+{
+	/* linux complete context doesnt need to protect */
+	pxmitframe->pxmitbuf = pxmitbuf;
+	pxmitbuf->priv_data = pxmitframe;
+	pxmitframe->pxmit_urb[0] = pxmitbuf->pxmit_urb[0];
+	/* buffer addr assoc */
+	pxmitframe->buf_addr = pxmitbuf->pbuf+TXDESC_SIZE+CMD_HDR_SZ;
+	/*RTL8712_DMA_H2CCMD */
+	r8712_construct_txaggr_cmd_desc(pxmitbuf);
+	r8712_construct_txaggr_cmd_hdr(pxmitbuf);
+	if (r8712_append_mpdu_unit(pxmitbuf, pxmitframe) == _SUCCESS)
+		pxmitbuf->aggr_nr = 1;
+
+	return _SUCCESS;
+}
+
+u16 r8712_xmitframe_aggr_next(struct xmit_buf *pxmitbuf,
+			struct xmit_frame *pxmitframe)
+{
+	pxmitframe->pxmitbuf = pxmitbuf;
+	pxmitbuf->priv_data = pxmitframe;
+	pxmitframe->pxmit_urb[0] = pxmitbuf->pxmit_urb[0];
+	/* buffer addr assoc */
+	pxmitframe->buf_addr = pxmitbuf->pbuf + TXDESC_SIZE +
+		(((struct tx_desc *)pxmitbuf->pbuf)->txdw0 & 0x0000ffff);
+	if (r8712_append_mpdu_unit(pxmitbuf, pxmitframe) == _SUCCESS) {
+		r8712_free_xmitframe_ex(&pxmitframe->padapter->xmitpriv,
+					pxmitframe);
+		pxmitbuf->aggr_nr++;
+	}
+
+	return TXDESC_SIZE +
+		(((struct tx_desc *)pxmitbuf->pbuf)->txdw0 & 0x0000ffff);
+}
+
+u8 r8712_dump_aggr_xframe(struct xmit_buf *pxmitbuf,
+			struct xmit_frame *pxmitframe)
+{
+	struct _adapter *padapter = pxmitframe->padapter;
+	struct dvobj_priv *pdvobj = (struct dvobj_priv *) &padapter->dvobjpriv;
+	struct tx_desc * ptxdesc = (struct tx_desc *)pxmitbuf->pbuf;
+	struct cmd_hdr *pcmd_hdr = (struct cmd_hdr *)
+		(pxmitbuf->pbuf + TXDESC_SIZE);
+	u16 total_length = (u16) (ptxdesc->txdw0 & 0xffff);
+
+	/* use 1st xmitframe as media */
+	xmitframe_xmitbuf_attach(pxmitframe, pxmitbuf);
+	pcmd_hdr->cmd_dw0 = cpu_to_le32(((total_length-CMD_HDR_SZ)&0x0000ffff)|
+					(pcmd_hdr->cmd_dw0&0xffff0000));
+
+	/* urb length in cmd_dw1 */
+	pcmd_hdr->cmd_dw1 = cpu_to_le32((pxmitbuf->aggr_nr & 0xff)|
+					((total_length+TXDESC_SIZE) << 16));
+	pxmitframe->last[0] = 1;
+	pxmitframe->bpending[0] = false;
+	pxmitframe->mem_addr = pxmitbuf->pbuf;
+
+	if ((pdvobj->ishighspeed && ((total_length+TXDESC_SIZE)%0x200) == 0) ||
+		((!pdvobj->ishighspeed &&
+			((total_length+TXDESC_SIZE)%0x40) == 0))) {
+		ptxdesc->txdw0 |= cpu_to_le32
+			(((TXDESC_SIZE+OFFSET_SZ+8)<<OFFSET_SHT)&0x00ff0000);
+		/*32 bytes for TX Desc + 8 bytes pending*/
+	} else {
+		ptxdesc->txdw0 |= cpu_to_le32
+			(((TXDESC_SIZE+OFFSET_SZ)<<OFFSET_SHT)&0x00ff0000);
+		/*default = 32 bytes for TX Desc*/
+	}
+	r8712_write_port(pxmitframe->padapter, RTL8712_DMA_H2CCMD,
+			total_length+TXDESC_SIZE, (u8 *)pxmitframe);
+
+	return _SUCCESS;
+}
+
+#endif
+
 static void update_txdesc(struct xmit_frame *pxmitframe, uint *pmem, int sz)
 {
 	uint qsel;
@@ -270,6 +423,9 @@ static void update_txdesc(struct xmit_frame *pxmitframe, uint *pmem, int sz)
 	struct pkt_attrib *pattrib = &pxmitframe->attrib;
 	struct tx_desc *ptxdesc = (struct tx_desc *)pmem;
 	struct dvobj_priv *pdvobj = (struct dvobj_priv *)&padapter->dvobjpriv;
+#ifdef CONFIG_R8712_TX_AGGR
+	struct cmd_priv *pcmdpriv = (struct cmd_priv *)&padapter->cmdpriv;
+#endif
 	u8 blnSetTxDescOffset;
 	sint bmcst = IS_MCAST(pattrib->ra);
 	struct ht_priv *phtpriv = &pmlmepriv->htpriv;
@@ -303,8 +459,40 @@ static void update_txdesc(struct xmit_frame *pxmitframe, uint *pmem, int sz)
 	if (pxmitframe->frame_tag == DATA_FRAMETAG) {
 		/* offset 4 */
 		ptxdesc->txdw1 |= cpu_to_le32((pattrib->mac_id)&0x1f);
+
+#ifdef CONFIG_R8712_TX_AGGR
+		/* dirty workaround, need to check if it is aggr cmd. */
+		if ((u8 *)pmem != (u8 *)pxmitframe->pxmitbuf->pbuf) {
+			ptxdesc->txdw0 |= cpu_to_le32
+				((0x3 << TYPE_SHT)&TYPE_MSK);
+			qsel = (uint)(pattrib->qsel & 0x0000001f);
+			if (qsel == 2)
+				qsel = 0;
+			ptxdesc->txdw1 |= cpu_to_le32
+				((qsel << QSEL_SHT) & 0x00001f00);
+			ptxdesc->txdw2 = cpu_to_le32
+				((qsel << RTS_RC_SHT)&0x001f0000);
+			ptxdesc->txdw6 |= cpu_to_le32
+				((0x5 << RSVD6_SHT)&RSVD6_MSK);
+		} else {
+			ptxdesc->txdw0 |= cpu_to_le32
+				((0x3 << TYPE_SHT)&TYPE_MSK);
+			ptxdesc->txdw1 |= cpu_to_le32
+				((0x13 << QSEL_SHT) & 0x00001f00);
+			qsel = (uint)(pattrib->qsel & 0x0000001f);
+			if (qsel == 2)
+				qsel = 0;
+			ptxdesc->txdw2 = cpu_to_le32
+				((qsel << RTS_RC_SHT)&0x0001f000);
+			ptxdesc->txdw7 |= cpu_to_le32
+				(pcmdpriv->cmd_seq << 24);
+			pcmdpriv->cmd_seq++;
+		}
+		pattrib->qsel = 0x13;
+#else
 		qsel = (uint)(pattrib->qsel & 0x0000001f);
 		ptxdesc->txdw1 |= cpu_to_le32((qsel << QSEL_SHT) & 0x00001f00);
+#endif
 		if (!pqospriv->qos_option)
 			ptxdesc->txdw1 |= cpu_to_le32(BIT(16));/*Non-QoS*/
 		if ((pattrib->encrypt > 0) && !pattrib->bswenc) {
@@ -426,7 +614,11 @@ int r8712_xmitframe_complete(struct _adapter *padapter,
 	struct hw_xmit *phwxmits;
 	sint hwentry;
 	struct xmit_frame *pxmitframe = NULL;
+#ifdef CONFIG_R8712_TX_AGGR
+	struct xmit_frame *p2ndxmitframe = NULL;
+#else
 	int res = _SUCCESS, xcnt = 0;
+#endif
 
 	phwxmits = pxmitpriv->hwxmits;
 	hwentry = pxmitpriv->hwxmit_entry;
@@ -434,12 +626,53 @@ int r8712_xmitframe_complete(struct _adapter *padapter,
 		pxmitbuf = r8712_alloc_xmitbuf(pxmitpriv);
 		if (!pxmitbuf)
 			return false;
+#ifdef CONFIG_R8712_TX_AGGR
+		pxmitbuf->aggr_nr = 0;
+#endif
 	}
 	/* 1st frame dequeued */
 	pxmitframe = dequeue_xframe_ex(pxmitpriv, phwxmits, hwentry);
 	/* need to remember the 1st frame */
 	if (pxmitframe != NULL) {
 
+#ifdef CONFIG_R8712_TX_AGGR
+		/* 1. dequeue 2nd frame
+		 * 2. aggr if 2nd xframe is dequeued, else dump directly
+		 */
+		if (AGGR_NR_HIGH_BOUND > 1)
+			p2ndxmitframe = dequeue_xframe_ex(pxmitpriv, phwxmits,
+							hwentry);
+		if (pxmitframe->frame_tag != DATA_FRAMETAG) {
+			r8712_free_xmitbuf(pxmitpriv, pxmitbuf);
+			return false;
+		}
+		if (p2ndxmitframe != NULL)
+			if (p2ndxmitframe->frame_tag != DATA_FRAMETAG) {
+				r8712_free_xmitbuf(pxmitpriv, pxmitbuf);
+				return false;
+			}
+		r8712_xmitframe_aggr_1st(pxmitbuf, pxmitframe);
+		if (p2ndxmitframe != NULL) {
+			u16 total_length;
+			total_length = r8712_xmitframe_aggr_next(
+				pxmitbuf, p2ndxmitframe);
+			do {
+				p2ndxmitframe = dequeue_xframe_ex(
+					pxmitpriv, phwxmits, hwentry);
+				if (p2ndxmitframe != NULL)
+					total_length =
+						r8712_xmitframe_aggr_next(
+							pxmitbuf,
+							p2ndxmitframe);
+				else
+					break;
+			} while (total_length <= 0x1800 &&
+				pxmitbuf->aggr_nr <= AGGR_NR_HIGH_BOUND);
+		}
+		if (pxmitbuf->aggr_nr > 0)
+			r8712_dump_aggr_xframe(pxmitbuf, pxmitframe);
+
+#else
 
 		xmitframe_xmitbuf_attach(pxmitframe, pxmitbuf);
 		if (pxmitframe->frame_tag == DATA_FRAMETAG) {
@@ -455,6 +688,7 @@ int r8712_xmitframe_complete(struct _adapter *padapter,
 		else
 			r8712_free_xmitframe_ex(pxmitpriv, pxmitframe);
 		xcnt++;
+#endif
 
 	} else { /* pxmitframe == NULL && p2ndxmitframe == NULL */
 		r8712_free_xmitbuf(pxmitpriv, pxmitbuf);
@@ -493,8 +727,13 @@ static void dump_xframe(struct _adapter *padapter,
 		pxmitframe->mem_addr = mem_addr;
 		pxmitframe->bpending[t] = false;
 		ff_hwaddr = get_ff_hwaddr(pxmitframe);
+#ifdef CONFIG_R8712_TX_AGGR
+		r8712_write_port(padapter, RTL8712_DMA_H2CCMD, w_sz,
+				(unsigned char *)pxmitframe);
+#else
 		r8712_write_port(padapter, ff_hwaddr, w_sz,
 			   (unsigned char *)pxmitframe);
+#endif
 		mem_addr += w_sz;
 		mem_addr = (u8 *)RND4(((addr_t)(mem_addr)));
 	}
diff --git a/drivers/staging/rtl8712/rtl8712_xmit.h b/drivers/staging/rtl8712/rtl8712_xmit.h
index db52d13..b50e7a1 100644
--- a/drivers/staging/rtl8712/rtl8712_xmit.h
+++ b/drivers/staging/rtl8712/rtl8712_xmit.h
@@ -113,4 +113,11 @@ int r8712_xmitframe_complete(struct _adapter *padapter,
 void r8712_do_queue_select(struct _adapter *padapter,
 			   struct pkt_attrib *pattrib);
 
+#ifdef CONFIG_R8712_TX_AGGR
+u8 r8712_xmitframe_aggr_1st(struct xmit_buf *pxmitbuf,
+			struct xmit_frame *pxmitframe);
+u8 r8712_dump_aggr_xframe(struct xmit_buf *pxmitbuf,
+			struct xmit_frame *pxmitframe);
+#endif
+
 #endif
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.h b/drivers/staging/rtl8712/rtl871x_xmit.h
index a1dccec..a034c0f 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.h
+++ b/drivers/staging/rtl8712/rtl871x_xmit.h
@@ -30,8 +30,19 @@
 #include "drv_types.h"
 #include "xmit_osdep.h"
 
-#define MAX_XMITBUF_SZ	(2048)
-#define NR_XMITBUFF	(4)
+#ifdef CONFIG_R8712_TX_AGGR
+#define MAX_XMITBUF_SZ  (16384)
+#else
+#define MAX_XMITBUF_SZ  (2048)
+#endif
+
+#define NR_XMITBUFF     (4)
+
+#ifdef CONFIG_R8712_TX_AGGR
+#define AGGR_NR_HIGH_BOUND      (4) /*(8) */
+#define AGGR_NR_LOW_BOUND       (2)
+#endif
+
 #define XMITBUF_ALIGN_SZ 512
 #define TX_GUARD_BAND		5
 #define MAX_NUMBLKS		(1)
-- 
1.7.6.4


--------------050601010004010508060703--
