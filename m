Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25275 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbbBAIzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 03:55:32 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 0/6] wil6210 patches
Date: Sun,  1 Feb 2015 10:55:10 +0200
Message-Id: <1422780916-8577-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150201_095545_698578_1CBC4C05)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Notable is Hamad's patch to remove not yet upstreamed
MSM-specific code, this fixes compilation on mainstream
kernel for MSM target.

Few improvements for Tx path

Hamad Kadmany (1):
  wil6210: Remove msm platform related code

Vladimir Kondratiev (5):
  wil6210: remove old Tx work-around
  wil6210: avoid Tx descriptor double write
  wil6210: fix race between xmit and Tx vring de-allocation
  wil6210: more Tx debug
  wil6210: print ciphers in debug info

 drivers/net/wireless/ath/wil6210/Kconfig           |   9 -
 drivers/net/wireless/ath/wil6210/Makefile          |   1 -
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  37 ++-
 drivers/net/wireless/ath/wil6210/txrx.c            |  62 +++--
 drivers/net/wireless/ath/wil6210/wil6210.h         |   1 +
 drivers/net/wireless/ath/wil6210/wil_platform.c    |  12 +-
 .../net/wireless/ath/wil6210/wil_platform_msm.c    | 257 ---------------------
 .../net/wireless/ath/wil6210/wil_platform_msm.h    |  24 --
 8 files changed, 67 insertions(+), 336 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/wil6210/wil_platform_msm.c
 delete mode 100644 drivers/net/wireless/ath/wil6210/wil_platform_msm.h

-- 
2.1.0

