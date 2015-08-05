Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36409 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbbHEQSs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 12:18:48 -0400
Received: by oigu206 with SMTP id u206so12149335oig.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2015 09:18:48 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH V2 NEXT 0/7] Make changes in rtlwifi and dependent drivers
Date: Wed,  5 Aug 2015 11:18:33 -0500
Message-Id: <1438791520-13216-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150805_181852_209078_E4E36F02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Realtek engineers have suggested several improvements to this family
of drivers. The changes include:

1. Fix the 5G channel assignments to remove unused channels.
2. Fix a potential race condition when updating CAM.
3. Change retry limits to depend on vif type.
4. Fix a race condition that could allow a change in the APOL key
   before packet 4 of the handshaking sequence has been transmitted.
   This problem affects rtl8192ee, rtl8723be, and rtl8821ae.

Larry
---

V2 - Fix a merge error

pkshih (6):
  rtlwifi: Fix programming of CAM content
  rtlwifi: Make retry limits depend on vif type
  rtlwifi: Force disable key to wait until TX acked.
  rtlwifi: rtl8192ee: Implement new rekey logic
  rtlwifi: rtl8723be: Implement new rekey logic
  rtlwifi: rtl8821ae: Implement new rekey logic

timlee (1):
  rtlwifi: rtl8821ae: Remove unsupported 5G channels

 drivers/net/wireless/rtlwifi/base.c          | 183 ++++++++++++++++++++++-----
 drivers/net/wireless/rtlwifi/base.h          |   7 +
 drivers/net/wireless/rtlwifi/cam.c           |   6 +-
 drivers/net/wireless/rtlwifi/core.c          |  22 +++-
 drivers/net/wireless/rtlwifi/debug.h         |   1 +
 drivers/net/wireless/rtlwifi/pci.c           |   8 +-
 drivers/net/wireless/rtlwifi/ps.c            |   3 +
 drivers/net/wireless/rtlwifi/rtl8192ee/fw.c  |   1 +
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.c |   8 ++
 drivers/net/wireless/rtlwifi/rtl8723be/fw.c  |   1 +
 drivers/net/wireless/rtlwifi/rtl8723be/trx.c |   8 ++
 drivers/net/wireless/rtlwifi/rtl8723be/trx.h |  12 ++
 drivers/net/wireless/rtlwifi/rtl8821ae/hw.c  |  14 +-
 drivers/net/wireless/rtlwifi/rtl8821ae/trx.c |   8 ++
 drivers/net/wireless/rtlwifi/rtl8821ae/trx.h |  13 ++
 drivers/net/wireless/rtlwifi/wifi.h          |   9 ++
 16 files changed, 255 insertions(+), 49 deletions(-)

-- 
2.1.4

