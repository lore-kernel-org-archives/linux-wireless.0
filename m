Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35842 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754873AbcHSVrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:24 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 00/20] rtl8xxxu patches for wireless-drivers-next
Date: Fri, 19 Aug 2016 17:46:22 -0400
Message-Id: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234843_077457_242CE7B7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi

This is a set of patches for the rtl8xxxu driver relative to
wireless-drivers-next as of 2016-08-19.

It includes a couple of cases where the 8192cu driver is marked as
tested. Note while these do move the USB location around, they still
stay within the CONFIG_RTL8XXXU_UNTESTED zone. There has been some
suggestion that we should deprecate 8192cu support from rtlwifi in
favor of rtl8xxxu, however I think that is really for the rtlwifi
maintainer to make that call.

In addition this set includes a couple of minor fixes I received from
Wei Yongjun and Hans de Goede, and a number of changes that helps
prepare the code for the rtl8188eu support I am currently working on.

Cheers,
Jes


Hans de Goede (1):
  net: wireless: rtl8xxxu: Make rtl8xxxu_ampdu_action less chatty

Jes Sorensen (18):
  rtl8xxxu: Mark 0x20f4:0x648b as tested
  rtl8xxxu: Mark 0x2001:0x3308 as tested
  rtl8xxxu: Fix error handling if rtl8xxxu_init_device() fails
  rtl8xxxu: Add TP-Link TL-WN823N v2 to list of supported devices
  rtl8xxxu: Add TX page defines for 8723b
  rtl8xxxu: Switch 8723a to use new rtl8xxxu_init_queue_reserved_page()
    routine
  rtl8xxxu: Switch 8192cu/8188cu devices to use
    rtl8xxxu_init_queue_reserved_page()
  rtl8xxxu: Remove now obsolete rtl8xxxu_old_init_queue_reserved_page()
  rtl8xxxu: Simplify code setting TX buffer boundary
  rtl8xxxu: Add bit definitions for REG_FPGA0_TX_INFO
  rtl8xxxu: Add interrupt bit definitions for gen2 parts
  rtl8xxxu: Use flag to indicate whether device has TX report timer
    support
  rtl8xxxu: Convert flags in rtl8xxxu_fileops to bitflags
  rtl8xxxu: Introduce fops bitflag indicating type of thermal meter
  rtl8xxxu: Simplify calculating of hw value used for setting TX rate
  rtl8xxxu: Determine the need for SGI before handling specific TX desc
    formats
  rtl8xxxu: Determine need for shore preamble before updating TX
    descriptors
  rtl8xxxu: Split filling of TX descriptors into separate functions

Wei Yongjun (1):
  rtl8xxxu: gen1: Fix non static symbol warning

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  22 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c |   5 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |   2 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c |   5 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |   7 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 319 +++++++++++----------
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |  60 ++++
 7 files changed, 271 insertions(+), 149 deletions(-)

-- 
2.7.4
