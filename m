Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51485 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab1EQCNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 22:13:14 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/5] mwifiex: CPU mips optimization patch series
Date: Mon, 16 May 2011 19:17:48 -0700
Message-Id: <1305598673-26606-1-git-send-email-bzhao@marvell.com> (sfid-20110517_041325_168653_8E04369B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series optimizes CPU utilization

Marc Yang (5):
  mwifiex: reduce CPU usage by tracking tx_pkts_queued
  mwifiex: reduce CPU usage by tracking highest_queued_prio
  mwifiex: check mwifiex_wmm_lists_empty() before dequeue
  mwifiex: CPU mips optimization with NO_PKT_PRIO_TID
  mwifiex: adjust high/low water marks for tx_pending queue

 drivers/net/wireless/mwifiex/11n_aggr.c |    4 ++
 drivers/net/wireless/mwifiex/main.h     |    9 ++++-
 drivers/net/wireless/mwifiex/txrx.c     |    4 ++-
 drivers/net/wireless/mwifiex/wmm.c      |   59 ++++++++++++++++++++++++-------
 4 files changed, 60 insertions(+), 16 deletions(-)

