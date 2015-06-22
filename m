Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32432 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932256AbbFVIGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:06:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M7xr3Y032680
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:06:33 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1v57pdueys-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:06:32 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 00/17] mwifiex: multichannel & TDLS channel switch support 
Date: Mon, 22 Jun 2015 19:06:06 +0530
Message-ID: <1434980183-2901-1-git-send-email-patila@marvell.com> (sfid-20150622_100640_454000_75AC2FFC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds multichannel and TDLS channel switch support to mwifiex.
Important feature this patchset brings in is TX DATA Pause support wherein
FW indicates driver about inablity to handle additional data packets(because
of channel switch) and driver would pause traffic for these RA list or
interfaces. This in turn enables us to support multichannel operation and 
TDLS channel switch feature.

Avinash Patil (9):
  mwifiex: add tx data pause support
  mwifiex: update domain_info upon band change in start_ap
  mwifiex: support for bypass tx queue
  mwifiex: enable traffic only when port is open
  mwifiex: extend tx_data pause to AP interface as well
  mwifiex: support to set multichannel policy to FW
  mwifiex: advertise multichannel support to cfg80211
  mwifiex: separate interface combination for multichannel and DFS
  mwifiex: handle multichannel event

Xinming Hu (8):
  mwifiex: block data traffic to tx paused receive address
  mwifiex: do not increase tx_pkts_queued if receive address tx paused
  mwifiex: add tdls channel switch status
  mwifiex: process tdls channel switch event
  mwifiex: add tdls config command
  mwifiex: enable tdls channel switch ext_cap
  mwifiex: enhance tdls link setup condition
  mwifiex: add cfg80211 tdls channel switch handler

 drivers/net/wireless/mwifiex/cfg80211.c    | 113 +++++++++++++++-
 drivers/net/wireless/mwifiex/decl.h        |   3 +
 drivers/net/wireless/mwifiex/fw.h          |  87 +++++++++++-
 drivers/net/wireless/mwifiex/init.c        |   3 +-
 drivers/net/wireless/mwifiex/join.c        |   2 +
 drivers/net/wireless/mwifiex/main.c        |  63 ++++++++-
 drivers/net/wireless/mwifiex/main.h        |  38 ++++++
 drivers/net/wireless/mwifiex/sta_cmd.c     |  84 ++++++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   5 +
 drivers/net/wireless/mwifiex/sta_event.c   | 207 ++++++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/tdls.c        |  78 ++++++++++-
 drivers/net/wireless/mwifiex/uap_cmd.c     |   7 +-
 drivers/net/wireless/mwifiex/uap_event.c   |  13 ++
 drivers/net/wireless/mwifiex/util.c        |  59 ++++++++
 drivers/net/wireless/mwifiex/wmm.c         | 156 +++++++++++++++++++++-
 drivers/net/wireless/mwifiex/wmm.h         |   8 ++
 16 files changed, 906 insertions(+), 20 deletions(-)

-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
