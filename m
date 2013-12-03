Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35823 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753074Ab3LCHSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 02:18:41 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 00/12] mwifiex updates for 3.14
Date: Mon, 2 Dec 2013 23:17:47 -0800
Message-ID: <1386055079-6623-1-git-send-email-bzhao@marvell.com> (sfid-20131203_081850_653690_1DDAA666)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches improve statistics update as well as
endian conversion. Some of them appear to be suitable
for earlier kernel versions but I want to have them
well cooked in 3.14.

Amitkumar Karwar (5):
  mwifiex: declare snap_type as __be16 variable
  mwifiex: remove rfc1042_eth_hdr variable
  mwifiex: fix an issue with Appletalk devices
  mwifiex: remove redundant goto exit_remove statement
  mwifiex: improvements in mwifiex_ret_tx_power_cfg()

Bing Zhao (1):
  mwifiex: avoid using variable name eth_hdr

Ujjal Roy (6):
  mwifiex: use little-endian variables in firmware structures
  mwifiex: fix rx_pending count imbalance
  mwifiex: correct RX byte count statistics
  mwifiex: correct TX byte count statistics
  mwifiex: update statistics for bridged packets on AP interface
  mwifiex: do not flood kmsg/dmesg with USB debug messages

 drivers/net/wireless/mwifiex/11n_aggr.c    |  6 ++--
 drivers/net/wireless/mwifiex/cfg80211.c    |  1 +
 drivers/net/wireless/mwifiex/cmdevt.c      |  4 +--
 drivers/net/wireless/mwifiex/decl.h        |  1 +
 drivers/net/wireless/mwifiex/fw.h          | 30 ++++++++++----------
 drivers/net/wireless/mwifiex/init.c        |  3 +-
 drivers/net/wireless/mwifiex/main.c        |  9 ++----
 drivers/net/wireless/mwifiex/main.h        |  2 +-
 drivers/net/wireless/mwifiex/sta_cmd.c     |  2 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 35 +++++++++++-------------
 drivers/net/wireless/mwifiex/sta_rx.c      | 44 +++++++++++++-----------------
 drivers/net/wireless/mwifiex/sta_tx.c      |  1 +
 drivers/net/wireless/mwifiex/txrx.c        | 15 +++++++---
 drivers/net/wireless/mwifiex/uap_txrx.c    | 39 +++++++++++++++-----------
 drivers/net/wireless/mwifiex/usb.c         |  4 +--
 drivers/net/wireless/mwifiex/util.c        |  5 ++--
 16 files changed, 103 insertions(+), 98 deletions(-)

-- 
1.8.2.3

