Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbbBFWYm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 17:24:42 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net, wlanfae@realtek.com,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 0/1] Clear correct ACM bit
Date: Fri,  6 Feb 2015 17:24:31 -0500
Message-Id: <1423261472-4607-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20150206_232445_517975_A28649D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Reading over the RTL driver code, I noticed that most of the
components in the rtlwifi driver would clear the wrong bit if it was
processing the VO queue and ACM was not set.

I am unable to test this, as I don't have the hardware, so please
double check before applying.

Jes

Jes Sorensen (1):
  rtlwifi: Clear ACM_CTRL AC3_VO bit correctly

 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8192ee/hw.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c | 2 +-
 drivers/net/wireless/rtlwifi/rtl8821ae/hw.c | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.1.0

