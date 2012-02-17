Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:59610 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752318Ab2BQJtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 04:49:15 -0500
Received: by mail-lpp01m010-f53.google.com with SMTP id d3so4067330lah.40
        for <linux-wireless@vger.kernel.org>; Fri, 17 Feb 2012 01:49:14 -0800 (PST)
MIME-Version: 1.0
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@gmail.com
Subject: [PATCH 2/2] compat-wireless: update makefiles patch for latest wireless-testing
Date: Fri, 17 Feb 2012 11:49:01 +0200
Message-Id: <1329472141-28781-2-git-send-email-coelho@ti.com> (sfid-20120217_104919_325818_7376229D)
In-Reply-To: <1329472141-28781-1-git-send-email-coelho@ti.com>
References: <1329472141-28781-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The drivers/net/usb/Makefile doesn't have qmi_wwan.o anymore, so we
don't need to patch it out with the latest wireless-testing.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 patches/99-change-makefiles.patch |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index 3ab5c73..62be69b 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -15,7 +15,7 @@ only the wireless stuff.
 -obj-$(CONFIG_EEPROM_DIGSY_MTC_CFG) += digsy_mtc_eeprom.o
 --- a/drivers/net/usb/Makefile
 +++ b/drivers/net/usb/Makefile
-@@ -2,32 +2,6 @@
+@@ -2,31 +2,6 @@
  # Makefile for USB Network drivers
  #
  
@@ -46,7 +46,6 @@ only the wireless stuff.
 -obj-$(CONFIG_USB_NET_CX82310_ETH)	+= cx82310_eth.o
 -obj-$(CONFIG_USB_NET_CDC_NCM)	+= cdc_ncm.o
 -obj-$(CONFIG_USB_VL600)		+= lg-vl600.o
--obj-$(CONFIG_USB_NET_QMI_WWAN)	+= qmi_wwan.o
 -
 --- a/drivers/net/wireless/Makefile
 +++ b/drivers/net/wireless/Makefile
-- 
1.7.5.4

