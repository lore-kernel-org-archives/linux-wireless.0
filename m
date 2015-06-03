Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12678 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbbFCGA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 02:00:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t5360B4a028783
	for <linux-wireless@vger.kernel.org>; Tue, 2 Jun 2015 23:00:23 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1usqkvggtj-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2015 23:00:23 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCHv5 00/17] mwifiex patches 
Date: Wed, 3 Jun 2015 16:59:30 +0530
Message-ID: <1433330987-6808-1-git-send-email-patila@marvell.com> (sfid-20150603_080032_709693_302BCB16)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series mainly adds enhancements for mwifiex AP. 
With this series, we support verbose information in station dump command
also information about AP link.
Another important enhancement is related to parsing IEs from tail of beacondata.
Few issues seen during DFS testing are also fixed in this series.
 --------
v2:
 - rebase 
v3, v4:
 - Address review comments by Bjørn & Joe. 
v5:
 - Removed reviewed-by as suggested by Joe and Julian
 -------
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

