Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42185 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbcFDN0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 09:26:45 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Sven Eckelmann <sven.eckelmann@open-mesh.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: Add board data download from target
Date: Sat, 4 Jun 2016 13:26:39 +0000
Message-ID: <87porxt78w.fsf@kamboji.qca.qualcomm.com> (sfid-20160604_152648_743331_60045B21)
References: <1568876.Six5hABE57@bentobox>
	<1463755272-12912-2-git-send-email-sven.eckelmann@open-mesh.com>
In-Reply-To: <1463755272-12912-2-git-send-email-sven.eckelmann@open-mesh.com>
	(Sven Eckelmann's message of "Fri, 20 May 2016 16:41:12 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@open-mesh.com> writes:

> The QCA9887 stores its calibration data (board.bin) inside the EEPROM of
> the target. This has to be downloaded manually to allow the device to
> initialize correctly.
>
> Signed-off-by: Sven Eckelmann <sven.eckelmann@open-mesh.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -18,6 +18,7 @@
>  #include <linux/module.h>
>  #include <linux/firmware.h>
>  #include <linux/of.h>
> +#include <asm/byteorder.h>
>  
>  #include "core.h"
>  #include "mac.h"
> @@ -550,6 +551,34 @@ out:
>  	return ret;
>  }
>  
> +static int ath10k_download_cal_eeprom(struct ath10k *ar)
> +{
> +	size_t data_len;
> +	void *data = NULL;
> +	int ret;
> +
> +	ret = ath10k_hif_fetch_target_board_data(ar, &data, &data_len);
> +	if (ret) {
> +		ath10k_warn(ar, "failed to read calibration data from EEPROM: %d\n",
> +			    ret);
> +		goto out_free;
> +	}

Looking at this again I noticed that we issue this warning even if
EEPROM is not supported, which I think is wrong. I fixed this in the
pending branch, the diff is below.

I also renamed target_board_data to cal_eeprom because, at least to my
understanding, the eeprom actually contains the real calibration data,
not the board data file.

Please review so that I didn't break anything.

https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=4f79bdf2db7bcfa9c7c093fd423af801b9797c63

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 10a1b620a68b..1e88251ca6d0 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -580,10 +580,11 @@ static int ath10k_download_cal_eeprom(struct ath10k *ar)
 	void *data = NULL;
 	int ret;
 
-	ret = ath10k_hif_fetch_target_board_data(ar, &data, &data_len);
+	ret = ath10k_hif_fetch_cal_eeprom(ar, &data, &data_len);
 	if (ret) {
-		ath10k_warn(ar, "failed to read calibration data from EEPROM: %d\n",
-			    ret);
+		if (ret != -EOPNOTSUPP)
+			ath10k_warn(ar, "failed to read calibration data from EEPROM: %d\n",
+				    ret);
 		goto out_free;
 	}
 
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index c18b8c81bde4..b2566b06e1e1 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -88,9 +88,9 @@ struct ath10k_hif_ops {
 	int (*suspend)(struct ath10k *ar);
 	int (*resume)(struct ath10k *ar);
 
-	/* fetch board data from target eeprom */
-	int (*fetch_target_board_data)(struct ath10k *ar, void **data,
-				       size_t *data_len);
+	/* fetch calibration data from target eeprom */
+	int (*fetch_cal_eeprom)(struct ath10k *ar, void **data,
+				size_t *data_len);
 };
 
 static inline int ath10k_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
@@ -206,14 +206,14 @@ static inline void ath10k_hif_write32(struct ath10k *ar,
 	ar->hif.ops->write32(ar, address, data);
 }
 
-static inline int ath10k_hif_fetch_target_board_data(struct ath10k *ar,
-						     void **data,
-						     size_t *data_len)
+static inline int ath10k_hif_fetch_cal_eeprom(struct ath10k *ar,
+					      void **data,
+					      size_t *data_len)
 {
-	if (!ar->hif.ops->fetch_target_board_data)
+	if (!ar->hif.ops->fetch_cal_eeprom)
 		return -EOPNOTSUPP;
 
-	return ar->hif.ops->fetch_target_board_data(ar, data, data_len);
+	return ar->hif.ops->fetch_cal_eeprom(ar, data, data_len);
 }
 
 #endif /* _HIF_H_ */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index fb53f8846efd..f06dd3941bac 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2678,8 +2678,8 @@ static int ath10k_pci_read_eeprom(struct ath10k *ar, u16 addr, u8 *out)
 	return 0;
 }
 
-static int ath10k_pci_fetch_target_board_data(struct ath10k *ar, void **data,
-					      size_t *data_len)
+static int ath10k_pci_hif_fetch_cal_eeprom(struct ath10k *ar, void **data,
+					   size_t *data_len)
 {
 	u8 *caldata = NULL;
 	size_t calsize, i;
@@ -2734,7 +2734,7 @@ static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.suspend		= ath10k_pci_hif_suspend,
 	.resume			= ath10k_pci_hif_resume,
 #endif
-	.fetch_target_board_data = ath10k_pci_fetch_target_board_data,
+	.fetch_cal_eeprom	= ath10k_pci_hif_fetch_cal_eeprom,
 };
 
 /*

-- 
Kalle Valo