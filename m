Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49614 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2AaJyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 04:54:01 -0500
Received: by wics10 with SMTP id s10so4215776wic.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 01:53:59 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 00/10] wl12xx: update fw api
Date: Tue, 31 Jan 2012 11:57:15 +0200
Message-Id: <1328003845-3926-1-git-send-email-eliad@wizery.com> (sfid-20120131_105406_597259_7B54E80A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fw api was changed in the latest FWs (6.3.5.0.95 for wl127x
and 7.3.5.0.95 for wl128x).

Along with some small adjustments, the main changes
inroduced by this patheset are configuring the
templates per-role, and moving to IEEE80211_HW_SUPPORTS_DYNAMIC_PS
mode.

v2:
	- prevent the driver from working in the transitional
	  commits (thanks Kalle & Luca)
	- squash some patches (thanks Luca)

Eliad Peller (4):
  wl12xx: fw api change - add role_id to set_template
  wl12xx: use dev_role_id for scans
  wl12xx: fw api change - add role_id to tsf_info
  wl12xx: fw api change - update cmd/acx/event enums

Eyal Shapira (6):
  wl12xx: remove PS management code
  wl12xx: add support for HW dynamic PS
  wl12xx: add dynamic_ps_timeout debugfs file
  wl12xx: remove 2 unused parameters in wl1271_ps_set_mode()
  wl12xx: enable/disable BET with AUTO_PS/ACTIVE
  wl12xx: change WLVIF_FLAG_PSM name and remove
    WLVIF_FLAG_PSM_REQUESTED

 drivers/net/wireless/wl12xx/acx.c     |    7 +-
 drivers/net/wireless/wl12xx/acx.h     |  146 ++++++++++++++++---------------
 drivers/net/wireless/wl12xx/boot.c    |    3 +-
 drivers/net/wireless/wl12xx/cmd.c     |   55 ++++++++----
 drivers/net/wireless/wl12xx/cmd.h     |  145 +++++++++++++++++-------------
 drivers/net/wireless/wl12xx/conf.h    |   13 ++--
 drivers/net/wireless/wl12xx/debugfs.c |   66 ++++++++++++++-
 drivers/net/wireless/wl12xx/event.c   |  151 -------------------------------
 drivers/net/wireless/wl12xx/event.h   |   20 +++--
 drivers/net/wireless/wl12xx/init.c    |   45 ++++++---
 drivers/net/wireless/wl12xx/main.c    |  158 +++++++--------------------------
 drivers/net/wireless/wl12xx/ps.c      |   32 +++++--
 drivers/net/wireless/wl12xx/ps.h      |    2 +-
 drivers/net/wireless/wl12xx/scan.c    |   42 ++++++---
 drivers/net/wireless/wl12xx/wl12xx.h  |   13 +--
 15 files changed, 399 insertions(+), 499 deletions(-)

-- 
1.7.6.401.g6a319

