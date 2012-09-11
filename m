Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:48328 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756059Ab2IKBbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 21:31:24 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 00/10] mwifiex: updates for 3.7
Date: Mon, 10 Sep 2012 18:30:39 -0700
Message-Id: <1347327049-13665-1-git-send-email-bzhao@marvell.com> (sfid-20120911_033128_443439_82BFF233)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series includes some random updates for AP mode, 11d handling
and code cleanup.

Thanks,
Bing

---
Amitkumar Karwar (7):
  mwifiex: remove get operation code for SUBSCRIBE EVENT command
  mwifiex: remove 11N_CFG command response handler
  mwifiex: remove AMSDU_AGGR_CTRL command response handler
  mwifiex: have same priority for AP and station traffic
  mwifiex: update adapter->bss_prio_tbl[j].bss_prio_cur correctly
  mwifiex: use country ie of requested AP while associating
  mwifiex: support custom world regulatory domain

Avinash Patil (1):
  mwifiex: separate TxPD processing routine for AP

Bing Zhao (2):
  mwifiex: do not hint regulatory domain with f/w country code
  mwifiex: disable WOW by default

 drivers/net/wireless/mwifiex/11n.c         |   38 ---------------
 drivers/net/wireless/mwifiex/11n.h         |    5 --
 drivers/net/wireless/mwifiex/cfg80211.c    |   45 +++++++++++++++--
 drivers/net/wireless/mwifiex/fw.h          |    2 +-
 drivers/net/wireless/mwifiex/main.c        |    1 -
 drivers/net/wireless/mwifiex/main.h        |    1 +
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   11 +----
 drivers/net/wireless/mwifiex/sta_ioctl.c   |   40 ++++++++++++++++
 drivers/net/wireless/mwifiex/txrx.c        |    6 ++-
 drivers/net/wireless/mwifiex/uap_txrx.c    |   70 ++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/wmm.c         |    9 ++--
 11 files changed, 162 insertions(+), 66 deletions(-)

