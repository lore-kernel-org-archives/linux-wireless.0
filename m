Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35054 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934609AbcCPSdx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 14:33:53 -0400
Received: by mail-oi0-f65.google.com with SMTP id r187so3062141oih.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 11:33:53 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/2] Add antenna selection code to rtl8723be
Date: Wed, 16 Mar 2016 13:33:33 -0500
Message-Id: <1458153215-25602-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160316_193357_095961_2F50A336)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches fix a problem that occurs for laptops that are constructed
with only a single antenna, but have an incorrect programming of the
on-board EEPROM.

These changes have been extensively tested in the rtlwifi_new repo
at GitHub.com.

As the patches fix a deficiency rather than a bug, they probably need
to be submitted to the 4.7 stream. Because the fix is needed for stable
kernels, I have added the appropriate Cc.

Larry

Larry Finger (2):
  rtlwifi: rtl8723be: Add antenna select module parameter
  rtlwifi: btcoexist: Implement antenna selection

 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |  9 ++++++--
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 27 +++++++++++++++++++++-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  2 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |  5 +++-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |  5 ++++
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |  3 +++
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  3 +++
 7 files changed, 49 insertions(+), 5 deletions(-)

-- 
2.1.4

