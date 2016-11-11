Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yes.iam.tj ([109.74.197.121]:34418 "EHLO iam.tj"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755503AbcKKRrk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 12:47:40 -0500
Subject: Re: [PATCH] iwlwifi: fix undefined 6000G2B firmware MAX API version
To: Luca Coelho <luca@coelho.fi>,
        "open list:INTEL WIRELESS WIFI LINK (iwlwifi)"
        <linux-wireless@vger.kernel.org>
References: <78f29b89-eb19-920f-f576-5009383c55e1@iam.tj>
 <1478853340.15030.21.camel@coelho.fi>
Cc: "Intel Linux Wireless (supporter:INTEL WIRELESS WIFI LINK (iwlwifi))"
        <linuxwifi@intel.com>
From: Tj <linux@iam.tj>
Message-ID: <87adaa7e-3e64-51eb-f250-bf4f1c025b66@iam.tj> (sfid-20161111_184744_037072_4CCC2316)
Date: Fri, 11 Nov 2016 17:47:37 +0000
MIME-Version: 1.0
In-Reply-To: <1478853340.15030.21.camel@coelho.fi>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/11/16 08:35, Luca Coelho wrote:
> Hi,
> On Thu, 2016-11-10 at 22:04 +0000, Tj wrote:
>>   $ modinfo -F firmware iwlwifi | grep API
>>   iwlwifi-6000g2b-IWL6000G2B_UCODE_API_MAX.ucode
>>   $ modinfo -F vermagic iwlwifi
>>   4.9.0-040900rc4-lowlatency SMP preempt mod_unload modversions
>>
>> Change-Id: Ie21a4be0b12b520844c1da4a8bef9e8a0097d919
>> Signed-off-by: TJ <linux@iam.tj>
>> ---
>>  drivers/net/wireless/intel/iwlwifi/iwl-6000.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
>> b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
>> index 0b9f6a7..19b85e8 100644
>> --- a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
>> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
>> @@ -34,6 +34,7 @@
>>  #define IWL6000_UCODE_API_MAX 6
>>  #define IWL6050_UCODE_API_MAX 5
>>  #define IWL6000G2_UCODE_API_MAX 6
>> +#define IWL6000G2B_UCODE_API_MAX 6
>>  #define IWL6035_UCODE_API_MAX 6
>>   /* Lowest firmware API version supported */
> Thanks for your patch! But the correct thing to do would be to change
> the MODULE_FIRMWARE line instead of adding this define here.  The 6030
> NIC uses IWL6000G2_UCODE_API_MAX in the config structure, so the
> MODULE_FIRMWARE macro should use that too.
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
> b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
> index 0b9f6a7..39335b7 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-6000.c
> @@ -371,4 +371,4 @@ const struct iwl_cfg iwl6000_3agn_cfg = {
>  MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
>  MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
>  MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
> -MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2B_UCODE_API_MAX));
> +MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));

I don't think this is correct. There are different firmware files for
the 'g2a' (6005) and 'g2b' (6030) and as such the revisions for each
could be different, so setting the 6030 to use the same API_MAX as the
6005 looks wrong to me.

$ ls -1 /lib/firmware/iwlwifi-*6000g*
/lib/firmware/iwlwifi-6000g2a-5.ucode
/lib/firmware/iwlwifi-6000g2a-6.ucode
/lib/firmware/iwlwifi-6000g2b-6.ucode
