Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40241 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752659AbdCIJd6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 04:33:58 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v298YfhA025449
        for <linux-wireless@vger.kernel.org>; Thu, 9 Mar 2017 00:37:05 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2933c9039h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Thu, 09 Mar 2017 00:37:05 -0800
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH v2 0/3] mwifiex: Unaligned access fixes 
Date: Thu, 9 Mar 2017 14:06:14 +0530
Message-ID: <1489048577-11293-1-git-send-email-gbhat@marvell.com> (sfid-20170309_103405_099388_D7DE59F9)
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

Karthik Ananthapadmanabha (1):
  mwifiex: add qualifier to firmware structures
---
v2: Correct the author name in [PATCH 0/1]
---
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
