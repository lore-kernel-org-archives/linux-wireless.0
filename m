Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:42737 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754404Ab0J2UDq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 16:03:46 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: staging: r8712u: Fix external firmware loading
Date: Fri, 29 Oct 2010 22:03:36 +0200
Cc: wireless <linux-wireless@vger.kernel.org>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com> <4CC9F4BE.7070500@lwfinger.net> <201010292202.25486.s.L-H@gmx.de>
In-Reply-To: <201010292202.25486.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010292203.39953.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* select FW_LOADER
* declare MODULE_FIRMWARE for r8712u

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
---
 drivers/staging/rtl8712/Kconfig    |    1 +
 drivers/staging/rtl8712/hal_init.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/staging/rtl8712/Kconfig
+++ b/drivers/staging/rtl8712/Kconfig
@@ -3,6 +3,7 @@ config R8712U
 	depends on WLAN && USB
 	select WIRELESS_EXT
 	select WEXT_PRIV
+	select FW_LOADER
 	default N
 	---help---
 	This option adds the Realtek RTL8712 USB device such as the D-Link DWA-130.
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -58,6 +58,7 @@ static u32 rtl871x_open_fw(struct _adapt
 	*ppmappedfw = (u8 *)((*praw)->data);
 	return (*praw)->size;
 }
+MODULE_FIRMWARE("rtl8712u/rtl8712u.bin");
 
 static void fill_fwpriv(struct _adapter *padapter, struct fw_priv *pfwpriv)
 {
