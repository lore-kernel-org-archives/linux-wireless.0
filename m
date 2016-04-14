Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbcDNUh2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 16:37:28 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 00/16] rtl8xxxu - additional fixes
Date: Thu, 14 Apr 2016 16:37:05 -0400
Message-Id: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_223732_080377_9517E45C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This is a second set of rtl8xxxu related patches, which goes on top of
the set I sent out earlier today. If you only have time to go through
one set, please look at the other set.

This set primarily contains fixes to make rtl8188ru v2 devices work
again. I have reports that v1 devices still don't work, but I don't
have one of those, so I am not able to test this.

This also includes a fix for a crash reported by Xose Vazquez Peres
when trying to hot add a USB ID. It marks 0x050d:0x1004 as tested,
reported by Andrea Merello, and handles an old bug where the
driver didn't unregister from mac80211 before shutting down the
device. Last it includes a uninitialized return value fix from Colin
Ian King.

Cheers,
Jes


Colin Ian King (1):
  rtl8xxxu: fix uninitialized return value in ret

Jes Sorensen (15):
  rtl8xxxu: Mark 0x050d:0x1004 as tested
  rtl8xxxu: Move PHY RF init into device specific functions
  rtl8xxxu: For devices with external PA (8188RU), limit CCK TX power
  rtl8xxxu: Apply 8188RU workaround for UMC B cut parts correctly
  rtl8xxxu: Use rtl_chip == RTL8188R to identify high PA parts
  rtl8xxxu: Match 8723bu power down sequence to vendor driver
  rtl8xxxu: Unregister from mac80211 before shutting down the device
  rtl8xxxu: Update copyright statement to include 2016
  rtl8xxxu: Set register 0xfe10 on rtl8192cu based parts
  rtl8xxxu: Add TX power base values for gen1 parts
  rtl8xxxu: Fix 8188RU support
  rtl8xxxu: Fix OOPS if user tries to add device via /sys
  rtl8xxxu: Implement rtl8192e_enable_rf()
  rtl8xxxu: Pause TX before calling disable_rf()
  rtl8xxxu: MAINTAINERS: Update to point to the active devel branch

 MAINTAINERS                                        |   2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   | 378 +++++++++++++++------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  30 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |   2 +-
 4 files changed, 306 insertions(+), 106 deletions(-)

-- 
2.5.5

