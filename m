Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:22530 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753258AbdJMMSe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 08:18:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/2] ath10k: handle tdls peer events
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1507618202-25473-3-git-send-email-mpubbise@qti.qualcomm.com>
References: <1507618202-25473-3-git-send-email-mpubbise@qti.qualcomm.com>
To: <mpubbise@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Manikanta Pubbisetty" <mpubbise@qti.qualcomm.com>
Message-ID: <e1bed0a347cf4ce0a1c538b99852398a@euamsexm01e.eu.qualcomm.com> (sfid-20171013_141837_948902_B49D74B9)
Date: Fri, 13 Oct 2017 14:18:26 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mpubbise@qti.qualcomm.com wrote:

> Handle tdls peer events from the target. TDLS events for the peer
> could be discover, teardown, etc. As of now, adding the logic to
> handle tdls teardown events alone.
> 
> Teardown due to peer traffic indication(PTR) timeout is one such
> teardown event from the target.
> 
> Tested this change on QCA9888 with 10.4-3.5.1-00018 fw version.
> 
> Signed-off-by: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

This patch introduces new warnings:

$ ath10k-check
drivers/net/wireless/ath/ath10k/wmi.c:4470:39: warning: incorrect type in argument 2 (different base types)
drivers/net/wireless/ath/ath10k/wmi.c:4470:39:    expected int [signed] vdev_id
drivers/net/wireless/ath/ath10k/wmi.c:4470:39:    got restricted __le32 [usertype] vdev_id
drivers/net/wireless/ath/ath10k/wmi.c:4481:27: warning: restricted __le32 degrades to integer
drivers/net/wireless/ath/ath10k/wmi.c:4481:27: warning: restricted __le32 degrades to integer
drivers/net/wireless/ath/ath10k/wmi.c:4481:27: warning: restricted __le32 degrades to integer
drivers/net/wireless/ath/ath10k/wmi.c:4492:48: warning: incorrect type in argument 2 (different base types)
drivers/net/wireless/ath/ath10k/wmi.c:4492:48:    expected unsigned int [unsigned] [usertype] vdev_id
drivers/net/wireless/ath/ath10k/wmi.c:4492:48:    got restricted __le32 [usertype] vdev_id
drivers/net/wireless/ath/ath10k/wmi.c:4479:19: warning: restricted __le32 degrades to integer
drivers/net/wireless/ath/ath10k/wmi.c:4460:6: warning: symbol 'ath10k_wmi_handle_tdls_peer_event' was not declared. Should it be static?

-- 
https://patchwork.kernel.org/patch/9995131/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
