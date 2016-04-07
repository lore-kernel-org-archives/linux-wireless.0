Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175AbcDGSTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:34 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 00/18] rtl8xxxu: Additional code to support rtl8192eu
Date: Thu,  7 Apr 2016 14:19:15 -0400
Message-Id: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_201943_916488_2F24943B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Here is another set of patches adding more code to handle the
rtl8192eu. It is relative to wireless-drivers-next as of
2016-04-07. This isn't the complete set to support the 8192eu, I am
breaking it down to make the patch volume easier to manage.

I am hoping we can get it all in so 8192eu support can be enabled in
time for 4.7.

The only contentious issue would be the EXT_PA_8192EU defines, which I
would like to keep in place as it helps me dealing with that later. It
will get cleaned up down the line.

Cheers,
Jes


Jes Sorensen (18):
  rtl8xxxu: Add MAC init table for 8192eu
  rtl8xxxu: Do not mess with AFE_XTAL_CTRL on 8192eu
  rtl8xxxu: Set TX page boundaries for 8192eu
  rtl8xxxu: Add radio init tables for 8192eu
  rtl8xxxu: Add 8192eu AGC tables
  rtl8xxxu: Add 8192eu PHY init table
  rtl8xxxu: Pick PHY init table based on chip version first
  rtl8xxxu: Correctly parse 8192eu efuse
  rtl8xxxu: Handle BB init for 8192eu
  rtl8xxxu: Provide special handling when writing RF regs on 8192eu
  rtl8xxxu: Handle XTAL value setting on 8192eu
  rtl8xxxu: Set correct interrupt masking registers on 8192eu
  rtl8xxxu: Set REG_USB_HRPWM for 8192eu
  rtl8xxxu: Fix LDPC RX hang issue on 8192eu
  rtl8xxxu: Implement 8192eu device specific quirks
  rtl8xxxu: Use proper register name for REG_PAD_CTRL1
  rtl8xxxu: Implement IQK calibration for 8192eu
  rtl8xxxu: Adjust AFE crystal value on 8192eu

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 1581 +++++++++++++++++---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   40 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |    7 +
 3 files changed, 1419 insertions(+), 209 deletions(-)

-- 
2.5.5

