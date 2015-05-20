Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:34975 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbbETPCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 11:02:07 -0400
Received: by iesa3 with SMTP id a3so41298235ies.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2015 08:02:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432123792-4155-7-git-send-email-arend@broadcom.com>
References: <1432123792-4155-1-git-send-email-arend@broadcom.com>
	<1432123792-4155-7-git-send-email-arend@broadcom.com>
Date: Wed, 20 May 2015 17:02:05 +0200
Message-ID: <CACna6rx_bBogPXZoa24JTqLED4GsGhezjVLZL_De=2uTqevsPA@mail.gmail.com> (sfid-20150520_170213_098371_35AB55AD)
Subject: Re: [PATCH 6/6] brcmfmac: Add support for host platform NVRAM loading.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 May 2015 at 14:09, Arend van Spriel <arend@broadcom.com> wrote:
> @@ -139,11 +165,11 @@ brcmf_nvram_handle_value(struct nvram_parser *nvp)
>         char *ekv;
>         u32 cplen;
>
> -       c = nvp->fwnv->data[nvp->pos];
> -       if (!is_nvram_char(c)) {
> +       c = nvp->data[nvp->pos];
> +       if (!is_nvram_char(c) && (c != ' ')) {

Don't smuggle behavior changes in patches doing something else!


> @@ -406,19 +434,34 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
>         struct brcmf_fw *fwctx = ctx;
>         u32 nvram_length = 0;
>         void *nvram = NULL;
> +       u8 *data = NULL;
> +       size_t data_len;
> +       bool raw_nvram;
>
>         brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(fwctx->dev));
> -       if (!fw && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
> -               goto fail;
> +       if ((fw) && (fw->data)) {

if (fw && fw->data)
will work just fine, I'm surprised checkpatch doesn't complain.
