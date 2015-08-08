Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:36248 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992459AbbHHQxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2015 12:53:47 -0400
Received: by obnw1 with SMTP id w1so98531714obn.3
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2015 09:53:46 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH V3 NEXT 0/7] Make changes in rtlwifi and dependent drivers
Date: Sat,  8 Aug 2015 11:53:32 -0500
Message-Id: <1439052819-30196-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150808_185352_046773_FBA3FA4A)
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
V3 - One array was missed in the 5G channel list fix.

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

