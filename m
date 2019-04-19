Return-Path: <SRS0=g+pd=SV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C84C282E0
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 18:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FC2D222AF
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Apr 2019 18:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfDSSTm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:19:42 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:45766 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbfDSSSK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Apr 2019 14:18:10 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x3J5oxCr020840, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x3J5oxCr020840
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 19 Apr 2019 13:50:59 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV02.realtek.com.tw (172.21.6.19) with Microsoft SMTP Server id
 14.3.439.0; Fri, 19 Apr 2019 13:50:59 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <Larry.Finger@lwfinger.net>, <sgruszka@redhat.com>,
        <briannorris@chromium.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH v9 12/14] rtw88: Kconfig & Makefile
Date:   Fri, 19 Apr 2019 13:50:02 +0800
Message-ID: <1555653004-1795-13-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1555653004-1795-1-git-send-email-yhchuang@realtek.com>
References: <1555653004-1795-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Kconfig & Makefile for Realtek 802.11ac wireless network chips

Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/Kconfig        |  1 +
 drivers/net/wireless/realtek/Makefile       |  1 +
 drivers/net/wireless/realtek/rtw88/Kconfig  | 54 +++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/Makefile | 20 +++++++++++
 4 files changed, 76 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/Kconfig
 create mode 100644 drivers/net/wireless/realtek/rtw88/Makefile

diff --git a/drivers/net/wireless/realtek/Kconfig b/drivers/net/wireless/realtek/Kconfig
index 3db988e..9189fd6 100644
--- a/drivers/net/wireless/realtek/Kconfig
+++ b/drivers/net/wireless/realtek/Kconfig
@@ -14,5 +14,6 @@ if WLAN_VENDOR_REALTEK
 source "drivers/net/wireless/realtek/rtl818x/Kconfig"
 source "drivers/net/wireless/realtek/rtlwifi/Kconfig"
 source "drivers/net/wireless/realtek/rtl8xxxu/Kconfig"
+source "drivers/net/wireless/realtek/rtw88/Kconfig"
 
 endif # WLAN_VENDOR_REALTEK
diff --git a/drivers/net/wireless/realtek/Makefile b/drivers/net/wireless/realtek/Makefile
index 9c78deb..118af99 100644
--- a/drivers/net/wireless/realtek/Makefile
+++ b/drivers/net/wireless/realtek/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_RTL8180)		+= rtl818x/
 obj-$(CONFIG_RTL8187)		+= rtl818x/
 obj-$(CONFIG_RTLWIFI)		+= rtlwifi/
 obj-$(CONFIG_RTL8XXXU)		+= rtl8xxxu/
+obj-$(CONFIG_RTW88)		+= rtw88/
 
diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
new file mode 100644
index 0000000..55b1bf3
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/Kconfig
@@ -0,0 +1,54 @@
+menuconfig RTW88
+	tristate "Realtek 802.11ac wireless chips support"
+	depends on MAC80211
+	help
+	  This module adds support for mac80211-based wireless drivers that
+	  enables Realtek IEEE 802.11ac wireless chipsets.
+
+	  If you choose to build a module, it'll be called rtw88.
+
+if RTW88
+
+config RTW88_CORE
+	tristate
+
+config RTW88_PCI
+	tristate
+
+config RTW88_8822BE
+	bool "Realtek 8822BE PCI wireless network adapter"
+	depends on PCI
+	select RTW88_CORE
+	select RTW88_PCI
+	help
+	  Select this option will enable support for 8822BE chipset
+
+	  802.11ac PCIe wireless network adapter
+
+config RTW88_8822CE
+	bool "Realtek 8822CE PCI wireless network adapter"
+	depends on PCI
+	select RTW88_CORE
+	select RTW88_PCI
+	help
+	  Select this option will enable support for 8822CE chipset
+
+	  802.11ac PCIe wireless network adapter
+
+config RTW88_DEBUG
+	bool "Realtek rtw88 debug support"
+	depends on RTW88_CORE
+	help
+	  Enable debug support
+
+	  If unsure, say Y to simplify debug problems
+
+config RTW88_DEBUGFS
+	bool "Realtek rtw88 debugfs support"
+	depends on RTW88_CORE
+	help
+	  Enable debug support
+
+	  If unsure, say Y to simplify debug problems
+
+endif
diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
new file mode 100644
index 0000000..da5e36e
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -0,0 +1,20 @@
+obj-$(CONFIG_RTW88_CORE)	+= rtw88.o
+rtw88-y += main.o \
+	   mac80211.o \
+	   util.o \
+	   debug.o \
+	   tx.o \
+	   rx.o \
+	   mac.o \
+	   phy.o \
+	   efuse.o \
+	   fw.o \
+	   ps.o \
+	   sec.o \
+	   regd.o
+
+rtw88-$(CONFIG_RTW88_8822BE)	+= rtw8822b.o rtw8822b_table.o
+rtw88-$(CONFIG_RTW88_8822CE)	+= rtw8822c.o rtw8822c_table.o
+
+obj-$(CONFIG_RTW88_PCI)		+= rtwpci.o
+rtwpci-objs			:= pci.o
-- 
2.7.4

