Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54638 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626AbZIANMl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 09:12:41 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 0/9] iwmc3200wifi updates
Date: Tue,  1 Sep 2009 15:13:57 +0200
Message-Id: <cover.1251809163.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This 9 patches serie is the latest iwmc3200wifi update.
All of them are targeted for a wireless-testing inclusion, hoping it's not too
late to make it to the next merge window.

Samuel Ortiz (5):
  iwmc3200wifi: Set WEP key from connect
  iwmc3200wifi: Fix sparse warning
  iwmc3200wifi: New initial LMAC calibration
  iwmc3200wifi: Handle UMAC stalls and UMAC assert properly
  iwmc3200wifi: Add a last_fw_err debugfs entry

Zhu Yi (4):
  iwmc3200wifi: invalidate profile when necessary before connect
  iwmc3200wifi: use cfg80211_roamed to send roam event
  iwmc3200wifi: add disconnect work
  iwmc3200wifi: fix misuse of le16_to_cpu

 drivers/net/wireless/iwmc3200wifi/cfg80211.c |   66 ++++++++++++++--
 drivers/net/wireless/iwmc3200wifi/commands.c |    1 +
 drivers/net/wireless/iwmc3200wifi/debug.h    |    2 +
 drivers/net/wireless/iwmc3200wifi/debugfs.c  |  105 +++++++++++++++++++++++++-
 drivers/net/wireless/iwmc3200wifi/fw.c       |   56 ++++++++++----
 drivers/net/wireless/iwmc3200wifi/iwm.h      |    8 ++-
 drivers/net/wireless/iwmc3200wifi/lmac.h     |   15 ++++
 drivers/net/wireless/iwmc3200wifi/main.c     |   60 +++++++++++++--
 drivers/net/wireless/iwmc3200wifi/rx.c       |   87 +++++++++++++++++----
 9 files changed, 345 insertions(+), 55 deletions(-)

