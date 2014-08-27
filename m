Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:39106 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaH0H0a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 03:26:30 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ath10k: make target endianess more explicit
References: <1408961963-3682-1-git-send-email-michal.kazior@tieto.com>
	<1408961963-3682-4-git-send-email-michal.kazior@tieto.com>
Date: Wed, 27 Aug 2014 10:26:24 +0300
In-Reply-To: <1408961963-3682-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 25 Aug 2014 12:19:23 +0200")
Message-ID: <878umaxujj.fsf@kamboji.qca.qualcomm.com> (sfid-20140827_092633_305950_14F96B93)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Some copy engine structures are target specific
> and are uploaded to the device during
> init/configuration.
>
> This also cleans up a bit diag_mem_read/write
> implicit byteswap mess leaving only
> diag_access_read/write with an implicit endianess
> byteswap.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

>  static int ath10k_pci_diag_read32(struct ath10k *ar, u32 address, u32 *value)
>  {
> -	return ath10k_pci_diag_read_mem(ar, address, value, sizeof(u32));
> +	__le32 val = 0;
> +	int ret;
> +
> +	ret = ath10k_pci_diag_read_mem(ar, address, &val, sizeof(__le32));
> +	*value = __le32_to_cpu(val);
> +
> +	return ret;
>  }

For consistency, I folded a patch below. Is that ok?

--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -620,7 +620,7 @@ static int ath10k_pci_diag_read32(struct ath10k *ar, u32 address, u32 *value)
        __le32 val = 0;
        int ret;
 
-       ret = ath10k_pci_diag_read_mem(ar, address, &val, sizeof(__le32));
+       ret = ath10k_pci_diag_read_mem(ar, address, &val, sizeof(val));
        *value = __le32_to_cpu(val);
 
        return ret;

https://github.com/kvalo/ath/commit/1850a415873cb34a6f84b699dfb9a283df3252ec

-- 
Kalle Valo
