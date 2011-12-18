Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65208 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab1LRSYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Dec 2011 13:24:50 -0500
Received: by wibhm6 with SMTP id hm6so675676wib.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Dec 2011 10:24:48 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/7] wl12xx: various (multi-vif) fixes
Date: Sun, 18 Dec 2011 20:25:38 +0200
Message-Id: <1324232745-22928-1-git-send-email-eliad@wizery.com> (sfid-20111218_192453_871347_151864ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix some bugs related to multiple vifs support.

Eliad Peller (7):
  wl12xx: implement change_interface
  wl12xx: remove redundant code from wl1271_op_conf_tx
  wl12xx: make WL1271_FLAG_IDLE flag per-vif
  wl12xx: flush packets before stopping dev role
  wl12xx: fix checking of started dev role
  wl12xx: stop device role on remove_interface
  wl12xx: check the actual vif operstate in wl1271_dev_notify

 drivers/net/wireless/wl12xx/cmd.c    |    3 +
 drivers/net/wireless/wl12xx/main.c   |  100 +++++++++++++++++-----------------
 drivers/net/wireless/wl12xx/ps.c     |   10 +++-
 drivers/net/wireless/wl12xx/scan.c   |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +-
 5 files changed, 63 insertions(+), 54 deletions(-)

-- 
1.7.6.401.g6a319

