Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:14997 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbbFAL7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 07:59:13 -0400
Message-ID: <556C490E.90509@broadcom.com> (sfid-20150601_135920_189412_A19A57E8)
Date: Mon, 1 Jun 2015 13:59:10 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	<brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH] brcmfmac: support NVRAMs containing pci devpaths (instead
 of pcie)
References: <1432815561-6639-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1432815561-6639-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/28/15 14:19, Rafał Miłecki wrote:
> Recently Broadcom added support for NVRAMs with entries for multiple
> PCIe devices. One of the supported formats is based on prefixes defined
> like: devpath0=pcie/1/4/ and entries like 0:foo=bar 0:baz=qux etc.
>
> Unfortunately there are also a bit older devices using different way of
> defining prefixes, e.g. SmartRG SR400ac (2 x BCM43602) with entries:
> devpath0=pci/1/1/
> devpath1=pci/2/1
> Broadcom stated this old format will never be used/supported by brcmfmac
> but given the simplicity of this patch I'll insist on supporting it.

Well, if you insist :-p

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
> index b72df87..743f16b 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
> @@ -232,6 +232,8 @@ static void brcmf_fw_strip_multi_v1(struct nvram_parser *nvp, u16 domain_nr,
>   				    u16 bus_nr)
>   {
>   	/* Device path with a leading '=' key-value separator */
> +	char pci_path[] = "=pci/?/?";
> +	size_t pci_len;
>   	char pcie_path[] = "=pcie/?/?";
>   	size_t pcie_len;
>
> @@ -251,6 +253,9 @@ static void brcmf_fw_strip_multi_v1(struct nvram_parser *nvp, u16 domain_nr,
>   	/* First search for the devpathX and see if it is the configuration
>   	 * for domain_nr/bus_nr. Search complete nvp
>   	 */
> +	snprintf(pci_path, sizeof(pci_path), "=pci/%d/%d", domain_nr,
> +		 bus_nr);
> +	pci_len = strlen(pci_path);
>   	snprintf(pcie_path, sizeof(pcie_path), "=pcie/%d/%d", domain_nr,
>   		 bus_nr);
>   	pcie_len = strlen(pcie_path);
> @@ -260,8 +265,9 @@ static void brcmf_fw_strip_multi_v1(struct nvram_parser *nvp, u16 domain_nr,
>   		/* Format: devpathX=pcie/Y/Z/
>   		 * Y = domain_nr, Z = bus_nr, X = virtual ID
>   		 */
> -		if ((strncmp(&nvp->nvram[i], "devpath", 7) == 0)&&
> -		    (strncmp(&nvp->nvram[i + 8], pcie_path, pcie_len) == 0)) {
> +		if (strncmp(&nvp->nvram[i], "devpath", 7) == 0&&
> +		    (!strncmp(&nvp->nvram[i + 8], pci_path, pci_len) ||
> +		     !strncmp(&nvp->nvram[i + 8], pcie_path, pcie_len))) {
>   			id = nvp->nvram[i + 7] - '0';
>   			found = true;
>   			break;

