Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72AB3C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 442B0222A4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729819AbfBNI7d (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:59:33 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:39562 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbfBNI7c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 03:59:32 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1E8xB8v005813, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1E8xB8v005813
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 14 Feb 2019 16:59:11 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 14 Feb 2019 16:59:10 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>
CC:     <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>
Subject: [PATCH v2 00/24] rtw88: major fixes for 8822c to have stable functionalities
Date:   Thu, 14 Feb 2019 16:58:39 +0800
Message-ID: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Note this patch set is based on patch set "rtw88: mac80211 driver for
Realtek 802.11ac wireless network chips". For reference:
https://patchwork.kernel.org/cover/10811967/
https://lkml.kernel.org/linux-wireless/1550131671-2601-1-git-send-email-yhchuang@realtek.com/

These patches are mean to make sure 8822c chip to operate normal for most
of the basic functionalities, such as power on, switch channel, scan,
connection establish and connection monitor.

As the original patch set was sent 3 months ago, progress has been made
by Realtek during the past months. Now we have tested on more chips and
released tables and parameters for them. Also the chips are all
programed with efuse map released for 8822c.

Most of the changes are about BB and RF, both control the tx/rx path.
PHY parameters/seq and efuse info make sure the hardware is powered on
correctly. And channel setting updates help driver to switch to target
channel accurately. Then trx mode setting and DACK will make hardware to
have stable performance to tx/rx to connect to AP.

Here tx power control is also required to transmit with a precise power.
Otherwise if the power is too high or too low, the peer might not be able
to receive the signal.

Finally, we need to report correct tx status for mac80211's connection
monitor system, this requires firmware's C2H of tx status report. After
this, users can use 8822c chips for more stable wireless communication.


v2

This v2 is sent for that https://patchwork.kernel.org/cover/10811967/
has many modifications and the original patch set would not apply.
Also with a few changes in this one. Listed below

 - report ACK for tx frames not have IEEE80211_TX_CTL_REQ_TX_STATUS,
   otherwise they will be marked as "drop"
 - add more rf register write protection for patch "rtw88: add a delay
   after writing a rf register"


Chien-Hsun Liao (3):
  rtw88: add a delay after writing a rf register
  rtw88: 8822c: update channel setting
  rtw88: 8822c: update trx mode setting

Tzu-En Huang (2):
  rtw88: add 8822c tx power index table parsing support
  rtw88: add 8822c tx agc support

Yan-Hsuan Chuang (19):
  rtw88: report correct tx status if mac80211 requested one
  rtw88: add get_c2h_from_skb for extracting c2h commands
  rtw88: can not support vif beacon filter actually
  rtw88: fix incorrect bit definition for RF mode
  rtw88: 8822c: correct crystal setting
  rtw88: 8822c: update efuse table as released
  rtw88: 8822c: update pwr_seq to v12
  rtw88: 8822c: update phy parameter to v27
  rtw88: add module param to switch lps supportability
  rtw88: extract utility functions into util.c
  rtw88: 8822c: add support for DACK
  rtw88: 8822c: fix RSC setting
  rtw88: 8822c: set ack timeout
  rtw88: 8822c: do not reset MAC Rx before sending CCK packet
  rtw88: 8822c: parse packet by sigb length
  rtw88: do not count dummy tail into rx counter
  rtw88: set OFDM ctx to receive ack after cts2self
  rtw88: fix slot time value
  rtw88: 8822b: turn rtw_write32s_mask into macro

 drivers/net/wireless/realtek/rtw88/Makefile        |     1 +
 drivers/net/wireless/realtek/rtw88/fw.c            |    19 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |    16 +
 drivers/net/wireless/realtek/rtw88/mac.c           |    53 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |     1 -
 drivers/net/wireless/realtek/rtw88/main.c          |    19 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    68 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |    15 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |     1 +
 drivers/net/wireless/realtek/rtw88/phy.c           |   199 +-
 drivers/net/wireless/realtek/rtw88/phy.h           |     9 +
 drivers/net/wireless/realtek/rtw88/reg.h           |    13 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |    59 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.h      |    15 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   939 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |    75 +-
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    | 11047 ++++++++++++++++---
 .../net/wireless/realtek/rtw88/rtw8822c_table.h    |     1 +
 drivers/net/wireless/realtek/rtw88/tx.c            |    94 +
 drivers/net/wireless/realtek/rtw88/tx.h            |     8 +
 drivers/net/wireless/realtek/rtw88/util.c          |    72 +
 drivers/net/wireless/realtek/rtw88/util.h          |    34 +
 22 files changed, 10688 insertions(+), 2070 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/util.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/util.h

-- 
2.7.4

