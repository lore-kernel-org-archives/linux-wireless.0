Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37778 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab2DSVdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 17:33:00 -0400
Received: by iagz16 with SMTP id z16so12437635iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 14:32:59 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/6 V2] rtlwifi: Move global variables into private data structures
Date: Thu, 19 Apr 2012 16:32:38 -0500
Message-Id: <1334871164-9795-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120419_233308_868768_3700E3A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The drivers rtl8192ce and rtl8192cu have some global variables that are
incorrectly mingled whenever both kinds of devices are present on a
sytem. Drivers rtl8192de and rtl8192se have the same problem if there
are more than a single device present.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

I doubt that many systems ever have more than one of these devices present,
thus these patches can wait for 3.5. The only real exception is RTL8192DE,
which registers as two distinct MACs - one at 2.4 GHz, and the other at 5
GHz. These devices are quite rare, and it is unlikely that both units
will be operating simultaneously unless they form the basis of a dual-band
AP. 

Larry
---

V2 - fixed a problem with referencing the private-data struct.

Larry Finger (6):
  rtlwifi: Move dig_t and ps_t structs
  rtlwifi: Add dm structs to private structure
  rtlwifi: rtl8192c: Convert driver to use private dm structs
  rtlwifi: rtl8192c: Convert driver to use private ps_t struct
  rtlwifi: rtl8192de: Convert driver to use private dm structs
  rtlwifi: rtl8192se: Convert driver to use private dm struct

 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c  |  290 +++++++++++---------
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h  |   35 ---
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.h        |   35 ---
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c        |  185 +++++++------
 drivers/net/wireless/rtlwifi/rtl8192de/dm.h        |   51 ----
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c       |    7 +-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c        |  156 ++++++-----
 drivers/net/wireless/rtlwifi/rtl8192se/dm.h        |   44 ---
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c       |    7 +-
 drivers/net/wireless/rtlwifi/wifi.h                |   63 +++++
 11 files changed, 401 insertions(+), 473 deletions(-)

-- 
1.7.10.130.g36e6c

