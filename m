Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24791 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284AbbLNMRC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:02 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBECFEvY012215
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:01 -0800
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0a-0016f401.pphosted.com with ESMTP id 1yswkxr03v-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:01 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 00/14] mwifiex fixes
Date: Mon, 14 Dec 2015 04:15:01 -0800
Message-ID: <1450095315-19927-1-git-send-email-akarwar@marvell.com> (sfid-20151214_131706_754762_207FCAEE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches include few fixes for mwifiex and add a
debugfs file for chip reset.

Amitkumar Karwar (6):
  mwifiex: suppress "Rx of mgmt packet failed" message
  mwifiex: remove redundant timestamp assignment
  mwifiex: add debugfs file for testing reset of card
  mwifiex: fix AMPDU not setup on TDLS link problem
  mwifiex: update region_code_index array
  mwifiex: use world for unidentified region code

Shengzhen Li (2):
  mwifiex: change ap and station interface limits
  mwifiex: multiple bss support

Xinming Hu (3):
  mwifiex: fix bug for wildcard-prefix wowlan pattern
  mwifiex: increase supported wowlan pattern length
  mwifiex: abort cac in del_station() handler

Zhaoyang Liu (1):
  mwifiex: advertise SMS4 cipher suite

chunfan chen (2):
  mwifiex: fix wake on disconnect feature
  mwifiex: fix WPA connection problem

 drivers/net/wireless/marvell/mwifiex/11n_aggr.c    |  2 -
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   | 10 +++
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    | 44 +++++++++----
 drivers/net/wireless/marvell/mwifiex/cfp.c         |  2 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |  4 +-
 drivers/net/wireless/marvell/mwifiex/debugfs.c     | 30 +++++++++
 drivers/net/wireless/marvell/mwifiex/decl.h        |  6 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |  2 +-
 drivers/net/wireless/marvell/mwifiex/main.h        | 44 ++++++++++---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   | 75 +++++++++++++++-------
 drivers/net/wireless/marvell/mwifiex/sta_rx.c      |  2 +-
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c    |  3 +-
 12 files changed, 168 insertions(+), 56 deletions(-)

-- 
1.8.1.4

