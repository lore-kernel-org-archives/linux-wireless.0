Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:47044 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab1EYAiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 20:38:50 -0400
Received: by pxi16 with SMTP id 16so4724946pxi.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 17:38:49 -0700 (PDT)
Message-ID: <4DDC4F7C.6000802@ring3k.org> (sfid-20110525_023853_618842_096C253A)
Date: Wed, 25 May 2011 09:38:20 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/8] rtl8192ce stability improvements
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi John,

The following patch series is aimed at improving the stability
of the rtl8192ce driver, with a bit of cleanup thrown in.

[Rebased onto 66b00115d, added Larry's Signed-Off]

thanks,

Mike

Mike McCormack (8):
  rtlwifi: Synchronize IRQ after disabling it
  rtlwifi: Remove set_rfpowerstate_inprogress
  rtlwifi: Store loop index in local variable
  rtlwifi: Run IPS leave work in a tasklet
  rtlwifi: Don't block interrupts in spinlocks
  rtlwifi: Assign rx buffer ownership to hardware last
  rtlwifi: Use write barrier when assigning ownership
  rtlwifi: Fix logic in rx_interrupt

 drivers/net/wireless/rtlwifi/pci.c           |   41 ++++++++++++++----------
 drivers/net/wireless/rtlwifi/ps.c            |   45 +++++++++++---------------
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c  |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c |   12 ++----
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |    2 +
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c |    2 -
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c |   14 ++------
 drivers/net/wireless/rtlwifi/wifi.h          |    2 +-
 8 files changed, 55 insertions(+), 64 deletions(-)

-- 
1.7.4.1

