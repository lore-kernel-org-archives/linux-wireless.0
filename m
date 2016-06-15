Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:32818 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbcFOFau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2016 01:30:50 -0400
Received: by mail-pa0-f53.google.com with SMTP id b13so3952145pat.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2016 22:30:50 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v3 0/5] *** staging: wilc1000: Replace semaphores with mutexes or completions ***
Date: Wed, 15 Jun 2016 11:00:33 +0530
Message-Id: <1465968638-22129-1-git-send-email-binoy.jayan@linaro.org> (sfid-20160615_073310_604281_5A39104A)
In-Reply-To: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are a set of patches [v3] which removes semaphores from:

drivers/staging/wilc1000

These are part of a bigger effort to eliminate all semaphores
from the linux kernel.

They build correctly (individually and as a whole).

NB: The changes are untested

Changes w.r.t. review comments on v1

1. Whitespace removed in patch 3
2. Removed semaphore 'close_exit_sync'
3. To rework on patch 6 and send in a seperate patch series

Binoy Jayan (5):
  staging: wilc1000: Replace semaphore txq_event with completion
  staging: wilc1000: Replace semaphore txq_add_to_head_cs with mutex
  staging: wilc1000: Replace semaphore cfg_event with completion
  staging: wilc1000: Replace semaphore sync_event with completion
  staging: wilc1000: Remove semaphore close_exit_sync

 drivers/staging/wilc1000/linux_wlan.c         | 31 ++++++++++--------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 10 ++++----
 drivers/staging/wilc1000/wilc_wlan.c          | 34 +++++++++++++--------------
 3 files changed, 35 insertions(+), 40 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

