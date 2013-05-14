Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:35639 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222Ab3ENBRq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 21:17:46 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@laptop.org>, Paul Fox <pgf@laptop.org>,
	Tim Shepard <shep@laptop.org>,
	Jason Abele <jabele@chromium.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 00/17] mwifiex updates for 3.11
Date: Mon, 13 May 2013 18:14:44 -0700
Message-ID: <1368494101-23651-1-git-send-email-bzhao@marvell.com> (sfid-20130514_031749_060141_69A5FA47)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds support for new chipset SD8897, calibration data
downloading, del_station handler, as well as some random cleanups
and updates.


Amitkumar Karwar (12):
  mwifiex: rename mwifiex_free_adapter() routine in init.c
  mwifiex: scan delay timer cleanup in unload path
  mwifiex: remove global user_scan_cfg variable
  mwifiex: add calibration data download feature
  mwifiex: use u32 variables for SDIO read/write port bitmap
  mwifiex: store SDIO chip specific information in separate structure
  mwifiex: replace unnecessary u32 variables with u8 in sdio.c
  mwifiex: code rearrangement in mwifiex_get_rd_port()
  mwifiex: do port calculations separately
  mwifiex: define a macro for MPA base address
  mwifiex: remove unnecessary macros in sdio.h
  mwifiex: code rearrangement in multiport aggregation path

Avinash Patil (3):
  mwifiex: avoid deleting all stations during mwifiex_del_sta_entry()
  mwifiex: add del_station handler
  mwifiex: replace spin_lock_irqsave with spin_lock and fix warn_on

Bing Zhao (1):
  mwifiex: abort remaining scan commands when association started

Yogesh Ashok Powar (1):
  mwifiex: add support for Marvell SD8897 chipset

 drivers/net/wireless/mwifiex/Kconfig       |   4 +-
 drivers/net/wireless/mwifiex/cfg80211.c    |  77 ++++-
 drivers/net/wireless/mwifiex/cmdevt.c      |   1 +
 drivers/net/wireless/mwifiex/fw.h          |  17 ++
 drivers/net/wireless/mwifiex/init.c        |  53 ++--
 drivers/net/wireless/mwifiex/main.c        |  14 +
 drivers/net/wireless/mwifiex/main.h        |   5 +-
 drivers/net/wireless/mwifiex/scan.c        |  23 +-
 drivers/net/wireless/mwifiex/sdio.c        | 462 ++++++++++++++++++++---------
 drivers/net/wireless/mwifiex/sdio.h        | 340 ++++++++++++++-------
 drivers/net/wireless/mwifiex/sta_cmd.c     |  62 ++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  17 ++
 drivers/net/wireless/mwifiex/uap_cmd.c     |  21 ++
 drivers/net/wireless/mwifiex/uap_event.c   |  25 +-
 14 files changed, 807 insertions(+), 314 deletions(-)

-- 
1.8.2.3

