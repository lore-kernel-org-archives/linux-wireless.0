Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34628 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbcFYSiL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 14:38:11 -0400
Received: by mail-oi0-f65.google.com with SMTP id s17so23970404oih.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jun 2016 11:38:11 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Andrianov <andrianov@ispras.ru>
Subject: [PATCH 0/6] rtlwifi: Miscellaneous fixes and cleanups
Date: Sat, 25 Jun 2016 13:37:41 -0500
Message-Id: <1466879867-2499-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160625_203823_372421_426D445B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches removes an unused paramter from routine rtl_ps_set_rf_state()
in rtlwifi. The routine is also no longer exported. In addition, a potential
race condition in 5 of the drivers is fixed.

This material is suitable for kernel 4.8. To my knowledge, the race condition
has not been shown to occur, thus these patches are not backported to stable
kernels.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry Finger (6):
  rtlwifi: Remove unused parameter from rtl_ps_set_rf_state()
  rtlwifi: rtl8188ee: Fix potential race condition
  rtlwifi: rtl8192ee: Fix potential race condition
  rtlwifi: rtl8723be: Fix potential race condition
  rtlwifi: rtl8723ae: Fix potential race condition
  rtlwifi: rtl8821ae: Fix potential race condition

 drivers/net/wireless/realtek/rtlwifi/ps.c          | 25 ++++++++--------------
 drivers/net/wireless/realtek/rtlwifi/ps.h          |  3 ---
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.c    |  2 ++
 .../net/wireless/realtek/rtlwifi/rtl8192ee/dm.c    |  2 ++
 .../net/wireless/realtek/rtlwifi/rtl8723ae/dm.c    |  2 ++
 .../net/wireless/realtek/rtlwifi/rtl8723be/dm.c    |  2 ++
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    |  2 ++
 7 files changed, 19 insertions(+), 19 deletions(-)

-- 
2.1.4

