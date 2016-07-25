Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25535 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752905AbcGYPvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2016 11:51:37 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6PFoFQa031659
	for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2016 08:51:36 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 24c5xkfr04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2016 08:51:36 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 0/8] mwifiex patches
Date: Mon, 25 Jul 2016 21:21:03 +0530
Message-ID: <1469461871-3135-1-git-send-email-akarwar@marvell.com> (sfid-20160725_175141_282486_854DF11F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series includes couple of fixes and enhancements.

Changes in v2:
  1) Dropped "[5/9] mwifiex: cfg80211 set_default_mgmt_key handler"
     patch in v1 series. We are working on review comment from Jouni
     Malinen.
  2) Removed MWIFIEX_RX_PKT_DROPPED_IN_FW macro in "[6/9] mwifiex:
     process rxba_sync event" and used NULL pointer to indicate dropped
     packet(Kalle Valo).

Amitkumar Karwar (2):
  mwifiex: fix failed to reconnect after interface disabled/enabled
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
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |  78 ++++++++++-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.h   |   3 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  19 ++-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |  18 ++-
 drivers/net/wireless/marvell/mwifiex/debugfs.c     |   2 +
 drivers/net/wireless/marvell/mwifiex/fw.h          |  58 ++++++---
 drivers/net/wireless/marvell/mwifiex/main.h        |   1 +
 drivers/net/wireless/marvell/mwifiex/scan.c        |  16 +++
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  27 ++--
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   | 144 ++++++++++++++++++++-
 drivers/net/wireless/marvell/mwifiex/uap_event.c   |   7 +-
 14 files changed, 350 insertions(+), 59 deletions(-)

-- 
1.9.1

