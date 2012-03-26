Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51303 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083Ab2CZSuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 14:50:12 -0400
Received: by iagz16 with SMTP id z16so8605045iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2012 11:50:11 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/6] rtlwifi: Convert drivers away from global copies of structures
Date: Mon, 26 Mar 2012 13:49:51 -0500
Message-Id: <1332787797-26475-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120326_205017_787075_A397C2D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All the rtlwifi-family of drivers contain 1 or 2 tables that are defined
on a "per-driver" basis. For systems that contain more than one interface,
each instance will not have its own copy.

This series of patches is to be applied to kernel 3.5.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry Finger (6):
  rtlwifi: Move dig_t and ps_t structs
  rtlwifi: Add dm structs to private structure
  rtlwifi: rtl8192c: Convert driver to use private dm structs
  rtlwifi: rtl8192c: Convert driver to use private ps_t struct
  rtlwifi: rtl8192de: Convert driver to use private dm structs
  rtlwifi: rtl8192se: Convert driver to use private dm structs

 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c  |   22 ++++++-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h  |   35 -----------
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.h        |   35 -----------
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c        |   11 +++-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.h        |   51 ----------------
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c       |    1 +
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c        |    6 ++-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.h        |   44 --------------
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c       |    1 +
 drivers/net/wireless/rtlwifi/wifi.h                |   63 ++++++++++++++++++++
 11 files changed, 99 insertions(+), 171 deletions(-)

-- 
1.7.7

