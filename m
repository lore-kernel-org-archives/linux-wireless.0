Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49164 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756176AbcKKIfv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 03:35:51 -0500
Message-ID: <1478853340.15030.21.camel@coelho.fi> (sfid-20161111_093621_278926_FEDD00CD)
From: Luca Coelho <luca@coelho.fi>
To: Tj <linux@iam.tj>,
        "open list:INTEL WIRELESS WIFI LINK (iwlwifi)"
        <linux-wireless@vger.kernel.org>
Cc: "Intel Linux Wireless (supporter:INTEL WIRELESS WIFI LINK (iwlwifi))"
        <linuxwifi@intel.com>
Date: Fri, 11 Nov 2016 10:35:40 +0200
In-Reply-To: <78f29b89-eb19-920f-f576-5009383c55e1@iam.tj>
References: <78f29b89-eb19-920f-f576-5009383c55e1@iam.tj>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: fix undefined 6000G2B firmware MAX API version
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
On Thu, 2016-11-10 at 22:04 +0000, Tj wrote:
>   $ modinfo -F firmware iwlwifi | grep API
>   iwlwifi-6000g2b-IWL6000G2B_UCODE_API_MAX.ucode
>   $ modinfo -F vermagic iwlwifi
>   4.9.0-040900rc4-lowlatency SMP preempt mod_unload modversions
> 
> Change-Id: Ie21a4be0b12b520844c1da4a8bef9e8a0097d919
> Signed-off-by: TJ <linux@iam.tj>
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-6000.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
> b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
> index 0b9f6a7..19b85e8 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
> @@ -34,6 +34,7 @@
>  #define IWL6000_UCODE_API_MAX 6
>  #define IWL6050_UCODE_API_MAX 5
>  #define IWL6000G2_UCODE_API_MAX 6
> +#define IWL6000G2B_UCODE_API_MAX 6
>  #define IWL6035_UCODE_API_MAX 6
>   /* Lowest firmware API version supported */

Thanks for your patch! But the correct thing to do would be to change
the MODULE_FIRMWARE line instead of adding this define here.  The 6030
NIC uses IWL6000G2_UCODE_API_MAX in the config structure, so the
MODULE_FIRMWARE macro should use that too.

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
index 0b9f6a7..39335b7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
@@ -371,4 +371,4 @@ const struct iwl_cfg iwl6000_3agn_cfg = {
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2B_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));

--
Cheers,
Luca.
