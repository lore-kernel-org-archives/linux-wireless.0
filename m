Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44575 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbcCWNAW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 09:00:22 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"mohammed@codeaurora.org" <mohammed@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v1 3/3] ath10k: Enable parsing per station rx duration for
 10.4
Date: Wed, 23 Mar 2016 13:00:01 +0000
Message-ID: <8737rhfiy7.fsf@kamboji.qca.qualcomm.com> (sfid-20160323_140032_667771_5E3EA109)
References: <1458132214-4896-1-git-send-email-mohammed@qca.qualcomm.com>
	<1458132214-4896-3-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1458132214-4896-3-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Wed, 16 Mar 2016 18:13:34	+0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> Rx duration support for per station is part of extended peer
> stats, enable provision to parse the same and provide backward
> compatibility based on the 'stats_id' event
>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

There was a new sparse warning:

drivers/net/wireless/ath/ath10k/wmi.c:2978:42: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath10k/wmi.c:2978:42:    expected unsigned int [unsigned] [usertype] rx_duration
drivers/net/wireless/ath/ath10k/wmi.c:2978:42:    got restricted __le32 const [usertype] rx_duration

I fixed it like this in the pending branch, please double check:

--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2975,7 +2975,7 @@ static int ath10k_wmi_10_4_op_pull_fw_stats(struct ath10k *ar,
                ath10k_wmi_10_4_pull_peer_stats(&src->common, dst);
                /* FIXME: expose 10.4 specific values */
                if (extd_peer_stats)
-                       dst->rx_duration = src->rx_duration;
+                       dst->rx_duration = __le32_to_cpu(src->rx_duration);
 
                list_add_tail(&dst->list, &stats->peers);
        }

-- 
Kalle Valo