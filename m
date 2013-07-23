Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:43356 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473Ab3GWCSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:18:46 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 00/21] mwifiex updates for 3.12
Date: Mon, 22 Jul 2013 19:17:37 -0700
Message-ID: <1374545878-15683-1-git-send-email-bzhao@marvell.com> (sfid-20130723_041900_525564_11AE0EF7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series includes error case handling, bridged packet handling
in AP mode, p2p updates, random cleanups, etc.

Amitkumar Karwar (11):
  mwifiex: add PCIe shutdown handler to avoid system hang on reboot
  mwifiex: move del_timer_sync(scan_delay_timer) call to fix memleak
  mwifiex: remove unnecessary del_timer(cmd_timer)
  mwifiex: move if_ops.cleanup_if() call
  mwifiex: add unregister_dev handler for usb interface
  mwifiex: reduce firmware poll retries
  mwifiex: replace mdelay with msleep
  mwifiex: correction in mwifiex_check_fw_status() return status
  mwifiex: handle driver initialization error paths
  mwifiex: code rearrangement in sdio.c
  mwifiex: remove duplicate structure host_cmd_tlv

Avinash Patil (5):
  mwifiex: rename pkt_count to ba_pkt_count in mwifiex_ra_list_tbl
    struct
  mwifiex: maintain outstanding packet count for RA list instead of
    packet size
  mwifiex: delete AP TX queues when bridged packets reach threshold
  mwifiex: correct max IE length check for WPS IE
  mwifiex: modify mwifiex_ap_sta_limits to advertise support for P2P

Huawei Yang (2):
  mwifiex: remove stop_net_dev_queue operation in AP forwarding
  mwifiex: add tx info to skb when forming mgmt frame

Stone Piao (3):
  mwifiex: discard deauth and disassoc event during WPS session
  mwifiex: skip registering mgmt frame that has already registered
  mwifiex: support to send deauth for P2P client

 drivers/net/wireless/mwifiex/11n_aggr.c  |   4 +-
 drivers/net/wireless/mwifiex/cfg80211.c  |  25 +++-
 drivers/net/wireless/mwifiex/decl.h      |   3 +-
 drivers/net/wireless/mwifiex/fw.h        |  44 +++----
 drivers/net/wireless/mwifiex/ie.c        |   2 +-
 drivers/net/wireless/mwifiex/init.c      |  14 +-
 drivers/net/wireless/mwifiex/join.c      |   1 +
 drivers/net/wireless/mwifiex/main.c      |  87 +++++++++----
 drivers/net/wireless/mwifiex/main.h      |   6 +-
 drivers/net/wireless/mwifiex/pcie.c      |  13 +-
 drivers/net/wireless/mwifiex/sdio.c      | 213 +++++++++++++++----------------
 drivers/net/wireless/mwifiex/sta_cmd.c   |   5 +-
 drivers/net/wireless/mwifiex/sta_event.c |  10 ++
 drivers/net/wireless/mwifiex/sta_ioctl.c |  11 +-
 drivers/net/wireless/mwifiex/uap_cmd.c   | 130 ++++++++++---------
 drivers/net/wireless/mwifiex/uap_txrx.c  |  70 +++++++++-
 drivers/net/wireless/mwifiex/usb.c       |   8 ++
 drivers/net/wireless/mwifiex/wmm.c       |  16 +--
 18 files changed, 390 insertions(+), 272 deletions(-)

-- 
1.8.2.3

