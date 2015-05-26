Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21302 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753782AbbEZNfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:35:05 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4QDY7Go009227
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 06:35:04 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1umgmahafj-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 06:35:04 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 0/6] mwifiex: device dump enhancements
Date: Tue, 26 May 2015 06:34:26 -0700
Message-ID: <1432647272-5734-1-git-send-email-akarwar@marvell.com> (sfid-20150526_153551_025607_57C42589)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series fixes couple of bugs in device dump
code paths, makes use of devcoredump mechanism after removing
'ethtool dump' approach.

Amitkumar Karwar (6):
  mwifiex: fix SDIO firmware dump problem
  mwifiex: fix a possible double free issue
  mwifiex: dump driver information for PCIe interface
  mwifiex: minor changes in debug messages
  mwifiex: use generic name 'device dump'
  mwifiex: device dump support via devcoredump framework

 drivers/net/wireless/mwifiex/Kconfig   |   2 +
 drivers/net/wireless/mwifiex/README    |   6 +-
 drivers/net/wireless/mwifiex/cmdevt.c  |   4 +-
 drivers/net/wireless/mwifiex/debugfs.c |  20 +++----
 drivers/net/wireless/mwifiex/ethtool.c |  99 -------------------------------
 drivers/net/wireless/mwifiex/init.c    |   1 +
 drivers/net/wireless/mwifiex/main.c    | 103 +++++++++++++++++++++++++++++++--
 drivers/net/wireless/mwifiex/main.h    |   9 +--
 drivers/net/wireless/mwifiex/pcie.c    |  39 +++++++------
 drivers/net/wireless/mwifiex/sdio.c    |  38 +++++++-----
 10 files changed, 163 insertions(+), 158 deletions(-)

-- 
1.8.1.4

