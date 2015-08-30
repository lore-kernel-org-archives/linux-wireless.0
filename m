Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbbHaNHt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 09:07:49 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: jes.sorensen@redhat.com, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Subject: [PATCH v2 0/1] rtl8xxxu (mac80211) driver for rtl8188[cr]u/rtl8192cu/rtl8723au
Date: Sun, 30 Aug 2015 17:02:53 -0400
Message-Id: <1440968574-29490-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20150831_150801_358390_16ADC529)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

I finally found some time to work on rtl8xxxu again. Since the
previously version posted some months ago, I fixed up a number of
bugs. I also added support for a range of other Realtek based USB
devices. The driver now supports rtl8723au, rtl8188cu, rtl8188ru, and
rtl8192cu. It should work on rtl8191cu devices as well.

Per default only devices I have actually tested will be enabled. If
you are interested in trying it out with other 8188cu/8188ru/819[12]cu
dongles, you need to enable CONFIG_RTL8XXXU_UNTESTED. Please report
test results back to me.

Note if you enable this driver, it may clash with CONFIG_RTL8192U,
CONFIG_R8723AU, and CONFIG_RTL8192CU (rtlwifi). Please pay attention
to which module you load and/or use modprobe blacklists.

This driver is still work in progress. I have used it as my primary
driver for the last six months, and I find it to be very stable. It
seems suitable for mainline inclusion at this point.

v2 of this patch contains fixes for issues reported by Larry Finger.
I checked include/net/mac80211.h and the .tx function does indeed have
to be atomic. In addition I found a race condition in
rtl8723a_h2c_cmd() which may explain the mutex issue Larry saw.

Cheers,
Jes


Jes Sorensen (1):
  New driver: rtl8xxxu (mac80211)

 MAINTAINERS                          |    7 +
 drivers/net/wireless/Kconfig         |   32 +
 drivers/net/wireless/Makefile        |    2 +
 drivers/net/wireless/rtl8xxxu.c      | 5829 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtl8xxxu.h      |  597 ++++
 drivers/net/wireless/rtl8xxxu_regs.h |  980 ++++++
 6 files changed, 7447 insertions(+)
 create mode 100644 drivers/net/wireless/rtl8xxxu.c
 create mode 100644 drivers/net/wireless/rtl8xxxu.h
 create mode 100644 drivers/net/wireless/rtl8xxxu_regs.h

-- 
2.1.0

