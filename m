Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35476 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbbETMbj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 08:31:39 -0400
Received: by iesa3 with SMTP id a3so37728561ies.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2015 05:31:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432122655-3224-1-git-send-email-arend@broadcom.com>
References: <1432122655-3224-1-git-send-email-arend@broadcom.com>
Date: Wed, 20 May 2015 14:31:37 +0200
Message-ID: <CACna6rxeU0FUiTRNXFgK-xxSDY8WA82h7MLmcPc=7eM5sqMdBw@mail.gmail.com> (sfid-20150520_143154_326033_37885270)
Subject: Re: [PATCH RESEND] mips: bcm47xx: allow retrieval of complete nvram contents
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 May 2015 at 13:50, Arend van Spriel <arend@broadcom.com> wrote:
> From: Hante Meuleman <meuleman@broadcom.com>
>
> Host platforms such as routers supported by OpenWRT can
> support NVRAM reading directly from internal NVRAM store.
> The brcmfmac for one requires the complete nvram contents
> to select what needs to be sent to wireless device.

First of all, I have to ask you to rebase this patch on top of
upstream-sfr. Mostly because of
MIPS: BCM47XX: Make sure NVRAM buffer ends with \0


> @@ -146,20 +147,21 @@ static int nvram_init(void)
>                 return -ENODEV;
>
>         err = mtd_read(mtd, 0, sizeof(header), &bytes_read, (uint8_t *)&header);
> -       if (!err && header.magic == NVRAM_MAGIC) {
> -               u8 *dst = (uint8_t *)nvram_buf;
> -               size_t len = header.len;
> -
> -               if (header.len > NVRAM_SPACE) {
> +       if (!err && header.magic == NVRAM_MAGIC &&
> +           header.len > sizeof(header)) {
> +               if (header.len > NVRAM_SPACE - 2) {
>                         pr_err("nvram on flash (%i bytes) is bigger than the reserved space in memory, will just copy the first %i bytes\n",
>                                 header.len, NVRAM_SPACE);
> -                       len = NVRAM_SPACE;
> +                       header.len = NVRAM_SPACE - 2;
>                 }

I guess I preferred having "len" helper, but it's a minor thing.
What's the trick with this NVRAM_SPACE - 2? Requiring string I to be
ended with double \0 sounds like a wrong design in some driver. I
don't think it's anything common/any standard to mark the buffer end
with an extra \0. I'm pretty sure bcm47xx_nvram_getenv doesn't need it
and bcm47xx_nvram_get_contents you implemented provides buffer length
anyway.
Moreover this trick isn't compatible with what nvram_find_and_copy does.


> -               err = mtd_read(mtd, 0, len, &bytes_read, dst);
> +               err = mtd_read(mtd, 0, header.len, &bytes_read,
> +                              (u8 *)nvram_buf);
>                 if (err)
>                         return err;
>
> +               pheader = (struct nvram_header *)nvram_buf;
> +               pheader->len = header.len;

I preferred your OpenWrt patch version with just keeping a buffer
content length in separated variable. It won't kill us to have one
more static size_t and we'll at least keep a real header copy without
hacking it for implementation needs.
Again, what you did here doesn't match nvram_find_and_copy, so please
make sure you'll e.g. set content length variable in
nvram_find_and_copy as well.

-- 
Rafał
