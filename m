Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26290 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030842AbcGKOzT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 10:55:19 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6BEpXmO032464
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 07:55:18 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 2430sge4sk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 07:55:17 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 0/9] mwifiex patches
Date: Mon, 11 Jul 2016 20:23:43 +0530
Message-ID: <1468248832-21969-1-git-send-email-akarwar@marvell.com> (sfid-20160711_165534_502491_7A3B88EA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series includes couple of fixes and enhancements.

Amitkumar Karwar (3):
  mwifiex: fix failed to reconnect after interface disabled/enabled
  mwifiex: cfg80211 set_default_mgmt_key handler
  mwifiex: remove misleading disconnect message

Ganapathi Bhat (2):
  mwifiex: support random MAC address for scanning
  mwifiex: fix radar detection issue

Karthik D A (2):
  mwifiex: Fixed endianness problem for big endian platform
  mwifiex: add region code information in debugfs

Xinming Hu (2):
  mwifiex: process rxba_sync event
  mwifiex: add HT aggregation support for adhoc mode

 drivers/net/wireless/marvell/mwifiex/11h.c         |  27 ++--
 drivers/net/wireless/marvell/mwifiex/11n.h         |   7 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |  79 ++++++++++-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.h   |   6 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  32 ++++-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |  18 ++-
 drivers/net/wireless/marvell/mwifiex/debugfs.c     |   2 +
 drivers/net/wireless/marvell/mwifiex/fw.h          |  58 ++++++---
 drivers/net/wireless/marvell/mwifiex/main.h        |   1 +
 drivers/net/wireless/marvell/mwifiex/scan.c        |  16 +++
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  27 ++--
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   | 144 ++++++++++++++++++++-
 drivers/net/wireless/marvell/mwifiex/uap_event.c   |   7 +-
 14 files changed, 367 insertions(+), 59 deletions(-)

-- 
1.9.1

