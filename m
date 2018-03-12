Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34046 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932217AbeCLIz7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 04:55:59 -0400
Received: by mail-wm0-f49.google.com with SMTP id a20so12261091wmd.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2018 01:55:58 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: Add support for getting nvram contents from EFI
 variables
To: Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180311214751.12769-1-hdegoede@redhat.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AA6409E.6050300@broadcom.com> (sfid-20180312_095619_657902_1BA584E3)
Date: Mon, 12 Mar 2018 09:55:58 +0100
MIME-Version: 1.0
In-Reply-To: <20180311214751.12769-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/11/2018 10:47 PM, Hans de Goede wrote:
> Various models Asus laptops with a SDIO attached brcmfmac wifi chip, store
> the nvram contents in a special EFI variable. This commit adds support for
> getting nvram directly from this EFI variable, without the user needing to
> manually copy it.
>
> This makes Wifi / Bluetooth work out of the box on these devices instead of
> requiring manual setup.
>
> Note that at least on the Asus T200TA the nvram from the EFI variable
> wrongly contains "ccode=ALL" which the firmware does not understand, the
> code to fetch the nvram from the EFI variable will fix this up to:
> "ccode=XV" which is the correct way to specify the worldwide broadcast
> regime.
>
> This has been tested on the following models: Asus T100CHI, Asus T100HA,
> Asus T100TA and Asus T200TA

Hi Hans,

I like to have this as well, but .... (see below)

> Tested-by: Hans de Goede <hdegoede@redhat.com>

Duh. I would expect anyone to have tested their patches although you can 
not cover every system out there obviously :-p

> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>   .../broadcom/brcm80211/brcmfmac/firmware.c         | 68 +++++++++++++++++++++-
>   1 file changed, 67 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> index 091b52979e03..cbac407ae132 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> @@ -14,6 +14,8 @@
>    * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>    */
>
> +#include <linux/dmi.h>
> +#include <linux/efi.h>
>   #include <linux/kernel.h>
>   #include <linux/slab.h>
>   #include <linux/device.h>
> @@ -446,6 +448,67 @@ struct brcmf_fw {
>   		     void *nvram_image, u32 nvram_len);
>   };
>
> +#ifdef CONFIG_EFI
> +static u8 *brcmf_fw_nvram_from_efi(size_t *data_len_ret)
> +{
> +	const u16 name[] = { 'n', 'v', 'r', 'a', 'm', 0 };

Isn't there some helper function to make this conversion to u16 array? 
Hmm, maybe it is my itch to scratch later :-)

> +	struct efivar_entry *nvram_efivar;
> +	unsigned long data_len = 0;
> +	u8 *data = NULL;
> +	char *ccode;
> +	int err;
> +
> +	/* So far only Asus devices store the nvram in an EFI var */
> +	if (!dmi_name_in_vendors("ASUSTeK COMPUTER INC."))
> +		return NULL;

Actually had a Sony device with nvram in EFI. Why not just drop this 
optimization.

> +	nvram_efivar = kzalloc(sizeof(*nvram_efivar), GFP_KERNEL);
> +	if (!nvram_efivar)
> +		return NULL;
> +
> +	memcpy(&nvram_efivar->var.VariableName, name, sizeof(name));
> +	nvram_efivar->var.VendorGuid = EFI_GUID(0x74b00bd9, 0x805a, 0x4d61,
> +						0xb5, 0x1f, 0x43, 0x26,
> +						0x81, 0x23, 0xd1, 0x13);
> +
> +	err = efivar_entry_size(nvram_efivar, &data_len);
> +	if (err)
> +		goto fail;
> +
> +	data = kmalloc(data_len, GFP_KERNEL);
> +	if (!data)
> +		goto fail;
> +
> +	err = efivar_entry_get(nvram_efivar, NULL, &data_len, data);
> +	if (err)
> +		goto fail;
> +
> +	/* In some cases the EFI-var stored nvram contains "ccode=ALL" but
> +	 * the firmware does not understand "ALL" change this to "XV" which
> +	 * is the correct way to specify the "worldwide" compatible settings.
> +	 */

This is actually quite bad. The ALL ccode should never end up on the 
market as it is intended for internal use only during bringup project 
phase so these seems to be programmed wrong. Also simply selecting XV 
instead is not correct. There is not just one worldwide domain in the 
regulatory database of the firmware image.

> +	ccode = strnstr((char *)data, "ccode=ALL", data_len);
> +	if (ccode) {
> +		ccode[6] = 'X';
> +		ccode[7] = 'V';
> +		ccode[8] = '\n';
> +	}
> +
> +	brcmf_info("Using nvram EFI variable\n");
> +
> +	kfree(nvram_efivar);
> +	*data_len_ret = data_len;
> +	return data;
> +
> +fail:
> +	kfree(data);
> +	kfree(nvram_efivar);
> +	return NULL;
> +}
> +#else
> +static u8 *brcmf_fw_nvram_from_efi(size_t *data_len) { return NULL; }
> +#endif
> +
>   static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
>   {
>   	struct brcmf_fw *fwctx = ctx;
> @@ -462,6 +525,8 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
>   		raw_nvram = false;
>   	} else {
>   		data = bcm47xx_nvram_get_contents(&data_len);
> +		if (!data)
> +			data = brcmf_fw_nvram_from_efi(&data_len);
>   		if (!data && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
>   			goto fail;
>   		raw_nvram = true;
> @@ -472,7 +537,8 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
>   					     fwctx->domain_nr, fwctx->bus_nr);
>
>   	if (raw_nvram)
> -		bcm47xx_nvram_release_contents(data);
> +		kvfree(data); /* vfree for bcm47xx case / kfree for efi case */

While this clearly works I can not say I like this. If you want to do it 
this way, please submit a patch to remove 
bcm47xx_nvram_release_contents() as it is no longer needed since we now 
have kvfree(). From maintainance perspective also drop the postfix 
comment. We just might end up doing vmalloc in efi case at some point 
and this would likely be forgotten.

Regards,
Arend
