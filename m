Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28309 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145AbbIRNcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:32:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8IDOR8X027007
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:32:41 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 1wy3qpfe74-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:32:41 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 00/16] mwifiex fixes and USB multichannel
Date: Fri, 18 Sep 2015 06:32:02 -0700
Message-ID: <1442583138-2979-1-git-send-email-akarwar@marvell.com> (sfid-20150918_153245_776375_E72DAFBB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series includes few fixes and USB multichannel
feature support patch series

Amitkumar Karwar (2):
  mwifiex: avoid memsetting PCIe event buffer
  mwifiex: Suppress -ENOSR error for data traffic on USB

Aniket Nagarnaik (2):
  mwifiex: don't always include ht/vht info in tdls confirm frame
  mwifiex: fix NULL pointer dereference during hidden SSID scan

Xinming Hu (4):
  mwifiex: fix typo in del_virtual_intf() function
  mwifiex: minor corrections in multiport aggregation code
  mwifiex: fix driver init failure under memory pressure
  mwifiex: NULL check for cfg80211_inform_bss()

Zhaoyang Liu (8):
  mwifiex: update amsdu tx packet time stamp
  mwifiex: correct paused tx data packet counter
  mwifiex: fix tx data_sent issue for usb interface
  mwifiex: move usb specific data_sent update to usb.c
  mwifiex: add usb multi channel event process support
  mwifiex: add usb tx data multi endpoints support
  mwifiex: add usb multi endpoints resync support
  mwifiex: complete usb tx data with multi endpoints

 drivers/net/wireless/mwifiex/11n_aggr.c    |   8 +-
 drivers/net/wireless/mwifiex/cfg80211.c    |  12 +-
 drivers/net/wireless/mwifiex/fw.h          |  18 +++
 drivers/net/wireless/mwifiex/init.c        |   1 +
 drivers/net/wireless/mwifiex/main.c        |  60 +++++++-
 drivers/net/wireless/mwifiex/main.h        |   8 ++
 drivers/net/wireless/mwifiex/pcie.c        |   1 -
 drivers/net/wireless/mwifiex/scan.c        |  22 +--
 drivers/net/wireless/mwifiex/sdio.c        |  29 ++--
 drivers/net/wireless/mwifiex/sta_cmd.c     |   3 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  11 ++
 drivers/net/wireless/mwifiex/sta_event.c   |  78 ++++++++--
 drivers/net/wireless/mwifiex/sta_tx.c      |   7 +-
 drivers/net/wireless/mwifiex/tdls.c        |  12 ++
 drivers/net/wireless/mwifiex/txrx.c        |  19 +--
 drivers/net/wireless/mwifiex/uap_event.c   |   4 +-
 drivers/net/wireless/mwifiex/uap_txrx.c    |  10 +-
 drivers/net/wireless/mwifiex/usb.c         | 224 +++++++++++++++++++++++------
 drivers/net/wireless/mwifiex/usb.h         |  15 +-
 drivers/net/wireless/mwifiex/wmm.c         |  52 +++++--
 20 files changed, 469 insertions(+), 125 deletions(-)

-- 
1.8.1.4

