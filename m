Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51667 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3HMMZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 08:25:52 -0400
Cc: Kirshenbaum Erez <erezk@wilocity.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	<wil6210@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH] wil6210: fix for HW csum
Date: Tue, 13 Aug 2013 15:25:31 +0300
Message-ID: <1376396732-26632-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130813_142555_123214_5DB595FA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following is fix for HW csum calculation. User visible
impact is quite severe: before this patch, TCP iperf
Windows -> Linux would stall in about 1sec.

Vladimir Kondratiev (1):
  wil6210: let IP stack re-check HW TCP/UDP csum errors

 drivers/net/wireless/ath/wil6210/txrx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
1.8.1.2

