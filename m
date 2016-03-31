Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274AbcCaVIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 17:08:44 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 00/10] rtl8xxxu updates
Date: Thu, 31 Mar 2016 17:08:32 -0400
Message-Id: <1459458522-28686-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160331_230857_541601_CBFD8142)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This is a small set of changes to the rtl8xxxu driver which cleans up
the naming of the TX data descriptors, and also prepares for further
for adding rtl8192eu support.

Cheers,
Jes

Jes Sorensen (10):
  rtl8xxxu: Change name of struct tx_desc to be more decriptive
  rtl8xxxu: Rename TX descriptor bits to map them to 32/40 byte
    descriptors
  rtl8xxxu: Correct txdesc40 gid definition
  rtl8xxxu: TXDESC_SHORT_GI is txdesc32 only
  rtl8xxxu: 8192eu uses txdesc40
  rtl8xxxu: Update some register definitions
  rtl8xxxu: Use enums for chip version numbers
  rtl8xxxu: Identify 8192eu rev A/B parts correctly
  rtl8xxxu: Use correct H2C calls for 8192eu
  rtl8xxxu: Do not set LDOA15 / LDOV12 on 8192eu

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 163 ++++++++++-----------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   | 130 +++++++++-------
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  31 +++-
 3 files changed, 179 insertions(+), 145 deletions(-)

-- 
2.5.5

