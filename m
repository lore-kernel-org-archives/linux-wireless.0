Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:45099 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaFWVrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 17:47:19 -0400
Received: by mail-we0-f179.google.com with SMTP id w62so7692416wes.38
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 14:47:17 -0700 (PDT)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Peter Wu <peter@lekensteyn.nl>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCHv3 0/6] rtlwifi: Fix incorrect MSR mask
Date: Mon, 23 Jun 2014 23:48:16 +0200
Message-Id: <1403560098-7520-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20140623_234722_863841_FA0C5FB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An error was found in many rtlwifi drivers where an invalid mask was used,
(bt_msr & 0xfc) will never match 0x3. This has been corrected by supplying
a valid mask as a macro. Drivers which did not have this bug are still
modified for consistency.

Rickard Strandqvist (1):
  rtlwifi: Fix media status register mask AND Replace magic number by macro

 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/reg.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/reg.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/reg.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8723be/reg.h |    1 +
 drivers/staging/rtl8821ae/rtl8821ae/hw.c     |    2 +-
 drivers/staging/rtl8821ae/rtl8821ae/reg.h    |    1 +
 13 files changed, 13 insertions(+), 7 deletions(-)

-- 
1.7.10.4

