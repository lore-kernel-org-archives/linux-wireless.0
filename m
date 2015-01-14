Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33338 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060AbbANKqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 05:46:15 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0EAO4BI027901
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:46:14 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1rwj838nyj-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:46:14 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<gaoqs@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 00/10] mwifiex: DFS support for mwifiex AP
Date: Wed, 14 Jan 2015 21:45:28 +0530
Message-ID: <1421252138-30157-1-git-send-email-patila@marvell.com> (sfid-20150114_114618_940147_23530639)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds DFS support for mwifiex AP. Series include
patches to handle cfg80211 start_radar_detection and channel_switch
handlers. First 5 patches are actually refactoring effort. Patch6-10
add these handlers and other DFS handling.

Avinash Patil (10):
  mwifiex: do not send regulatory update while starting AP
  mwifiex: store AP configuration in private structure
  mwifiex: update IEs after AP has started
  mwifiex: refactor start_ap handler
  mwifiex: separate function for parsing head and tail IEs
  mwifiex: add cfg80211 start_radar_detection handler
  mwifiex: support for channel report for radar detection
  mwifiex: handle radar detect event from FW
  mwifiex: channel switch support for mwifiex
  mwifiex: 11h handling for AP interface

 drivers/net/wireless/mwifiex/11h.c         | 196 +++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/cfg80211.c    | 232 +++++++++++++++++++++--------
 drivers/net/wireless/mwifiex/decl.h        |  11 ++
 drivers/net/wireless/mwifiex/fw.h          |  58 ++++++++
 drivers/net/wireless/mwifiex/ie.c          |  89 ++++++-----
 drivers/net/wireless/mwifiex/init.c        |   3 +
 drivers/net/wireless/mwifiex/main.c        |   2 +-
 drivers/net/wireless/mwifiex/main.h        |  31 +++-
 drivers/net/wireless/mwifiex/sta_cmd.c     |   4 +
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   2 +
 drivers/net/wireless/mwifiex/sta_event.c   |  10 ++
 drivers/net/wireless/mwifiex/uap_cmd.c     |  70 +++++++++
 drivers/net/wireless/mwifiex/uap_event.c   |   8 +
 13 files changed, 619 insertions(+), 97 deletions(-)

-- 
1.8.1.4

