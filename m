Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43158 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751127AbdH3Tyw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 15:54:52 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7UJsUc4006997
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 12:54:51 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2cnt3m3r6t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 12:54:51 -0700
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 0/2] mwifiex: address URB submission failure
Date: Thu, 31 Aug 2017 01:21:12 +0530
Message-ID: <1504122674-3379-1-git-send-email-gbhat@marvell.com> (sfid-20170830_215454_961828_5E3FA34C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series fixes a driver issue with USB interface. When
URB submission fails due to skb allocation, it is retried in
main thread.

Ganapathi Bhat (1):
  mwifiex: print URB submit failure error after threshold attemtps

James Cao (1):
  mwifiex: resubmit failed to submit RX URBs in main thread

 drivers/net/wireless/marvell/mwifiex/main.c | 11 +++++++++++
 drivers/net/wireless/marvell/mwifiex/usb.c  | 11 +++++++++--
 drivers/net/wireless/marvell/mwifiex/usb.h  |  2 ++
 3 files changed, 22 insertions(+), 2 deletions(-)

-- 
1.9.1
