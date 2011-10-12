Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48436 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab1JLC3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 22:29:07 -0400
Received: by ggnv2 with SMTP id v2so221004ggn.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 19:29:06 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/5 V2] Updates to match latest Realtek version and new PM framework
Date: Tue, 11 Oct 2011 21:28:46 -0500
Message-Id: <1318386531-5859-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20111012_042931_468192_BC1B2EBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest Realtek driver for rtl8192ce, rtl8192se, and rtl8192de incorporates
some changes. With these patches, the changes are added to the mainline
drivers. In addition, the drivers are changed to the new PM framework.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

V1 of these patches had been applied to git://git.infradead.org/users/linville/wireless-testing.git.

I had committed them to my local tree and let git generate the patches. For V2, I switched to
git://git.infradead.org/users/linville/wireless-next.git. A pull on the new tree got the objects
from the for-davem branch, but master was unchanged. I reverted all 5 from my tree, imported the
patches with quilt and cleaned them up. They all apply cleanly with no warnings and no fuzz.

If I understood your mail message correctly, patches 1, 2, 3, and 5 have already been applied,
but I'm sending a new version just in case. Patches 4 and 5 can be applied in any order - thus
4 will work by itself.

Sorry for any problems.

Larry
---

Chaoming Li (4):
  rtlwifi: Update to new Realtek version - Part I
  rtlwifi: rtl8192ce: Add new chip revisions
  rtlwifi: rtl8192se: Updates from latest Realtek driver version - Part
    II
  rtlwifi: rtl8192de: Updates from latest Reaktek driver - Part III

Larry Finger (1):
  rtlwifi: Change PCI drivers to use the new PM framework

 drivers/net/wireless/rtlwifi/base.c          |    6 +-
 drivers/net/wireless/rtlwifi/pci.c           |   19 +---
 drivers/net/wireless/rtlwifi/pci.h           |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h |   14 +++
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  |   30 +++++--
 drivers/net/wireless/rtlwifi/rtl8192cu/def.h |    4 -
 drivers/net/wireless/rtlwifi/rtl8192de/def.h |  124 ++++++++++++++++----------
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c  |   19 ++---
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c  |   16 ++--
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c  |   22 +++---
 drivers/net/wireless/rtlwifi/rtl8192se/reg.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c  |   17 +++--
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |   53 +++++++-----
 drivers/net/wireless/rtlwifi/wifi.h          |    1 +
 14 files changed, 196 insertions(+), 134 deletions(-)

-- 
1.7.6.4

