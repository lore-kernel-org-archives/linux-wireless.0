Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:32901 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbbHCU4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 16:56:25 -0400
Received: by obdeg2 with SMTP id eg2so108400834obd.0
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 13:56:25 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH NEXT 0/6] rtlwifi: Fix firmware header issues
Date: Mon,  3 Aug 2015 15:56:10 -0500
Message-Id: <1438635376-28114-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150803_225630_785256_808461FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


While fixing an endian issue introduced in commit e996db69833a,
I realized that there were similar endian issues in several
of the drivers. In addition, these drivers were all defining a
similar struct. A single common definition is moved into the
main header, and all drivers are converted to use it. This
process exposed several endian issues that were not previously
detected by Sparse.

Larry Finger (6):
  irtlwifi: rtl8192ce: rtl8192cu: Fix endian issue
  rtlwifi: rtl8723ae: rtl8723be: rtl8723com: Fix firmware header endian
    issues
  rtlwifi: rtl8821ae: Fix firmware endian issues
  rtlwifi: rtl8192de: Fix firmware header endian issues
  rtlwifi: rtl888ee: Fix firmware header endian issues
  rtlwifi: rtl8192ee: Fix firmware header endian issues

 drivers/net/wireless/rtlwifi/rtl8188ee/fw.c        | 10 ++++-----
 drivers/net/wireless/rtlwifi/rtl8188ee/fw.h        | 21 +-----------------
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c  | 12 +++++------
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h  | 19 ----------------
 drivers/net/wireless/rtlwifi/rtl8192de/fw.h        | 22 -------------------
 drivers/net/wireless/rtlwifi/rtl8192ee/fw.c        | 12 +++++------
 drivers/net/wireless/rtlwifi/rtl8192ee/fw.h        | 21 +-----------------
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c        |  4 ++--
 drivers/net/wireless/rtlwifi/rtl8723be/sw.c        |  4 ++--
 .../net/wireless/rtlwifi/rtl8723com/fw_common.c    | 10 ++++-----
 .../net/wireless/rtlwifi/rtl8723com/fw_common.h    | 19 ----------------
 drivers/net/wireless/rtlwifi/rtl8821ae/fw.c        | 14 ++++++------
 drivers/net/wireless/rtlwifi/rtl8821ae/fw.h        | 23 ++------------------
 drivers/net/wireless/rtlwifi/wifi.h                | 25 +++++++++++++++++-----
 14 files changed, 57 insertions(+), 159 deletions(-)

-- 
2.1.4

