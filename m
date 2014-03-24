Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20737 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbaCXLVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 07:21:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath10k:  Better firmware loading error messages.
References: <1395428150-31996-1-git-send-email-greearb@candelatech.com>
	<1395428150-31996-2-git-send-email-greearb@candelatech.com>
Date: Mon, 24 Mar 2014 13:21:32 +0200
In-Reply-To: <1395428150-31996-2-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Fri, 21 Mar 2014 11:55:49
	-0700")
Message-ID: <87wqfj6dvn.fsf@kamboji.qca.qualcomm.com> (sfid-20140324_122140_044601_4CFA74FE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Let user know the name of the board file if it is not
> found, and make it easier to determine if it is api-1
> or api-n firmware logic that is complaining.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 35f9db4..bf5119f 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -398,7 +398,7 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
>  	/* first fetch the firmware file (firmware-*.bin) */
>  	ar->firmware = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, name);
>  	if (IS_ERR(ar->firmware)) {
> -		ath10k_err("Could not fetch firmware file '%s': %ld\n",
> +		ath10k_err("api-n: Could not fetch firmware file '%s': %ld\n",
>  			   name, PTR_ERR(ar->firmware));
>  		return PTR_ERR(ar->firmware);
>  	}

I see the problem, but I don't think "api-n" is any better. What about
something along these lines (not a complete patch):

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 471c219e5137..1b84c54449cf 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -398,8 +398,8 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
        /* first fetch the firmware file (firmware-*.bin) */
        ar->firmware = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, name);
        if (IS_ERR(ar->firmware)) {
-               ath10k_err("Could not fetch firmware file '%s': %ld\n",
-                          name, PTR_ERR(ar->firmware));
+               ath10k_err("Could not fetch firmware file '%s/%s': %ld\n",
+                          ar->hw_params.fw.dir, name, PTR_ERR(ar->firmware));
                return PTR_ERR(ar->firmware);
        }
 
@@ -410,8 +410,8 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
        magic_len = strlen(ATH10K_FIRMWARE_MAGIC) + 1;
 
        if (len < magic_len) {
-               ath10k_err("firmware image too small to contain magic: %zu\n",
-                          len);
+               ath10k_err("firmware file '%s/%s' too small to contain magic: %zu\n",
+                          ar->hw_params.fw.dir, name, len);
                ret = -EINVAL;
                goto err;
        }
@@ -558,19 +558,23 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
 {
        int ret;
 
+       ar->fw_api = 2;
+
+       ath10k_dbg(ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
+
        ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API2_FILE);
-       if (ret == 0) {
-               ar->fw_api = 2;
-               goto out;
-       }
+       if (ret == 0)
+               goto success;
+
+       ar->fw_api = 1;
+
+       ath10k_dbg(ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
 
        ret = ath10k_core_fetch_firmware_api_1(ar);
        if (ret)
                return ret;
 
-       ar->fw_api = 1;
-
-out:
+success:
        ath10k_dbg(ATH10K_DBG_BOOT, "using fw api %d\n", ar->fw_api);
 
        return 0;


-- 
Kalle Valo
