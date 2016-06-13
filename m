Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:33178 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965047AbcFMKiC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 06:38:02 -0400
Received: by mail-pf0-f169.google.com with SMTP id y124so45213656pfy.0
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2016 03:38:01 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 0/7] *** staging: wilc1000: Replace semaphores with mutexes or completions ***
Date: Mon, 13 Jun 2016 16:07:32 +0530
Message-Id: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org> (sfid-20160613_124051_007301_DBCE23D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

These are a set of patches which removes semaphores from:

drivers/staging/wilc1000

These are part of a bigger effort to eliminate all semaphores
from the linux kernel.

They build correctly (individually and as a whole).

NB: The changes are untested

Thanks,
Binoy

Binoy Jayan (7):
  staging: wilc1000: Replace semaphore txq_event with completion
  staging: wilc1000: Replace semaphore txq_add_to_head_cs with mutex
  staging: wilc1000: Replace semaphore cfg_event with completion
  staging: wilc1000: Replace semaphore sync_event with completion
  staging: wilc1000: Replace semaphore close_exit_sync with completion
  staging: wilc1000: message_queue: Replace semaphore sem with
    completion
  staging: wilc1000: Remove unused inclusion of semaphore header

 drivers/staging/wilc1000/TODO                 |  1 -
 drivers/staging/wilc1000/linux_wlan.c         | 45 ++++++++++-----------------
 drivers/staging/wilc1000/wilc_msgqueue.c      | 13 ++++----
 drivers/staging/wilc1000/wilc_msgqueue.h      |  4 +--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 13 ++++----
 drivers/staging/wilc1000/wilc_wlan.c          | 35 +++++++++++----------
 drivers/staging/wilc1000/wilc_wlan.h          |  2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h       |  1 -
 8 files changed, 52 insertions(+), 62 deletions(-)

-- 
2.7.4

