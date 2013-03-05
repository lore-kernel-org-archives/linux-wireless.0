Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:52165 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742Ab3CEA2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 19:28:13 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Paul Fox <pgf@laptop.org>, Daniel Drake <dsd@laptop.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/7] mwifiex: patches for 3.10
Date: Mon,  4 Mar 2013 16:27:52 -0800
Message-Id: <1362443279-6064-1-git-send-email-bzhao@marvell.com> (sfid-20130305_012817_434934_A9692C33)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar's patches add configurations for wakeup on wlan.
Other patches are random updates, including fixing the warnings
reported by kbuild test robot.

Amitkumar Karwar (3):
  mwifiex: shorten the host sleep configuration macro names
  mwifiex: add "ethtool wol" command support
  mwifiex: add WOWLAN support

Avinash Patil (1):
  mwifiex: modify skb->truesize for PCIE Rx

Bing Zhao (3):
  mwifiex: remove static forward declarations in pcie.c
  mwifiex: fix [-Wunused-function] warnings on pcie suspend/resume
  mwifiex: avoid [-Wmaybe-uninitialized] warnings in pcie.c

 drivers/net/wireless/mwifiex/Makefile      |    1 +
 drivers/net/wireless/mwifiex/cfg80211.c    |  157 ++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/cmdevt.c      |    2 +-
 drivers/net/wireless/mwifiex/ethtool.c     |   70 ++++++++++++
 drivers/net/wireless/mwifiex/fw.h          |   44 +++++++-
 drivers/net/wireless/mwifiex/init.c        |    6 +-
 drivers/net/wireless/mwifiex/ioctl.h       |   23 ++++
 drivers/net/wireless/mwifiex/main.h        |    4 +
 drivers/net/wireless/mwifiex/pcie.c        |  156 ++++++++++++++--------------
 drivers/net/wireless/mwifiex/sta_cmd.c     |   79 ++++++++++++++-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    2 +
 drivers/net/wireless/mwifiex/sta_ioctl.c   |   10 +-
 drivers/net/wireless/mwifiex/util.c        |    5 +-
 13 files changed, 465 insertions(+), 94 deletions(-)
 create mode 100644 drivers/net/wireless/mwifiex/ethtool.c

