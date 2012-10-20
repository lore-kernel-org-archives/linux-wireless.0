Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:38910 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751359Ab2JTCTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 22:19:50 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/7] mwifiex: patches for 3.8
Date: Fri, 19 Oct 2012 19:19:14 -0700
Message-Id: <1350699561-852-1-git-send-email-bzhao@marvell.com> (sfid-20121020_041958_795792_F17E9D2D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1st patch series intended for 3.8:
0001~0004: scan related improvements (Amitkumar Karwar)
     0005: revert a workaround patch for max_power (Amitkumar Karwar)
0006~0007: random updates (Amitkumar Karwar, Avinash Patil)

---
Amitkumar Karwar (5):
  mwifiex: use LOW_PRIORITY scan flag provided in scan request
  mwifiex: abort scan upon interface down
  mwifiex: minor cleanup and a fix in scan semaphore usage
  mwifiex: disable channel filtering for SSID specific scan from user
  Revert "mwifiex: retrieve correct max_power information in
    reg_notifier handler"

Avinash Patil (2):
  mwifiex: handle extended supported rates IE for AP
  mwifiex: rx path enhancement to derive priv only once

 drivers/net/wireless/mwifiex/11n_rxreorder.c |    8 ++---
 drivers/net/wireless/mwifiex/cfg80211.c      |   18 +++++++----
 drivers/net/wireless/mwifiex/init.c          |   19 ++++++-----
 drivers/net/wireless/mwifiex/main.c          |    8 +++++
 drivers/net/wireless/mwifiex/main.h          |   11 +++----
 drivers/net/wireless/mwifiex/scan.c          |   42 +++++++++++++++++--------
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |    4 --
 drivers/net/wireless/mwifiex/sta_rx.c        |   26 +++++-----------
 drivers/net/wireless/mwifiex/txrx.c          |   10 +++++-
 drivers/net/wireless/mwifiex/uap_cmd.c       |   11 ++++++-
 drivers/net/wireless/mwifiex/uap_txrx.c      |   17 +++-------
 drivers/net/wireless/mwifiex/util.c          |   19 ++----------
 12 files changed, 100 insertions(+), 93 deletions(-)

