Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:39541 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbbATRBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 12:01:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH V2 for 3.19 0/7] Fixes for rtl8192ee
Date: Tue, 20 Jan 2015 11:01:19 -0600
Message-Id: <1421773286-1039-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150120_180143_609021_F53F6A7C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle,

This is V2 of the patches for rtl8192ee to be applied to 3.19. They replace
all the patches submitted under the title '[PATCH for 3.19 0/3] rtlwifi:
Various updates/fixes". All are marked for backporting to 3.18.

The first of these removes a logging statement that is no longer needed.

Patches 1-6 are relatively small and should not be a problem for 3.19.
Patch 7 is quite a bit larger, and adds two new routines to detect
DMA stalls. I will understand if you want to defer that to -next; however,
it does fix a serious problem.

Larry
---
Larry Finger (2):
  rtlwifi: Remove logging statement that is no longer needed
  rtlwifi: rtl8192ee: Fix problems with calculating free space in FIFO

Troy Tan (5):
  rtlwifi: rtl8192ee: Fix handling of new style descriptors
  rtlwifi: rtl8192ee: Fix adhoc fail
  rtlwifi: rtl8192ee: Fix TX hang due to failure to update TX write
    point
  rtlwifi: rtl8192ee: Fix parsing of received packet
  rtlwifi: rtl8192ee: Fix DMA stalls

 drivers/net/wireless/rtlwifi/pci.c           |  36 ++++--
 drivers/net/wireless/rtlwifi/pci.h           |   7 ++
 drivers/net/wireless/rtlwifi/rtl8192ee/fw.c  |   6 +-
 drivers/net/wireless/rtlwifi/rtl8192ee/hw.c  | 166 ++++++++++++++++++++++-----
 drivers/net/wireless/rtlwifi/rtl8192ee/reg.h |   2 +
 drivers/net/wireless/rtlwifi/rtl8192ee/sw.c  |   3 +-
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.c |  36 +++---
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.h |   4 +-
 drivers/net/wireless/rtlwifi/wifi.h          |   1 +
 9 files changed, 192 insertions(+), 69 deletions(-)

-- 
2.1.2

