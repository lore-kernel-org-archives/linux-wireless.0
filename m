Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plaes.org ([188.166.43.21]:54655 "EHLO plaes.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751693AbbCVNgF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 09:36:05 -0400
From: Priit Laes <plaes@plaes.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Joe Perches <joe@perches.com>, Priit Laes <plaes@plaes.org>
Subject: [PATCH v2 0/4] rtlwifi: Use common functions for driver stats
Date: Sun, 22 Mar 2015 15:35:16 +0200
Message-Id: <1427031320-10913-1-git-send-email-plaes@plaes.org> (sfid-20150322_143626_303203_337BE2DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

This is a small fixup to unify make the drivers use common helper
functions for driver statistics.

There are no functional changes since the first posting, except dropping
patches already applied and addressing the comments by Joe Perches.

Priit Laes (4):
  rtlwifi: Use common rtl_evm_db_to_percentage
  rtlwifi: Use common rtl_signal_scale_mapping
  rtlwifi: Rename rtl_translate_todbm to rtl_signalpower_todbm
  rtlwifi: Use common rtl_query_rxpwrpercentage function

 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c |  8 ++--
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c | 70 ++--------------------------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c | 67 +++-----------------------
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c | 68 ++++-----------------------
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.c |  8 ++--
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |  8 ++--
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c |  8 ++--
 drivers/net/wireless/rtlwifi/rtl8723be/trx.c |  8 ++--
 drivers/net/wireless/rtlwifi/rtl8821ae/trx.c |  8 ++--
 drivers/net/wireless/rtlwifi/stats.c         | 27 +++++------
 drivers/net/wireless/rtlwifi/stats.h         |  2 +-
 11 files changed, 55 insertions(+), 227 deletions(-)

-- 
2.3.3

