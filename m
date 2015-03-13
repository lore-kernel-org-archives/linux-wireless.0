Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24949 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609AbbCMGic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 02:38:32 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t2D6ZVwV007167
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 23:38:31 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1t3pmg8hw8-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 23:38:31 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<crlo@marvell.com>, <pchen@marvell.com>, <szli@marvell.com>,
	<nishants@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCHv2 0/9] mwifiex throughput enhancements 
Date: Fri, 13 Mar 2015 17:37:50 +0530
Message-ID: <1426248479-28451-1-git-send-email-patila@marvell.com> (sfid-20150313_073835_203392_33EA5E96)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series is culmination of two month long activity for
throughput enhancment which involved collecting multiple data points
including multiple driver idle times, study of FW<->SDIO bus<->driver
interaction and profiling and different approaches to overcoming current
shortcomings in driver.

For TX, we have tried to optimize data path and reduce delays incurred during
scheduling of work items and idle timeout between TX write to FW and TX DONE
from FW.

For RX, this patch series adds a new type of aggregation- single port
aggregation for SDIO. SP aggregation needs FW support and it would be
enabled only when FW advertises support for SP aggregation.

Our experiments show improvement of almost 30% in TX and 40% in RX on
both X86 based and ARM based platforms.

Avinash Patil (3):
  mwifiex: lock main process till reinitialization of vif is over
  mwifiex: rename alloc_rx_buf to alloc_dma_aligned_buf
  mwifiex: enhance SD8897 MP aggregation limits

Shengzhen Li (1):
  mwifiex: avoid queue_work while work is ongoing

Zhaoyang Liu (5):
  mwifiex: get rid of BA setup helper functions
  mwifiex: remove_bss_prio_lock
  mwifiex: preprocess packets from TX queue
  mwifiex: add SDIO rx single port aggregation
  mwifiex: delay skb allocation for RX until cmd53 over

 drivers/net/wireless/mwifiex/11n.c           |  18 ++-
 drivers/net/wireless/mwifiex/11n.h           |  32 ------
 drivers/net/wireless/mwifiex/11n_aggr.c      |  16 ++-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   7 +-
 drivers/net/wireless/mwifiex/cfg80211.c      |  33 ++++++
 drivers/net/wireless/mwifiex/decl.h          |  10 +-
 drivers/net/wireless/mwifiex/fw.h            |   9 ++
 drivers/net/wireless/mwifiex/init.c          |   5 +
 drivers/net/wireless/mwifiex/main.c          |  71 ++++++++++--
 drivers/net/wireless/mwifiex/main.h          |  27 ++++-
 drivers/net/wireless/mwifiex/pcie.c          |  10 +-
 drivers/net/wireless/mwifiex/sdio.c          | 163 ++++++++++++++++++++-------
 drivers/net/wireless/mwifiex/sdio.h          |  14 ++-
 drivers/net/wireless/mwifiex/sta_cmd.c       |  40 +++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |  21 ++++
 drivers/net/wireless/mwifiex/txrx.c          | 125 ++++++++++++++++++++
 drivers/net/wireless/mwifiex/usb.c           |   4 +-
 drivers/net/wireless/mwifiex/util.c          |   4 +-
 drivers/net/wireless/mwifiex/wmm.c           |  48 ++++----
 drivers/net/wireless/mwifiex/wmm.h           |   2 +
 20 files changed, 529 insertions(+), 130 deletions(-)

-- 
1.8.1.4

