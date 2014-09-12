Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55475 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827AbaILJKC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 05:10:02 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCHv2 00/16] mwifiex updates for 3.18 
Date: Fri, 12 Sep 2014 20:08:44 +0530
Message-ID: <1410532740-3173-1-git-send-email-patila@marvell.com> (sfid-20140912_111009_005968_4D777A1D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset brings in channel scan gap & RX work queue support to
mwifiex. With channel scan gap in, we remove low priority scan
handling feature.

Patset also includes trivial fixes for SDIO multiport aggregation,
one fix for A band association.

Amitkumar Karwar (4):
  mwifiex: fix a bug in Tx multiport aggregation
  mwifiex: minor cleanup in multiport aggregation
  mwifiex: remove redundant variable report_scan_result
  mwifiex: remove low priority scan handling

Avinash Patil (11):
  mwifiex: set fw api info for backword compatibility
  mwifiex: fix probable memory corruption while processing TDLS frame
  mwifiex: avoid processing RX packets with invalid length
  mwifiex: rework internal scan for association
  mwifiex: support for event done interrupt
  mwifiex: set passive scan type for scan requests with no ssid
  mwifiex: bring in scan channel gap feature
  mwifiex: remove restriction of single channel scan when connected
  mwifiex: process TX even when scan is ongoing
  mwifiex: add rx workqueue support
  mwifiex: modify TX/RX window sizes for AP interface

Xinming Hu (1):
  mwifiex: fix 5G association failure after leaving 2.4G IBSS

 drivers/net/wireless/mwifiex/11n_rxreorder.c |  14 ++
 drivers/net/wireless/mwifiex/cfg80211.c      |  14 +-
 drivers/net/wireless/mwifiex/cmdevt.c        |   4 +
 drivers/net/wireless/mwifiex/decl.h          |   4 +-
 drivers/net/wireless/mwifiex/fw.h            |  10 +-
 drivers/net/wireless/mwifiex/init.c          |  21 ++-
 drivers/net/wireless/mwifiex/main.c          | 191 +++++++++++++--------------
 drivers/net/wireless/mwifiex/main.h          |  48 +++++--
 drivers/net/wireless/mwifiex/pcie.c          |  37 +++++-
 drivers/net/wireless/mwifiex/pcie.h          |   5 +-
 drivers/net/wireless/mwifiex/scan.c          | 108 ++++++++++-----
 drivers/net/wireless/mwifiex/sdio.c          |  28 ++--
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |   2 -
 drivers/net/wireless/mwifiex/sta_ioctl.c     |   9 +-
 drivers/net/wireless/mwifiex/tdls.c          |   4 +-
 15 files changed, 317 insertions(+), 182 deletions(-)

-- 
1.8.1.4

