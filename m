Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:32234 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbbETImO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 04:42:14 -0400
Message-ID: <555C48E2.3050300@broadcom.com> (sfid-20150520_104220_984184_D40F24DB)
Date: Wed, 20 May 2015 10:42:10 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	<brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH] brcmfmac: simplify check stripping v2 NVRAM
References: <1432107261-7350-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1432107261-7350-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/20/15 09:34, Rafał Miłecki wrote:
> Comparing NVRAM entry with a full filtering string is simpler than
> comparing it with a short prefix and then checking random chars at magic
> offsets. The cost of snprintf relatively low, we execute it just once.
> Tested on BCM43602 with NVRAM hacked to use V2 format.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 15 ++++++++-------
>   1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
> index 8ff31ff..181a0e8 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
> @@ -25,7 +25,7 @@
>
>   #define BRCMF_FW_MAX_NVRAM_SIZE			64000
>   #define BRCMF_FW_NVRAM_DEVPATH_LEN		19	/* devpath0=pcie/1/4/ */
> -#define BRCMF_FW_NVRAM_PCIEDEV_LEN		9	/* pcie/1/4/ */
> +#define BRCMF_FW_NVRAM_PCIEDEV_LEN		10	/* pcie/1/4/ + \0 */
>
>   char brcmf_firmware_path[BRCMF_FW_PATH_LEN];
>   module_param_string(firmware_path, brcmf_firmware_path,
> @@ -297,6 +297,8 @@ fail:
>   static void brcmf_fw_strip_multi_v2(struct nvram_parser *nvp, u16 domain_nr,
>   				    u16 bus_nr)
>   {
> +	char prefix[BRCMF_FW_NVRAM_PCIEDEV_LEN];
> +	size_t len;
>   	u32 i, j;
>   	u8 *nvram;
>
> @@ -308,14 +310,13 @@ static void brcmf_fw_strip_multi_v2(struct nvram_parser *nvp, u16 domain_nr,
>   	 * Valid entries are of type pcie/X/Y/ where X = domain_nr and
>   	 * Y = bus_nr.
>   	 */
> +	snprintf(prefix, sizeof(prefix), "pcie/%d/%d/", domain_nr, bus_nr);
> +	len = strlen(prefix);
>   	i = 0;
>   	j = 0;
> -	while (i<  nvp->nvram_len - BRCMF_FW_NVRAM_PCIEDEV_LEN) {
> -		if ((strncmp(&nvp->nvram[i], "pcie/", 5) == 0)&&
> -		    (nvp->nvram[i + 6] == '/')&&  (nvp->nvram[i + 8] == '/')&&
> -		    ((nvp->nvram[i + 5] - '0') == domain_nr)&&
> -		    ((nvp->nvram[i + 7] - '0') == bus_nr)) {
> -			i += BRCMF_FW_NVRAM_PCIEDEV_LEN;
> +	while (i<  nvp->nvram_len - len) {
> +		if (strncmp(&nvp->nvram[i], prefix, len) == 0) {
> +			i += len;
>   			while (nvp->nvram[i] != 0) {
>   				nvram[j] = nvp->nvram[i];
>   				i++;

