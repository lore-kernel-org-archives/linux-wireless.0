Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22803 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176AbcAGJeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 04:34:21 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u079UHXM005997
	for <linux-wireless@vger.kernel.org>; Thu, 7 Jan 2016 01:34:16 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 209g1d8vb5-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 01:34:16 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 0/6] mwifiex wowlan enahancements
Date: Thu, 7 Jan 2016 01:31:25 -0800
Message-ID: <1452159091-30997-1-git-send-email-akarwar@marvell.com> (sfid-20160107_103427_415511_CFE75C83)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds support for schedule scan,
wowlan net-detect and reporting wakeup reason to
cfg80211.

Amitkumar Karwar (1):
  mwifiex: use SYNC flag for canceling host sleep

Ganapathi Bhat (1):
  mwifiex: add RSSI support for net-detect

Xinming Hu (1):
  mwifiex: add schedule scan support

chunfan chen (3):
  mwifiex: add wowlan info messages
  mwifiex: add wowlan net-detect support
  mwifiex: report wakeup reason to cfg80211

 drivers/net/wireless/marvell/mwifiex/cfg80211.c    | 244 ++++++++++++++--
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |  13 +
 drivers/net/wireless/marvell/mwifiex/fw.h          |  86 ++++++
 drivers/net/wireless/marvell/mwifiex/ioctl.h       |   5 +
 drivers/net/wireless/marvell/mwifiex/main.c        |  14 +
 drivers/net/wireless/marvell/mwifiex/main.h        |  17 ++
 drivers/net/wireless/marvell/mwifiex/scan.c        | 308 +++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  23 ++
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |   6 +
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |   7 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |  25 ++
 12 files changed, 733 insertions(+), 17 deletions(-)

-- 
1.8.1.4

