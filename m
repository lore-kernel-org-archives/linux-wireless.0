Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29474 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058AbbAMGJN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 01:09:13 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0D69DmR010866
	for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 22:09:13 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1rubhvwnv2-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 22:09:12 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 0/8] mwifiex change virtual interface enhancements
Date: Tue, 13 Jan 2015 17:08:42 +0530
Message-ID: <1421149130-5889-1-git-send-email-patila@marvell.com> (sfid-20150113_070917_423049_DA66CD88)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series is enhancement for change virtual interface
handling in mwifiex. With this series in, now we remove coupling
between netdev and FW supported interface combination. Now conversion
from any type of supported interface types to any other type is possible.

Avinash Patil (8):
  mwifiex: remove redundant nick_name variable
  mwifiex: set wiphy params only once
  mwifiex: do not declare wdev as pointer
  mwifiex: store permanant mac address in adapter structure
  mwifiex: add init parameter to init command routine
  mwifiex: manage virtual interface limits efficiently
  mwifiex: handle PS events on AP interface as well
  mwifiex: support conversion to any virtual interface type

 drivers/net/wireless/mwifiex/11h.c           |   2 +-
 drivers/net/wireless/mwifiex/11n.c           |   4 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   2 +-
 drivers/net/wireless/mwifiex/cfg80211.c      | 584 ++++++++++++++++++++-------
 drivers/net/wireless/mwifiex/cfp.c           |   4 +-
 drivers/net/wireless/mwifiex/cmdevt.c        |  40 +-
 drivers/net/wireless/mwifiex/decl.h          |  10 +
 drivers/net/wireless/mwifiex/init.c          |   8 +-
 drivers/net/wireless/mwifiex/main.c          |   9 +-
 drivers/net/wireless/mwifiex/main.h          |  29 +-
 drivers/net/wireless/mwifiex/scan.c          |  10 +-
 drivers/net/wireless/mwifiex/sta_cmd.c       |  13 +-
 drivers/net/wireless/mwifiex/sta_event.c     |   2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c     |  32 +-
 drivers/net/wireless/mwifiex/txrx.c          |   2 +-
 drivers/net/wireless/mwifiex/uap_event.c     |  39 ++
 drivers/net/wireless/mwifiex/util.c          |   2 +-
 17 files changed, 560 insertions(+), 232 deletions(-)

-- 
1.8.1.4

