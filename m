Return-Path: <SRS0=eo9X=ZL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_ADSP_NXDOMAIN,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17EB9C432C3
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Nov 2019 00:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6F6D21D7F
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Nov 2019 00:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKSA0k (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Nov 2019 19:26:40 -0500
Received: from alexa-out-tai-02.qualcomm.com ([103.229.16.227]:61186 "EHLO
        alexa-out-tai-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726961AbfKSA0j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Nov 2019 19:26:39 -0500
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Nov 2019 19:26:39 EST
Received: from ironmsg03-tai.qualcomm.com ([10.249.140.8])
  by alexa-out-tai-02.qualcomm.com with ESMTP; 19 Nov 2019 08:20:32 +0800
IronPort-SDR: uIyi4jj5HCAF22ocHiM0RtK6nTIraWHDj4qUyHY+RQZOf7gN0zYGF9eqiOQmAXT2qCa5P1a86y
 94ovE8Kc8TTba9RFBQNBob0SOXSm5Wv4Y=
Received: from vento-sdc-01.ap.qualcomm.com (HELO vento-sdc-01.qualcomm.com) ([10.253.144.67])
  by ironmsg03-tai.qualcomm.com with ESMTP; 19 Nov 2019 08:20:29 +0800
Received: by vento-sdc-01.qualcomm.com (Postfix, from userid 0)
        id 738CD1A4F; Tue, 19 Nov 2019 08:20:28 +0800 (CST)
From:   root <root@vento-sdc-01.qualcomm.com>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/2] ath10k: correct tx bitrate for QCA6174/QCA9377/QCA9888
Date:   Tue, 19 Nov 2019 08:20:26 +0800
Message-Id: <20191119002028.2519-1-root@vento-sdc-01.qualcomm.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yu Wang <yyuwang@codeaurora.org>

Tx bitrate got by command 'iw wlan0 link' is incorrect.
These 2 patches will fix the issue.

Changes from v1:
[PATCH v2] ath10k: correct legacy rate in tx stats
Remove wmi ops for getting legacy rate, instead, update the ratecode got from
PPDU stats, to align with the existing tx rate processing.

Yu Wang (2):
  ath10k: add ppdu stats support for QCA6174/QCA9377
  ath10k: correct legacy rate in tx stats

 drivers/net/wireless/ath/ath10k/htt.c     |   2 +
 drivers/net/wireless/ath/ath10k/htt.h     |  30 ++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 146 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/mac.c     |   2 +-
 drivers/net/wireless/ath/ath10k/mac.h     |   1 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   4 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |   3 +
 7 files changed, 186 insertions(+), 2 deletions(-)

-- 
2.7.4

