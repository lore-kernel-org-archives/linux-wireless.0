Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37265 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbbGKRJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2015 13:09:46 -0400
Received: by igpy18 with SMTP id y18so32620509igp.0
        for <linux-wireless@vger.kernel.org>; Sat, 11 Jul 2015 10:09:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1436553071-32423-2-git-send-email-arend@broadcom.com>
References: <1436553071-32423-1-git-send-email-arend@broadcom.com>
	<1436553071-32423-2-git-send-email-arend@broadcom.com>
Date: Sat, 11 Jul 2015 19:09:45 +0200
Message-ID: <CACna6ryt8iVUt18fODjDMiD-c3RLM22T2J_PM8NtEvBvWm8yBg@mail.gmail.com> (sfid-20150711_191059_466514_4B008A7D)
Subject: Re: [PATCH 1/7] brcmfmac: Add support for host platform NVRAM loading.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 July 2015 at 20:31, Arend van Spriel <arend@broadcom.com> wrote:
> @@ -146,7 +147,7 @@ brcmf_nvram_handle_value(struct nvram_parser *nvp)
>         u32 cplen;
>
>         c = nvp->data[nvp->pos];
> -       if (!is_nvram_char(c)) {
> +       if (!is_nvram_char(c) && (c != ' ')) {

This is redundant, please drop this change.
See fc23e81eb8f4 ("brcmfmac: allow NVRAM values to contain spaces")


> @@ -426,19 +428,34 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
>         struct brcmf_fw *fwctx = ctx;
>         u32 nvram_length = 0;
>         void *nvram = NULL;
> +       u8 *data = NULL;

This can be const.


> +       size_t data_len;
> +       bool raw_nvram;
>
>         brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(fwctx->dev));
> -       if (!fw && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
> -               goto fail;
> +       if ((fw) && (fw->data)) {

I think I was already pointing similar coding issue to you. There is
no need for these extra braces. And if they are not needed, don't use
them. There is no point in using if (((foo))) schema just because it
works. You could be confused by macros where we sometimes need tricks
like this, but this is a standard part of code.


> +               data = (u8 *)fw->data;

Don't cast to workaround const != const. You won't need casting after
making local "data" a const variable.


> +               data_len = fw->size;
> +               raw_nvram = false;
> +       } else {
> +               data = bcm47xx_nvram_get_contents(&data_len);
> +               if (!data && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
> +                       goto fail;
> +               raw_nvram = true;
> +       }
>
> -       if (fw) {
> -               nvram = brcmf_fw_nvram_strip(fw->data, fw->size, &nvram_length,
> +       if (data) {
> +               nvram = brcmf_fw_nvram_strip(data, data_len, &nvram_length,
>                                              fwctx->domain_nr, fwctx->bus_nr);
> -               release_firmware(fw);
> -               if (!nvram && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
> -                       goto fail;
> +               if (raw_nvram)
> +                       bcm47xx_nvram_release_contents(data);

This is cosmetical but maybe you could move above 2 lines next to the
release_firmware? So we have all freeing code at one please? Do you
think it would improve readability?
Nothing important thought. Feel free to ignore me here.


> @@ -473,15 +490,9 @@ static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
>         if (!ret)
>                 return;
>
> -       /* when nvram is optional call .done() callback here */
> -       if (fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL) {
> -               fwctx->done(fwctx->dev, fw, NULL, 0);
> -               kfree(fwctx);
> -               return;
> -       }
> +       brcmf_fw_request_nvram_done(NULL, fwctx);
> +       return;

It gave me a 5 minutes headache ;) Could you add a short comment why
you call _done anyway? Something like
/* Even if we failed to init user space fw request we may get a platform one */

-- 
Rafał
