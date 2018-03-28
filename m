Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47498 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753710AbeC1PlB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 11:41:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v7,3/5] ath10k: Enable TDLS peer inactivity detection
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1508835074-3384-4-git-send-email-yintang@qti.qualcomm.com>
References: <1508835074-3384-4-git-send-email-yintang@qti.qualcomm.com>
To: yintang@qti.qualcomm.com
Cc: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-Id: <20180328154100.E077060AFB@smtp.codeaurora.org> (sfid-20180328_174105_247000_7EE853CE)
Date: Wed, 28 Mar 2018 15:41:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

yintang@qti.qualcomm.com wrote:

> Enable TDLS peer inactivity detetion feature.
> QCA6174 firmware(version: WLAN.RM.4.4) support TDLS link inactivity detecting.
> Set related parameters in TDLS WMI command to enable this feature.
> 
> Signed-off-by: Yingying Tang <yintang@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

This patch added new ath10k-check warnings:

drivers/net/wireless/ath/ath10k/wmi-tlv.c:460:48: warning: incorrect type in argument 2 (different base types)
drivers/net/wireless/ath/ath10k/wmi-tlv.c:460:48:    expected unsigned int [unsigned] [usertype] vdev_id
drivers/net/wireless/ath/ath10k/wmi-tlv.c:460:48:    got restricted __le32 const [usertype] vdev_id
drivers/net/wireless/ath/ath10k/wmi-tlv.c:448:19: warning: restricted __le32 degrades to integer
drivers/net/wireless/ath/ath10k/wmi-tlv.c:448:19: warning: restricted __le32 degrades to integer
drivers/net/wireless/ath/ath10k/wmi-tlv.c:429:6: warning: symbol 'ath10k_wmi_event_tdls_peer' was not declared. Should it be static?
drivers/net/wireless/ath/ath10k/wmi-tlv.h:1767: Please don't use multiple blank lines

I fixed those in the pending branch.

-- 
https://patchwork.kernel.org/patch/10023743/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
