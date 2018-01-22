Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36646 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750828AbeAVPJ1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 10:09:27 -0500
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 0/2] mwifiex: fix RX data stall issue on USB interface
Date: Mon, 22 Jan 2018 20:34:55 +0530
Message-ID: <1516633497-6584-1-git-send-email-gbhat@marvell.com> (sfid-20180122_160932_224930_E2CEF9C3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains 2 fixes to avoid RX data stall on
observed on high through put scenarios on some slower platforms.

Shrenik Shikhare (2):
  mwifiex: schedule rx_work on RX interrupt for USB
  mwifiex: use more_rx_task_flag to avoid USB RX stall

 drivers/net/wireless/marvell/mwifiex/main.c | 17 +++++++++++++----
 drivers/net/wireless/marvell/mwifiex/main.h |  2 ++
 drivers/net/wireless/marvell/mwifiex/usb.c  |  2 ++
 3 files changed, 17 insertions(+), 4 deletions(-)

-- 
1.9.1
