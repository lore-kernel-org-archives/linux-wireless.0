Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl1-f179.google.com ([209.85.214.179]:41143 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbeIONsT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Sep 2018 09:48:19 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] net: wireless: ath9k: Possible sleep-in-atomic-context bugs
To: ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <9cb1a877-f62b-c70b-d537-6552323de8ae@gmail.com> (sfid-20180915_103024_402933_D2674D20)
Date: Sat, 15 Sep 2018 16:30:04 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My static analysis tool DSAC reports some bugs caused by mutex_lock() in 
ath9k_regwrite_buffer() and ath9k_reg_rmw_buffer().

Here are the related function call paths (from bottom to top) in Linux-4.17:

[FUNC] mutex_lock_nested
drivers/net/wireless/ath/ath9k/htc_drv_init.c, 329:
     mutex_lock_nested in ath9k_regwrite_buffer
drivers/net/wireless/ath/ath9k/htc_drv_init.c, 353:
     ath9k_regwrite_buffer in ath9k_regwrite
drivers/net/wireless/ath/ath9k/mac.c, 146:
     [FUNC_PTR]ath9k_regwrite in ath9k_hw_abort_tx_dma
drivers/net/wireless/ath/ath9k/xmit.c, 1911:
     ath9k_hw_abort_tx_dma in ath_drain_all_txq
drivers/net/wireless/ath/ath9k/main.c, 225:
     ath_drain_all_txq in ath_prepare_reset
drivers/net/wireless/ath/ath9k/main.c, 307:
     ath_prepare_reset in ath_reset_internal
drivers/net/wireless/ath/ath9k/main.c, 295:
     spin_lock_bh in ath_reset_internal

[FUNC] mutex_lock_nested
drivers/net/wireless/ath/ath9k/htc_drv_init.c, 392:
     mutex_lock_nested in ath9k_reg_rmw_buffer
drivers/net/wireless/ath/ath9k/htc_drv_init.c, 509:
     ath9k_reg_rmw_buffer in ath9k_reg_rmw
drivers/net/wireless/ath/ath9k/mac.c, 148:
     [FUNC_PTR]ath9k_reg_rmw in ath9k_hw_abort_tx_dma
drivers/net/wireless/ath/ath9k/xmit.c, 1911:
     ath9k_hw_abort_tx_dma in ath_drain_all_txq
drivers/net/wireless/ath/ath9k/main.c, 225:
     ath_drain_all_txq in ath_prepare_reset
drivers/net/wireless/ath/ath9k/main.c, 307:
     ath_prepare_reset in ath_reset_internal
drivers/net/wireless/ath/ath9k/main.c, 295:
     spin_lock_bh in ath_reset_internal

[FUNC] mutex_lock_nested
drivers/net/wireless/ath/ath9k/htc_drv_init.c, 392:
     mutex_lock_nested in ath9k_reg_rmw_buffer
drivers/net/wireless/ath/ath9k/htc_drv_init.c, 509:
     ath9k_reg_rmw_buffer in ath9k_reg_rmw
drivers/net/wireless/ath/ath9k/hw.c, 2188:
     [FUNC_PTR]ath9k_reg_rmw in ath9k_hw_set_power_awake
drivers/net/wireless/ath/ath9k/hw.c, 2237:
     ath9k_hw_set_power_awake in ath9k_hw_setpower
drivers/net/wireless/ath/ath9k/main.c, 125:
     ath9k_hw_setpower in ath9k_ps_wakeup
drivers/net/wireless/ath/ath9k/main.c, 386:
     ath9k_ps_wakeup in ath9k_tasklet (tasklet handler)

[FUNC] mutex_lock_nested
drivers/net/wireless/ath/ath9k/htc_drv_init.c, 329:
     mutex_lock_nested in ath9k_regwrite_buffer
drivers/net/wireless/ath/ath9k/htc_drv_init.c, 353:
     ath9k_regwrite_buffer in ath9k_regwrite
drivers/net/wireless/ath/ath9k/htc_drv_init.c, 503:
     [FUNC_PTR]ath9k_regwrite in ath9k_reg_rmw
drivers/net/wireless/ath/ath9k/hw.c, 2188:
     [FUNC_PTR]ath9k_reg_rmw in ath9k_hw_set_power_awake
drivers/net/wireless/ath/ath9k/hw.c, 2237:
     ath9k_hw_set_power_awake in ath9k_hw_setpower
drivers/net/wireless/ath/ath9k/main.c, 125:
     ath9k_hw_setpower in ath9k_ps_wakeup
drivers/net/wireless/ath/ath9k/main.c, 386:
     ath9k_ps_wakeup in ath9k_tasklet (tasklet handler)

Note that [FUNC_PTR] means a function pointer call is used.

I am not sure how to well fix these bugs if they are real.


Best wishes,
Jia-Ju Bai
