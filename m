Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:55464 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbaIDVEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 17:04:09 -0400
Received: by mail-oi0-f43.google.com with SMTP id i138so7967oig.16
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 14:04:08 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	troy_tan@realsil.com.cn
Subject: [PATCH 0/7 V3.18] Patches to upgrade driver btcoexist for latest (062814) Realtek code
Date: Thu,  4 Sep 2014 16:03:39 -0500
Message-Id: <1409864626-16373-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140904_230412_983818_196E98F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of patches fixes bugs in the Realtek drivers and adds the support
code for devices RTL8192EE and RTL8821AE. An earlier version of this code
resides in staging and will be removed when these patches, and the
corresponding drivers, reach net-next.

All this code is intended for the 3.18 stream.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: troy_tan@realsil.com.cn

Larry Finger (7):
  rtlwifi: btcoexist: Modify btcoexist for changes in the V062814
    Realtek version = part 1
  rtlwifi: btcoexist: Modify rtl_btc for changes in latest Realtek code
  rtlwifi: btcoexist: Modify driver for V062814 Realtek driver
  rtlwifi: btcoexist: Modify driver to support BT coexistence in
    rtl8723be
  rtlwifi: btcoexist: Add BT coexistence routines for driver rtl8821ae
  rtlwifi: btcoexist: Add second part of BT coexistence routines for
    rtl8821ae
  rtlwifi: btcoexist: Update remaining old parts of the driver

 .../net/wireless/rtlwifi/btcoexist/halbt_precomp.h |    6 +
 .../wireless/rtlwifi/btcoexist/halbtc8192e2ant.c   | 3888 +++++++++++++++++++
 .../wireless/rtlwifi/btcoexist/halbtc8192e2ant.h   |  185 +
 .../wireless/rtlwifi/btcoexist/halbtc8723b1ant.c   | 3211 ++++++++++++++++
 .../wireless/rtlwifi/btcoexist/halbtc8723b1ant.h   |  184 +
 .../wireless/rtlwifi/btcoexist/halbtc8723b2ant.c   |  447 ++-
 .../wireless/rtlwifi/btcoexist/halbtc8723b2ant.h   |   31 +-
 .../wireless/rtlwifi/btcoexist/halbtc8821a1ant.c   | 3010 +++++++++++++++
 .../wireless/rtlwifi/btcoexist/halbtc8821a1ant.h   |  188 +
 .../wireless/rtlwifi/btcoexist/halbtc8821a2ant.c   | 3914 ++++++++++++++++++++
 .../wireless/rtlwifi/btcoexist/halbtc8821a2ant.h   |  205 +
 .../net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c  |   47 +-
 .../net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h  |  118 +-
 drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c   |   27 +-
 drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h   |    6 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c   |    4 +-
 drivers/net/wireless/rtlwifi/wifi.h                |   15 +-
 17 files changed, 15165 insertions(+), 321 deletions(-)
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.h
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b1ant.c
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b1ant.h
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a1ant.c
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a1ant.h
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a2ant.c
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a2ant.h

-- 
1.8.4.5

