Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbbJOAoy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 20:44:54 -0400
From: Jes.Sorensen@redhat.com
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: [PATCH v3 0/1] rtl8xxxu (mac80211) driver for rtl8188[cr]u/rtl8192cu/rtl8723au
Date: Wed, 14 Oct 2015 20:44:50 -0400
Message-Id: <1444869891-21174-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20151015_024534_414497_720C0703)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Here is an updated version of my rtl8xxxu driver for RTL8188[CR]U,
RTL8192CU, RTL8723AU devices. This version fixes up a few bugs since
the v2 patch, as well as addresses the feedback received. It now
obtains the short-preamble information from the vif in the TX
function, and the driver was moved to
drivers/net/wireless/realtek/rtl8xxxu/

Per default only devices I have actually tested will be enabled. If
you are interested in trying it out with other 8188cu/8188ru/819[12]cu
dongles, you need to enable CONFIG_RTL8XXXU_UNTESTED. Please report
test results back to me.

Note if you enable this driver, it may clash with CONFIG_RTL8192U,
CONFIG_R8723AU, and CONFIG_RTL8192CU (rtlwifi). Please pay attention
to which module you load and/or use modprobe blacklists. There are
already conflicts between these existing drivers in the kernel, and
unfortunately there is nothing I can do about this.

This driver is still work in progress. I have used it as my primary
driver for the last nine months, and I find it to be very stable. It
seems suitable for mainline inclusion at this point.

This patch is relative to wireless-drivers-next
8785955bbc28be446bcb2ad08cfb0599246746f7

Cheers,
Jes


Jes Sorensen (1):
  New driver: rtl8xxxu (mac80211)

 MAINTAINERS                                        |    7 +
 drivers/net/wireless/Kconfig                       |    1 +
 drivers/net/wireless/realtek/Makefile              |    1 +
 drivers/net/wireless/realtek/rtl8xxxu/Kconfig      |   34 +
 drivers/net/wireless/realtek/rtl8xxxu/Makefile     |    1 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 5976 ++++++++++++++++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  676 +++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  981 ++++
 8 files changed, 7677 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/Kconfig
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/Makefile
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h

-- 
2.1.0

