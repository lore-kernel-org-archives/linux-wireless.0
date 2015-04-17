Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:35208 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbbDQHzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 03:55:39 -0400
Received: by igbyr2 with SMTP id yr2so5607195igb.0
        for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2015 00:55:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429035033-14076-11-git-send-email-arend@broadcom.com>
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
	<1429035033-14076-11-git-send-email-arend@broadcom.com>
Date: Fri, 17 Apr 2015 09:55:38 +0200
Message-ID: <CACna6rzwtotNFQ7V+jpbfLoZ-hS7M=MYzc7bTjJ6SC6WuODmyQ@mail.gmail.com> (sfid-20150417_095542_816391_57603630)
Subject: Re: [PATCH 10/10] brcmfmac: Add support for multiple PCIE devices in nvram.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 April 2015 at 20:10, Arend van Spriel <arend@broadcom.com> wrote:
> @@ -23,6 +23,10 @@
>  #include "debug.h"
>  #include "firmware.h"
>
> +#define BRCMF_FW_MAX_NVRAM_SIZE                        64000
> +#define BRCMF_FW_NVRAM_DEVPATH_LEN             19      /* devpath0=pcie/1/4/ */
> +#define BRCMF_FW_NVRAM_PCIEDEV_LEN             9       /* pcie/1/4/ */

You most likely know what you're doing, but just for sure: are there
any devices using "pcie/" prefix *without* a devpath? I got an
impression that Broadcom first started using devpath-s and then
(later) started using "pcie/" prefix (instead of "pci/").


> @@ -192,12 +214,136 @@ static int brcmf_init_nvram_parser(struct nvram_parser *nvp,
>         return 0;
>  }
>
> +/* brcmf_fw_strip_multi_v1 :Some nvram files contain settings for multiple
> + * devices. Strip it down for one device, use domain_nr/bus_nr to determine
> + * which data is to be returned. v1 is the version where nvram is stored
> + * compressed and "devpath" maps to index for valid entries.
> + */
> +static void brcmf_fw_strip_multi_v1(struct nvram_parser *nvp, u16 domain_nr,
> +                                   u16 bus_nr)
> +{
> +       u32 i, j;
> +       bool found;
> +       u8 *nvram;
> +       u8 id;
> +
> +       nvram = kzalloc(nvp->nvram_len + 1 + 3 + sizeof(u32), GFP_KERNEL);
> +       if (!nvram)
> +               goto fail;
> +
> +       /* min length: devpath0=pcie/1/4/ + 0:x=y */
> +       if (nvp->nvram_len < BRCMF_FW_NVRAM_DEVPATH_LEN + 6)
> +               goto fail;
> +
> +       /* First search for the devpathX and see if it is the configuration
> +        * for domain_nr/bus_nr. Search complete nvp
> +        */
> +       found = false;
> +       i = 0;
> +       while (i < nvp->nvram_len - BRCMF_FW_NVRAM_DEVPATH_LEN) {
> +               /* Format: devpathX=pcie/Y/Z/
> +                * Y = domain_nr, Z = bus_nr, X = virtual ID
> +                */
> +               if ((strncmp(&nvp->nvram[i], "devpath", 7) == 0) &&
> +                   (strncmp(&nvp->nvram[i + 8], "=pcie/", 6) == 0)) {
> +                       if (((nvp->nvram[i + 14] - '0') == domain_nr) &&
> +                           ((nvp->nvram[i + 16] - '0') == bus_nr)) {
> +                               id = nvp->nvram[i + 7] - '0';
> +                               found = true;
> +                               break;
> +                       }
> +               }
> +               while (nvp->nvram[i] != 0)
> +                       i++;

I guess while should also check nvp->nvram_len to avoid crashing with
malformed NVRAM content. Same in _v2 function.


> +               i++;
> +       }
> +       if (!found)
> +               goto fail;
> +
> +       /* Now copy all valid entries, release old nvram and assign new one */
> +       i = 0;
> +       j = 0;
> +       while (i < nvp->nvram_len) {
> +               if ((nvp->nvram[i] - '0' == id) && (nvp->nvram[i + 1] == ':')) {
> +                       i += 2;
> +                       while (nvp->nvram[i] != 0) {
> +                               nvram[j] = nvp->nvram[i];
> +                               i++;
> +                               j++;
> +                       }
> +                       nvram[j] = 0;
> +                       j++;
> +               }
> +               while (nvp->nvram[i] != 0)
> +                       i++;

Same here.


> +/* brcmf_fw_strip_multi_v2 :Some nvram files contain settings for multiple
> + * devices. Strip it down for one device, use domain_nr/bus_nr to determine
> + * which data is to be returned. v2 is the version where nvram is stored
> + * uncompressed, all relevant valid entries are identified by
> + * pcie/domain_nr/bus_nr:
> + */
> +static void brcmf_fw_strip_multi_v2(struct nvram_parser *nvp, u16 domain_nr,
> +                                   u16 bus_nr)
> +{
> +       u32 i, j;
> +       u8 *nvram;
> +
> +       nvram = kzalloc(nvp->nvram_len + 1 + 3 + sizeof(u32), GFP_KERNEL);
> +       if (!nvram)
> +               goto fail;
> +
> +       /* Copy all valid entries, release old nvram and assign new one.
> +        * Valid entries are of type pcie/X/Y/ where X = domain_nr and
> +        * Y = bus_nr.
> +        */
> +       i = 0;
> +       j = 0;
> +       while (i < nvp->nvram_len - BRCMF_FW_NVRAM_PCIEDEV_LEN) {
> +               if ((strncmp(&nvp->nvram[i], "pcie/", 5) == 0) &&
> +                   (nvp->nvram[i + 6] == '/') && (nvp->nvram[i + 8] == '/') &&
> +                   ((nvp->nvram[i + 5] - '0') == domain_nr) &&
> +                   ((nvp->nvram[i + 7] - '0') == bus_nr)) {
> +                       i += BRCMF_FW_NVRAM_PCIEDEV_LEN;
> +                       while (nvp->nvram[i] != 0) {
> +                               nvram[j] = nvp->nvram[i];
> +                               i++;
> +                               j++;
> +                       }
> +                       nvram[j] = 0;
> +                       j++;
> +               }
> +               while (nvp->nvram[i] != 0)
> +                       i++;
> +               i++;
> +       }
> +       kfree(nvp->nvram);
> +       nvp->nvram = nvram;
> +       nvp->nvram_len = j;
> +       return;
> +fail:
> +       kfree(nvram);
> +       nvp->nvram_len = 0;
> +}

I guess you could consider implementing a one generic function that
will accept sth like a "char *prefix" argument. First check for a
devpathX=$prefix entry and use X: instead of prefix: or not.
