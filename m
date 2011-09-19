Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41313 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab1ISQPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 12:15:22 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 0/9] ath6kl: Use cfg80211 BSS table without local node table
Date: Mon, 19 Sep 2011 19:14:58 +0300
Message-ID: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20110919_181526_062991_5FD14DD2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set fixes number of issues in how scan results were being
reported to cfg80211 by properly using the cfg80211 BSS inform
mechanism. There is no point in maintaining the internal node table in
ath6kl since it is not really used for anything and the duplicated table
implementation was just trying to handle functionality that is already
present in cfg80211. In addition to fixing various roaming cases that
resulted in errors due to incorrect information in the cfg80211 BSS
table, this series removes the internal node table implementation that
had its own issues that apparently could cause crashes in some cases.

Jouni Malinen (9):
  ath6kl: Fix BSS update on roaming
  ath6kl: Remove deprecated WMI_OPT_RX_FRAME_EVENTID processing
  ath6kl: Remove RSSI update for internal node table
  ath6kl: Remove unnecessary node table update on disconnect event
  ath6kl: Replace internal node table with cfg80211 BSS table
  ath6kl: Remove the unused node table implementation
  ath6kl: Remove unnecessary bssinfo event header conversion
  ath6kl: Update BSS information after connection
  ath6kl: Export beacon interval and DTIM period through STA info

 drivers/net/wireless/ath/ath6kl/Makefile   |    1 -
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  211 +++++---------
 drivers/net/wireless/ath/ath6kl/common.h   |   83 ------
 drivers/net/wireless/ath/ath6kl/core.h     |    6 +-
 drivers/net/wireless/ath/ath6kl/init.c     |    5 -
 drivers/net/wireless/ath/ath6kl/main.c     |   53 +---
 drivers/net/wireless/ath/ath6kl/node.c     |  234 ----------------
 drivers/net/wireless/ath/ath6kl/wmi.c      |  417 +++++-----------------------
 drivers/net/wireless/ath/ath6kl/wmi.h      |   33 +--
 9 files changed, 155 insertions(+), 888 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/ath6kl/node.c

-- 
1.7.4.1

