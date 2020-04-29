Return-Path: <SRS0=wwyj=6N=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F2BC83004
	for <linux-wireless@archiver.kernel.org>; Wed, 29 Apr 2020 09:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A83A520775
	for <linux-wireless@archiver.kernel.org>; Wed, 29 Apr 2020 09:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgD2J5L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 29 Apr 2020 05:57:11 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:49971 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgD2J5K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Apr 2020 05:57:10 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 03T9v4541030884, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 03T9v4541030884
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Apr 2020 17:57:04 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 29 Apr 2020 17:57:03 +0800
Received: from localhost.localdomain (172.21.68.128) by
 RTEXMB04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 29 Apr 2020 17:57:03 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <pkshih@realtek.com>
Subject: [PATCH v3 0/8] rtw88: 8723d: add BB related routines
Date:   Wed, 29 Apr 2020 17:56:48 +0800
Message-ID: <20200429095656.19315-1-yhchuang@realtek.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.128]
X-ClientProxiedBy: RTEXMB03.realtek.com.tw (172.21.6.96) To
 RTEXMB04.realtek.com.tw (172.21.6.97)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Add BB related routines for 8723D.
The BB controls the channel, RX decoding, and RX gain. So, add DIG
parameters and RX descriptor parsing for the RX frames. And the false
alarm statistics help the driver to choose better DIG values.
The 8723D devices have more settings for CCK rates for DIG, mostly
because that the 8723D is 802.11n device.

The 8723D devices cannot recieve LDPC frames, do not advertise it.


v1 -> v2
  * make a patchset contains less patches for review

v2 -> v3
  * move defined macros to header file


Ping-Ke Shih (8):
  rtw88: 8723d: Add DIG parameter
  rtw88: 8723d: Add query_rx_desc
  rtw88: 8723d: Add set_channel
  rtw88: handle C2H_CCX_TX_RPT to know if packet TX'ed successfully
  rtw88: 8723d: 11N chips don't support LDPC
  rtw88: 8723d: Add chip_ops::false_alarm_statistics
  rtw88: 8723d: Set IG register for CCK rate
  rtw88: 8723d: add interface configurations table

 drivers/net/wireless/realtek/rtw88/fw.c       |   6 +-
 drivers/net/wireless/realtek/rtw88/fw.h       |   7 +-
 drivers/net/wireless/realtek/rtw88/mac.c      |   3 +
 drivers/net/wireless/realtek/rtw88/main.c     |   2 +-
 drivers/net/wireless/realtek/rtw88/main.h     |   1 +
 drivers/net/wireless/realtek/rtw88/phy.c      |   4 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c | 377 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8723d.h |  94 +++++
 drivers/net/wireless/realtek/rtw88/rtw8822b.c |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c |   1 +
 drivers/net/wireless/realtek/rtw88/tx.c       |  11 +-
 drivers/net/wireless/realtek/rtw88/tx.h       |   2 +-
 12 files changed, 501 insertions(+), 8 deletions(-)

-- 
2.17.1

