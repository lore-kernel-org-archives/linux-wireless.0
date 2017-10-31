Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46700 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750978AbdJaJqH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 05:46:07 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Douglas Anderson <dianders@chromium.org>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 0/3] mwifiex: fix usage issues with spinlocks
Date: Tue, 31 Oct 2017 15:12:44 +0530
Message-ID: <1509442967-14149-1-git-send-email-gbhat@marvell.com> (sfid-20171031_104611_806928_AFBF846A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series fixes issues with usage of few of the spinlocks
used by the driver. To summarise it fixes below issues:

1. Driver does access the elements returned by the list, without
acquiring the lock.

2. Driver release the lock during iteration of the list and hold
it back before starting the next iteration.

3. Driver release the lock while the element is still in process.

Karthik Ananthapadmanabha (3):
  mwifiex: cleanup rx_pkt_lock usage in 11n_rxreorder.c
  mwifiex: cleanup tx_ba_stream_tbl_lock usage
  mwifiex: cleanup rx_reorder_tbl_lock usage

 drivers/net/wireless/marvell/mwifiex/11n.c         | 45 +++++++++++++---------
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   | 42 +++++++++++++-------
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c    |  3 ++
 3 files changed, 58 insertions(+), 32 deletions(-)

-- 
1.9.1
