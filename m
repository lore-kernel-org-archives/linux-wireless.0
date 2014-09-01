Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59218 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbaIAHaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:30:09 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 00/17] mwifiex updates for 3.17
Date: Mon, 1 Sep 2014 18:28:48 +0530
Message-ID: <1409576345-13717-1-git-send-email-patila@marvell.com> (sfid-20140901_093021_564968_26043116)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series brings in scan enhancement including scan channel gap,
support for parsing FW API version from HW_SPEC command response,
support for processing RX in work queue and few trivial fixes for 
SDIO multiport aggregation.

Amitkumar Karwar (7):
  mwifiex: fix a bug in Tx multiport aggregation
  mwifiex: minor cleanup in multiport aggregation
  mwifiex: fix left_len calculation issue
  mwifiex: rename macro and variables related to API revision
  mwifiex: use firmware API revision from GET_HW_SPEC response
  mwifiex: remove redundant variable report_scan_result
  mwifiex: remove low priority scan handling

Avinash Patil (9):
  mwifiex: fix probable memory corruption while processing TDLS frame
  mwifiex: avoid processing RX packets with invalid length
  mwifiex: rework internal scan for association
  mwifiex: support for event done interrupt
  mwifiex: set passive scan type for scan requests with no ssid
  mwifiex: bring in scan channel gap feature
  mwifiex: remove restriction of single channel scan when connected
  mwifiex: process TX even when scan is ongoing
  mwifiex: add rx workqueue support

Xinming Hu (1):
  mwifiex: fix 5G association failure after leaving 2.4G IBSS

 drivers/net/wireless/mwifiex/11n_rxreorder.c |  14 ++
 drivers/net/wireless/mwifiex/cfg80211.c      |  13 +-
 drivers/net/wireless/mwifiex/cmdevt.c        |  28 ++--
 drivers/net/wireless/mwifiex/fw.h            |  17 ++-
 drivers/net/wireless/mwifiex/init.c          |  25 +++-
 drivers/net/wireless/mwifiex/main.c          | 194 +++++++++++++--------------
 drivers/net/wireless/mwifiex/main.h          |  49 +++++--
 drivers/net/wireless/mwifiex/pcie.c          |  37 ++++-
 drivers/net/wireless/mwifiex/pcie.h          |   5 +-
 drivers/net/wireless/mwifiex/scan.c          | 112 ++++++++++------
 drivers/net/wireless/mwifiex/sdio.c          |  28 ++--
 drivers/net/wireless/mwifiex/sta_cmd.c       |   2 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   4 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c     |  13 +-
 drivers/net/wireless/mwifiex/tdls.c          |   4 +-
 15 files changed, 339 insertions(+), 206 deletions(-)

-- 
1.8.1.4

