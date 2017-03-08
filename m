Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47277 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753030AbdCHNtu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 08:49:50 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v28Dk8IG010265
        for <linux-wireless@vger.kernel.org>; Wed, 8 Mar 2017 05:48:02 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2913wyyegg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 08 Mar 2017 05:48:01 -0800
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 0/3] mwifiex: Unaligned access fixes
Date: Wed, 8 Mar 2017 19:17:06 +0530
Message-ID: <1488980829-6075-1-git-send-email-gbhat@marvell.com> (sfid-20170308_145034_954503_522DD0A0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series fixes the unaligned memory accesses
in mwifiex driver. Use accessors routines, like
get_unaligned_le** instead of le**_to_cpu.

Daniel Mentz (1):
  mwifiex: Use accessors routines for unaligned values

Devidas Puranik (1):
  mwifiex: fix for unaligned reads

Karthik D A (1):
  mwifiex: add qualifier to firmware structures

 drivers/net/wireless/marvell/mwifiex/11h.c         |  3 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |  4 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          | 36 ++++++++--------
 drivers/net/wireless/marvell/mwifiex/ie.c          | 15 +++----
 drivers/net/wireless/marvell/mwifiex/main.h        |  2 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        | 37 +++++++---------
 drivers/net/wireless/marvell/mwifiex/scan.c        | 26 +++++++-----
 drivers/net/wireless/marvell/mwifiex/sdio.c        | 23 +++++-----
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     | 49 ++++++++++++----------
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |  4 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |  8 ++--
 drivers/net/wireless/marvell/mwifiex/tdls.c        | 10 ++---
 drivers/net/wireless/marvell/mwifiex/uap_event.c   |  2 +-
 drivers/net/wireless/marvell/mwifiex/usb.h         |  4 +-
 drivers/net/wireless/marvell/mwifiex/util.c        |  6 +--
 drivers/net/wireless/marvell/mwifiex/util.h        |  5 +++
 16 files changed, 125 insertions(+), 109 deletions(-)

-- 
1.9.1
