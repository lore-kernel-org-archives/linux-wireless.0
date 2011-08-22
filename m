Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43968 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab1HVVuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 17:50:39 -0400
Received: by gya6 with SMTP id 6so3903756gya.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 14:50:39 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn
Subject: [PATCH 0/5] rtlwifi: Simplify and update rate-mapping code
Date: Mon, 22 Aug 2011 16:50:13 -0500
Message-Id: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110822_235057_112147_9BDF14C7)
To: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While updating the rtlwifi family of drivers based on the latest vendor
driver, I became aware that each of them has its own routine for getting
a rate index from the descriptor rate. As the code is identical, these
patches move a copy of the updated routine to rtlwifi, and convert each
of the drivers to use that routine.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is -next material.

Larry
---

Larry Finger (5):
  rtlwifi: Install updated rate-mapping routine
  rtlwifi: rtl8192ce: Convert to use the new rate-mapping routine in
    rtlwifi
  rtlwifi: rtl8192cu: Convert to use the new rate-mapping routine in
    rtlwifi
  rtlwifi: rtl8192se: Convert to use the new rate-mapping routine in
    rtlwifi
  rtlwifi: rtl8192de: Convert to use the new rate-mapping routine in
    rtlwifi

 drivers/net/wireless/rtlwifi/base.c          |  161 ++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/base.h          |    2 +
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h |  139 ----------------------
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  |   30 +++---
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |  116 ++-----------------
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h |    8 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h |    8 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c  |   28 +++---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |   23 ++--
 drivers/net/wireless/rtlwifi/rtl8192de/def.h |   35 ------
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c  |   30 +++---
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c |  121 +++-----------------
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h |    8 +-
 drivers/net/wireless/rtlwifi/rtl8192se/def.h |   39 +------
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c  |   30 +++---
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |  124 ++------------------
 drivers/net/wireless/rtlwifi/wifi.h          |   35 ++++++
 19 files changed, 322 insertions(+), 621 deletions(-)

-- 
1.7.3.4

