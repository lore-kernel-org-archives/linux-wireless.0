Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29166 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601AbbE1M7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 08:59:33 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4SCxWEl014853
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 05:59:32 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1unvy5rwtw-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 05:59:32 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 00/17] mwifiex patches 
Date: Thu, 28 May 2015 23:58:50 +0530
Message-ID: <1432837747-2075-1-git-send-email-patila@marvell.com> (sfid-20150528_145937_463099_6C50B345)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series mainly adds enhancements for mwifiex AP. 
With this series, we support verbose information in station dump command
also inforamation about AP link. Another important enhancement is related
to parsing IEs from Tail of beacon_data.
Few issues seen during DFS testing are also fixed in this series.
Patch series also includes some other misc patches.

Avinash Patil (11):
  mwifiex: verbose logging for association failure messages
  mwifiex: correct bss_type assignment
  mwifiex: support AP reset after bss_stop
  mwifiex: enable 11d after bss reset
  mwifiex: reset 11h active flag when chandef does not require dfs
  mwifiex: disable CAC upon radar detection event
  mwifiex: parse power constraint IE from Tail
  mwifiex: support downloading IEs from tail
  mwifiex: drop block-ack action frames
  mwifiex: advertise PS ON by default support to cfg80211
  mwifiex: update AP WMM settings from BSS_START event

Xinming Hu (6):
  mwifiex: add cfg80211 get_channel handler
  mwifiex: maintain station statistic in uap mode
  mwifiex: add sta_list firmware command
  mwifiex: dump station support in uap mode
  mwifiex: using right tid for addressing ra_list
  mwifiex: do not decrease tx_pending for AMSDU packet once more

 drivers/net/wireless/mwifiex/11h.c           |  32 +++++--
 drivers/net/wireless/mwifiex/11n.c           |  11 ++-
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   5 +-
 drivers/net/wireless/mwifiex/cfg80211.c      | 130 ++++++++++++++++++++++++---
 drivers/net/wireless/mwifiex/cmdevt.c        |   2 +
 drivers/net/wireless/mwifiex/fw.h            |  43 ++++++++-
 drivers/net/wireless/mwifiex/ie.c            | 102 ++++++++++++---------
 drivers/net/wireless/mwifiex/ioctl.h         |   1 +
 drivers/net/wireless/mwifiex/join.c          |  30 ++++++-
 drivers/net/wireless/mwifiex/main.h          |  23 ++++-
 drivers/net/wireless/mwifiex/sta_cmdresp.c   |  26 ++++++
 drivers/net/wireless/mwifiex/txrx.c          |  21 +++--
 drivers/net/wireless/mwifiex/uap_cmd.c       |  55 +++++++++++-
 drivers/net/wireless/mwifiex/uap_event.c     |  63 +++++++++++++
 drivers/net/wireless/mwifiex/uap_txrx.c      |  18 +++-
 drivers/net/wireless/mwifiex/util.c          |  56 +++++++++---
 16 files changed, 525 insertions(+), 93 deletions(-)

-- 
1.8.1.4

