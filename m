Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64914 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2AKXH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 18:07:28 -0500
Received: by iabz25 with SMTP id z25so1744774iab.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2012 15:07:27 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] rtlwifi: Cleanup the macros that read/write the RX/TX descriptors
Date: Wed, 11 Jan 2012 17:07:07 -0600
Message-Id: <1326323232-21752-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120112_000732_545091_A137D0D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Each of the drivers under rtlwifi contains its own copy of the macros described in
the subject. In addition, there are macros defined for each field even if those
particular bits are never accessed. The cleanup consists of moving all such
macros to a special file, eliminate duplication, and removing all macros that
are defined but not used. These changes remove over 1200 lines of source code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Larry Finger (5):
  rtlwifi: Move RX/TX macros into common file
  rtl8192ce: Switch to use the combined macros file
  rtl8192cu: Convert driver to use the new macros file
  rtl8192de: Change driver to use new macros file
  rtl8192se: Convert driver to use the new macro file

 drivers/net/wireless/rtlwifi/macros.h        |  460 ++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h |  499 +-------------------------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |  193 +++++-----
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h |  310 +----------------
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h |  499 +-------------------------
 drivers/net/wireless/rtlwifi/rtl8192se/def.h |  406 +---------------------
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |  121 ++++---
 9 files changed, 635 insertions(+), 1863 deletions(-)
 create mode 100644 drivers/net/wireless/rtlwifi/macros.h

-- 
1.7.7

