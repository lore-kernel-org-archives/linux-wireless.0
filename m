Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbcD1TTQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 15:19:16 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 00/11] rtl8xxxu: refactor sub-drivers into multiple files
Date: Thu, 28 Apr 2016 15:19:04 -0400
Message-Id: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160428_211922_040410_2A0AA083)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Since Kalle mentioned the tree is still open - here are a few more
patches for the rtl8xxxu driver.

This is a set I have been planning for a while, refactoring the code
and moving the sub-drivers into their own files. This should make it
easier and less intrusive adding support for new devices in the
future.

Except for the last three patches, there should be no actual code flow
change in this set.

Cheers,
Jes

Jes Sorensen (11):
  rtl8xxxu: Rename rtl8xxxu.c to rtl8xxxu_core.c
  rtl8xxxu: move rtl8192e related code into rtl8xxxu_8192e.c
  rtl8xxxu: move rtl8723b related code into rtl8xxxu_8723b.c
  rtl8xxxu: move rtl8723a related code into rtl8xxxu_8723a.c
  rtl8xxxu: move rtl8188[cr] and rtl8192c related code into
    rtl8xxxu_8192c.c
  rtl8xxxu: Rename rtl8723a_stop_tx_beacon() to
    rtl8xxxu_stop_tx_beacon()
  rtl8xxxu: rename rtl8723a_channel_group() to
    rtl8xxxu_gen1_channel_to_group()
  rtl8xxxu: Rename rtl8723a_disabled_to_emu() to
    rtl8xxxu_disabled_to_emu()
  rtl8xxxu: Split rtl8723a_h2c_cmd() into a gen1 and a gen2 version
  rtl8xxxu: rtl8xxxu_prepare_calibrate() is never used on gen1
  rtl8xxxu: Remove the now obsolete mbox_ext_reg info from
    rtl8xxxu_fileops

 drivers/net/wireless/realtek/rtl8xxxu/Makefile     |     3 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 10213 -------------------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |    81 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c |   586 ++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |  1525 +++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c |   397 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |  1682 +++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  6187 +++++++++++
 8 files changed, 10459 insertions(+), 10215 deletions(-)
 delete mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c

-- 
2.5.5

