Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31821 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbbABHqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2015 02:46:06 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Enable RX batching
References: <1419834084-11859-1-git-send-email-sujith@msujith.org>
Date: Fri, 2 Jan 2015 09:45:54 +0200
In-Reply-To: <1419834084-11859-1-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Mon, 29 Dec 2014 11:51:24 +0530")
Message-ID: <87fvbt62x9.fsf@kamboji.qca.qualcomm.com> (sfid-20150102_084612_223034_C9226BBA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> This feature allows the FW to batch RX indications,
> reducing the rate of host interrupt generation, which
> in turn reduces CPU load. Currently, this is enabled
> only for the 10.2 firmware.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Any throughput improvements?

Also I simplified the patch a bit in ath-next-test:

--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3710,7 +3710,7 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
        struct wmi_init_cmd_10_2 *cmd;
        struct sk_buff *buf;
        struct wmi_resource_config_10x config = {};
-       u32 len, val, features = 0;
+       u32 len, val, features;
 
        config.num_vdevs = __cpu_to_le32(TARGET_10X_NUM_VDEVS);
        config.num_peers = __cpu_to_le32(TARGET_10X_NUM_PEERS);
@@ -3764,7 +3764,7 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 
        cmd = (struct wmi_init_cmd_10_2 *)buf->data;
 
-       features |= WMI_10_2_RX_BATCH_MODE;
+       features = WMI_10_2_RX_BATCH_MODE;
        cmd->resource_config.feature_mask = __cpu_to_le32(features);
 
        memcpy(&cmd->resource_config.common, &config, sizeof(config));


-- 
Kalle Valo
