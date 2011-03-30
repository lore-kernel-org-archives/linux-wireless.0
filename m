Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47155 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab1C3Orj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 10:47:39 -0400
Received: by fxm17 with SMTP id 17so1106312fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2011 07:47:38 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ar9170usb: remove obsolete driver
Date: Wed, 30 Mar 2011 16:47:20 +0200
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103301647.20948.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As planned, all AR9170 devices are now supported by carl9170.
Therefore the outdated ar9170usb driver is no longer needed
and can be removed from the kernel entirely.

Because the patch is a little bit too big for comfort, I decided
to upload it instead to: 
<http://www.kernel.org/pub/linux/kernel/people/chr/0001-ar9170usb-purge-obsolete-driver.patch>
--
 Documentation/feature-removal-schedule.txt   |   11 
 MAINTAINERS                                  |    7 
 drivers/net/wireless/ath/Kconfig             |    1 
 drivers/net/wireless/ath/Makefile            |    1 
 drivers/net/wireless/ath/ar9170/Kconfig      |   20 
 drivers/net/wireless/ath/ar9170/Makefile     |    3 
 drivers/net/wireless/ath/ar9170/ar9170.h     |  258 ---
 drivers/net/wireless/ath/ar9170/cmd.c        |  127 -
 drivers/net/wireless/ath/ar9170/cmd.h        |   92 -
 drivers/net/wireless/ath/ar9170/eeprom.h     |  179 --
 drivers/net/wireless/ath/ar9170/hw.h         |  430 -----
 drivers/net/wireless/ath/ar9170/led.c        |  181 --
 drivers/net/wireless/ath/ar9170/mac.c        |  519 ------
 drivers/net/wireless/ath/ar9170/main.c       | 2190 ---------------------------
 drivers/net/wireless/ath/ar9170/phy.c        | 1719 ---------------------
 drivers/net/wireless/ath/ar9170/usb.c        | 1008 ------------
 drivers/net/wireless/ath/ar9170/usb.h        |   82 -
 17 files changed, 6828 deletions(-)
