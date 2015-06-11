Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13006 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbbFKSve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 14:51:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: dump fw features during probing
References: <1433765734-646-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 11 Jun 2015 21:51:21 +0300
In-Reply-To: <1433765734-646-1-git-send-email-michal.kazior@tieto.com> (Michal
	Kazior's message of "Mon, 8 Jun 2015 14:15:33 +0200")
Message-ID: <871thiaxjq.fsf@kamboji.qca.qualcomm.com> (sfid-20150611_205137_527201_79896074)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This should help when analysing problems from
> users and spot fw api blob problems easier.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> +static unsigned int ath10k_core_get_fw_feature_str(char *buf,
> +						   size_t buf_len,
> +						   enum ath10k_fw_features feat)
> +{
> +	if (feat >= ARRAY_SIZE(ath10k_core_fw_feature_str) ||
> +	    WARN_ON(!ath10k_core_fw_feature_str[feat])) {
> +		return scnprintf(buf, buf_len, "bit%d", feat);
> +	} else {
> +		return scnprintf(buf, buf_len, "%s",
> +				 ath10k_core_fw_feature_str[feat]);
> +	}
> +}

I think the else is useless and did the change below in pending branch.
Please review.

--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -123,10 +123,9 @@ static unsigned int ath10k_core_get_fw_feature_str(char *buf,
        if (feat >= ARRAY_SIZE(ath10k_core_fw_feature_str) ||
            WARN_ON(!ath10k_core_fw_feature_str[feat])) {
                return scnprintf(buf, buf_len, "bit%d", feat);
-       } else {
-               return scnprintf(buf, buf_len, "%s",
-                                ath10k_core_fw_feature_str[feat]);
        }
+
+       return scnprintf(buf, buf_len, "%s", ath10k_core_fw_feature_str[feat]);
 }
 
 void ath10k_core_get_fw_features_str(struct ath10k *ar,

-- 
Kalle Valo
