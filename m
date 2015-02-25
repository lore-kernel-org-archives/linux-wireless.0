Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2912 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751641AbbBYLV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 06:21:27 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t1PBIB3U017625
	for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 03:21:27 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1srpgjbga5-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 03:21:27 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<szli@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 0/4] mwifiex: throughput enhancements for TX 
Date: Wed, 25 Feb 2015 22:20:53 +0530
Message-ID: <1424883057-12102-1-git-send-email-patila@marvell.com> (sfid-20150225_122130_513162_553DF848)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series includes patches which improve TX throughputs.

Marc Yang (1):
  mwifiex: avoid queue_work while work is ongoing

Zhaoyang Liu (3):
  mwifiex: get rid of BA setup helper functions
  mwifiex: remove_bss_prio_lock
  mwifiex: preprocess packets from TX queue

 drivers/net/wireless/mwifiex/11n.c           |  18 +++-
 drivers/net/wireless/mwifiex/11n.h           |  32 -------
 drivers/net/wireless/mwifiex/11n_aggr.c      |  14 ++-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   7 +-
 drivers/net/wireless/mwifiex/cfg80211.c      |  33 +++++++
 drivers/net/wireless/mwifiex/decl.h          |   2 +
 drivers/net/wireless/mwifiex/init.c          |   5 ++
 drivers/net/wireless/mwifiex/main.c          |  71 ++++++++++++---
 drivers/net/wireless/mwifiex/main.h          |  21 +++--
 drivers/net/wireless/mwifiex/pcie.c          |   2 +-
 drivers/net/wireless/mwifiex/txrx.c          | 126 +++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/usb.c           |   4 +-
 drivers/net/wireless/mwifiex/wmm.c           |  49 ++++++-----
 drivers/net/wireless/mwifiex/wmm.h           |   2 +
 14 files changed, 305 insertions(+), 81 deletions(-)

-- 
1.8.1.4

