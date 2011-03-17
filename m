Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:42452 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab1CQAGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 20:06:15 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 00/11] remove configuration APIs from debugfs (part 2)
Date: Wed, 16 Mar 2011 17:09:23 -0700
Message-Id: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series removes some of the configuration APIs plus some WEP code
cleanups

Amitkumar Karwar (7):
  mwifiex: remove mpactrl command from debugfs
  mwifiex: remove antcfg command from debugfs
  mwifiex: remove esuppmode command from debugfs
  mwifiex: remove passphrase command from debugfs
  mwifiex: remove unnecessary flag ewpa_enabled
  mwifiex: remove some redundant WEP key handling
  mwifiex: optimize add_key callback function

Marc Yang (2):
  mwifiex: remove txratecfg command from debugfs
  mwifiex: remove httxcfg command from debugfs

Yogesh Ashok Powar (2):
  mwifiex: remove txbufcfg command from debugfs
  mwifiex: remove amsduaggrctrl command from debugfs

 drivers/net/wireless/mwifiex/11n.c         |   45 --
 drivers/net/wireless/mwifiex/11n.h         |    8 -
 drivers/net/wireless/mwifiex/README        |  291 -----------
 drivers/net/wireless/mwifiex/cfg80211.c    |    3 -
 drivers/net/wireless/mwifiex/debugfs.c     |  695 -------------------------
 drivers/net/wireless/mwifiex/decl.h        |    4 -
 drivers/net/wireless/mwifiex/fw.h          |   95 ----
 drivers/net/wireless/mwifiex/init.c        |    1 -
 drivers/net/wireless/mwifiex/ioctl.h       |   42 --
 drivers/net/wireless/mwifiex/join.c        |   97 +----
 drivers/net/wireless/mwifiex/main.c        |  113 ----
 drivers/net/wireless/mwifiex/main.h        |   39 --
 drivers/net/wireless/mwifiex/scan.c        |   84 +---
 drivers/net/wireless/mwifiex/sdio.c        |  119 -----
 drivers/net/wireless/mwifiex/sta_cmd.c     |  176 -------
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  202 --------
 drivers/net/wireless/mwifiex/sta_event.c   |    1 -
 drivers/net/wireless/mwifiex/sta_ioctl.c   |  766 +---------------------------
 drivers/net/wireless/mwifiex/wmm.c         |    5 +-
 19 files changed, 32 insertions(+), 2754 deletions(-)

