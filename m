Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61798 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751694AbaLWIOj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 03:14:39 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id sBN8Ecls010306
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:38 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1rd602pta7-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:38 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<huxm@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 0/8] mwifiex debug enhancements
Date: Tue, 23 Dec 2014 19:14:04 +0530
Message-ID: <1419342252-2702-1-git-send-email-patila@marvell.com> (sfid-20141223_091449_400877_16FCB077)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds debug enhancements for mwifiex driver.
Patch series includes patches to dump SDIO function registers/scratch
registers upon FW crash, histogram support, adapter structure dump,
TDLS peer information via debugfs.
Also a patch to control auto deepsleep via module load parameter is added.

Avinash Patil (1):
  mwifiex: module parameter for deep sleep configuration

Xinming Hu (7):
  mwifiex: report tdls peers in debugfs
  mwifiex: add bcn_rcv_cnt and bcn_miss_cnt in getlog debugfs
  mwifiex: add rx histogram statistics support
  mwifiex: move pm_wakeup_card_complete definition to usb.c
  mwifiex: move debug_data dump function to common utililty file
  mwifiex: save driver information to file when firmware dump
  mwifiex: save sdio register values before firmware dump

 drivers/net/wireless/mwifiex/cfg80211.c    |   4 +
 drivers/net/wireless/mwifiex/cfp.c         |  18 ++
 drivers/net/wireless/mwifiex/debugfs.c     | 281 +++++++++++------------------
 drivers/net/wireless/mwifiex/decl.h        |  25 +++
 drivers/net/wireless/mwifiex/ethtool.c     |  16 +-
 drivers/net/wireless/mwifiex/fw.h          |   2 +
 drivers/net/wireless/mwifiex/init.c        |   5 +
 drivers/net/wireless/mwifiex/ioctl.h       |  11 +-
 drivers/net/wireless/mwifiex/main.c        | 116 ++++++++++++
 drivers/net/wireless/mwifiex/main.h        |  22 +++
 drivers/net/wireless/mwifiex/sdio.c        |  96 ++++++++++
 drivers/net/wireless/mwifiex/sdio.h        |  26 +++
 drivers/net/wireless/mwifiex/sta_cmd.c     |   7 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   2 +
 drivers/net/wireless/mwifiex/sta_event.c   |   4 +
 drivers/net/wireless/mwifiex/sta_rx.c      |   9 +
 drivers/net/wireless/mwifiex/tdls.c        |  30 +++
 drivers/net/wireless/mwifiex/uap_event.c   |   2 +
 drivers/net/wireless/mwifiex/usb.c         |   7 +
 drivers/net/wireless/mwifiex/usb.h         |   7 -
 drivers/net/wireless/mwifiex/util.c        | 220 ++++++++++++++++++++++
 drivers/net/wireless/mwifiex/util.h        |  20 ++
 22 files changed, 747 insertions(+), 183 deletions(-)

-- 
1.8.1.4

