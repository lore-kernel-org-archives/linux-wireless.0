Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20103 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab3CMMNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 08:13:11 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 00/14] wil6210 patch set for 3.10
Date: Wed, 13 Mar 2013 14:12:37 +0200
Message-ID: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130313_131317_416468_AB209A61)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is set of patches for wil6210.

New features:
- shortened SW reset procedure
- temperature measurement
- updated firmware API

Rest is bug fixes and clean-ups.

Vladimir Kondratiev (14):
  wil6210: Remove local implementation of dynamic hexdump
  wil6210: handle linkup/linkdown WMI events
  wil6210: handle WMI_BA_STATUS_EVENTID
  wil6210: do not set IE's for beacon
  wil6210: Fix garbage sent to the FW with wmi_set_ie()
  wil6210: refactor connect_worker
  wil6210: use cfg80211_inform_bss_frame()
  wil6210: report all received mgmt frames
  wil6210: fix FW error notification
  wil6210: use WLAN_CAPABILITY_DMG_TYPE_MASK
  wil6210: headers clean-up
  wil6210: new SW reset
  wil6210: sync with new firmware
  wil6210: temperature measurement

 drivers/net/wireless/ath/wil6210/cfg80211.c    |   31 +-
 drivers/net/wireless/ath/wil6210/dbg_hexdump.h |   20 --
 drivers/net/wireless/ath/wil6210/debugfs.c     |   44 +++
 drivers/net/wireless/ath/wil6210/interrupt.c   |   25 +-
 drivers/net/wireless/ath/wil6210/main.c        |   60 ++--
 drivers/net/wireless/ath/wil6210/netdev.c      |    3 -
 drivers/net/wireless/ath/wil6210/pcie_bus.c    |    3 -
 drivers/net/wireless/ath/wil6210/txrx.c        |    5 +-
 drivers/net/wireless/ath/wil6210/wil6210.h     |   17 +-
 drivers/net/wireless/ath/wil6210/wmi.c         |  154 +++++++---
 drivers/net/wireless/ath/wil6210/wmi.h         |  363 +++++++++++++++++-------
 11 files changed, 490 insertions(+), 235 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/wil6210/dbg_hexdump.h

-- 
1.7.10.4

