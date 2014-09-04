Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:48916 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbaIDIvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 04:51:20 -0400
Received: by mail-oi0-f54.google.com with SMTP id a3so6559129oib.27
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 01:51:19 -0700 (PDT)
MIME-Version: 1.0
From: Matteo Croce <matteo@openwrt.org>
Date: Thu, 4 Sep 2014 10:50:39 +0200
Message-ID: <CAFnufp1Rg2JOLM4d6g_=uF+Nrydt0Wy_4DK85bnqNHkthD9zQw@mail.gmail.com> (sfid-20140904_105125_766661_773F2FD4)
Subject: [PATCH] ath10k: ATH10K_DEBUGFS depends on DEBUG_FS
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

enable ath10k debugfs only when debugfs is enabled,
fixes an invalid pointer on module insert

--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -24,7 +24,7 @@ config ATH10K_DEBUG

 config ATH10K_DEBUGFS
  bool "Atheros ath10k debugfs support"
- depends on ATH10K
+ depends on ATH10K && DEBUG_FS
  select RELAY
  ---help---
   Enabled debugfs support
