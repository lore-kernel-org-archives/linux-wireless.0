Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:35320 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbbHCSyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 14:54:10 -0400
Received: by obbop1 with SMTP id op1so106251396obb.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 11:54:09 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH NEXT 0/7] Make changes in rtlwifi and dependent drivers
Date: Mon,  3 Aug 2015 13:53:45 -0500
Message-Id: <1438628032-5865-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150803_205413_969564_8E91539E)
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

