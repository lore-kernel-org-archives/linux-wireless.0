Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:33460 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbbGWKDP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 06:03:15 -0400
Received: from localhost (localhost [127.0.0.1])
	by arrakis.dune.hu (Postfix) with ESMTP id EB7B928BDBA
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2015 12:02:42 +0200 (CEST)
Received: from mail-qg0-f46.google.com (mail-qg0-f46.google.com [209.85.192.46])
	by arrakis.dune.hu (Postfix) with ESMTPSA id 43609283C2A
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2015 12:02:40 +0200 (CEST)
Received: by qgii95 with SMTP id i95so83918042qgi.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2015 03:03:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1437633104-23373-1-git-send-email-kvalo@codeaurora.org>
References: <1437633104-23373-1-git-send-email-kvalo@codeaurora.org>
From: Jonas Gorski <jogo@openwrt.org>
Date: Thu, 23 Jul 2015 12:02:47 +0200
Message-ID: <CAOiHx=k=p=0HJewHcVoKaypyrpbpyswes20jX6t3tha+OMf9aQ@mail.gmail.com> (sfid-20150723_120318_794748_855312CB)
Subject: Re: [PATCH] bcma: fix linking problem with of_default_bus_match_table
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Jul 23, 2015 at 8:31 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Stephen reported a build problem caused by commit cae761b5a6bd ("bcma: populate
> bus DT subnodes as platform_device-s"):
>
> ERROR: "of_default_bus_match_table" [drivers/bcma/bcma.ko] undefined!
>
> Rafał Miłecki suggested as a quick fix to use IS_BUILTIN() to workaround the
> issue. The downside is that this won't work when BCMA is compiled as a module,
> but we can live with that for now just to unblock the breakage.
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Fixes: cae761b5a6bd ("bcma: populate bus DT subnodes as platform_device-s")
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> ---
>  drivers/bcma/main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> index 59128478a90f..6b7d54622058 100644
> --- a/drivers/bcma/main.c
> +++ b/drivers/bcma/main.c
> @@ -410,7 +410,7 @@ int bcma_bus_register(struct bcma_bus *bus)
>                 bcma_core_pci_early_init(&bus->drv_pci[0]);
>         }
>
> -       if (bus->host_pdev) {
> +       if (IS_BUILTIN(CONFIG_BCMA) && bus->host_pdev) {
>                 struct device *dev = &bus->host_pdev->dev;
>
>                 of_platform_populate(dev->of_node, of_default_bus_match_table,

I think this isn't enough, AFAICT this needs IS_BUILTIN(CONFIG_BCMA)
&& IS_ENABLED(CONFIG_OF), else it will break with OF=n and BCMA=y, as
of_default_bus_match_table is only defined/built-in when OF=y.


Jonas
