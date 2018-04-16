Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37120 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754291AbeDPNko (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 09:40:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: Add WMI_SERVICE_AVAILABLE_EVENT support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1522379640-6442-2-git-send-email-cjhuang@codeaurora.org>
References: <1522379640-6442-2-git-send-email-cjhuang@codeaurora.org>
To: Carl Huang <cjhuang@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180416134043.9422D60A00@smtp.codeaurora.org> (sfid-20180416_154047_693687_FC774656)
Date: Mon, 16 Apr 2018 13:40:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Carl Huang <cjhuang@codeaurora.org> wrote:

> Add WMI_SERVICE_AVAILABLE_EVENT to extend WMI_SERVICE_READY_EVENT,
> the 128bit service map in WMI_SERVICE_READY_EVENT is not enough
> for firmware to notice new WLAN service to host driver. Hereby,
> for thoese new WLAN service, firmware will notice host driver by
> WMI_SERVICE_AVAILABLE_EVENT.
> 
> Signed-off-by: Alan Liu <alanliu@codeaurora.org>
> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

This added a new sparse warning, I fixed it in the pending branch:

drivers/net/wireless/ath/ath10k/wmi.c:5283:35: warning: incorrect type in argument 4 (different base types)
drivers/net/wireless/ath/ath10k/wmi.c:5283:35:    expected unsigned long [unsigned] [usertype] len
drivers/net/wireless/ath/ath10k/wmi.c:5283:35:    got restricted __le32 [addressable] [usertype] service_map_ext_len

-- 
https://patchwork.kernel.org/patch/10316767/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
