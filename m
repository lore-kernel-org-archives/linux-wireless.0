Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35772 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751750AbeCZPJ1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 11:09:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: debugfs support to get final TPC stats for 10.4
 variants
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1519634437-6672-1-git-send-email-mkenna@codeaurora.org>
References: <1519634437-6672-1-git-send-email-mkenna@codeaurora.org>
To: mkenna@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>
Message-Id: <20180326150927.4D92E60710@smtp.codeaurora.org> (sfid-20180326_170931_356880_F379E86F)
Date: Mon, 26 Mar 2018 15:09:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mkenna@codeaurora.org wrote:

> Export the final Transmit Power Control (TPC) value, which is the
> minimum of control power and existing TPC value to user space via
> a new debugfs file "tpc_stats_final" to help with debugging.
> It works with the new wmi cmd and event introduced in 10.4 firmware
> branch.
> 
> WMI command ID: WMI_PDEV_GET_TPC_TABLE_CMDID
> WMI event ID: WMI_PDEV_TPC_TABLE_EVENTID
> 
> cat /sys/kernel/debug/ieee80211/phyX/ath10k/tpc_stats_final
> 
> $ cat /sys/kernel/debug/ieee80211/phyX/ath10k/tpc_stats_final
> 
> TPC config for channel 5180 mode 10
> 
> CTL             =  0x 0 Reg. Domain             = 58
> Antenna Gain    =  0 Reg. Max Antenna Gain      =   0
> Power Limit     = 60 Reg. Max Power             = 60
> Num tx chains   =  2 Num supported rates        = 109
> 
> ******************* CDD POWER TABLE ****************
> 
> No.  Preamble Rate_code tpc_value1 tpc_value2 tpc_value3
> 0    CCK      0x40        0          0
> 1    CCK      0x41        0          0
> [...]
> 107  HTCUP    0x 0       46          46
> 108  HTCUP    0x 0       46          46
> 
> ******************* STBC POWER TABLE ****************
> 
> No.  Preamble Rate_code tpc_value1 tpc_value2 tpc_value3
> 0    CCK      0x40        0          0
> 1    CCK      0x41        0          0
> [...]
> 107  HTCUP    0x 0        46         46
> 108  HTCUP    0x 0        46         46
> 
> ***********************************
> TXBF not supported
> **********************************
> 
> The existing tpc_stats debugfs file provides the dump
> which is minimum of target power and regulatory domain.
> 
> cat /sys/kernel/debug/ieee80211/phyX/ath10k/tpc_stats
> 
> Hardware_used: QCA4019
> Firmware version: firmware-5.bin_10.4-3.0-00209
> 
> Signed-off-by: Maharaja Kennadyrajan <mkenna@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

bc64d05220f3 ath10k: debugfs support to get final TPC stats for 10.4 variants

-- 
https://patchwork.kernel.org/patch/10241601/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
