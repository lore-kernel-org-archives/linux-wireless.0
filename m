Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:38152 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbcC3KJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 06:09:30 -0400
Received: by mail-ig0-f169.google.com with SMTP id ui10so27559015igc.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2016 03:09:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459332504-1718-1-git-send-email-wnhuang@chromium.org>
References: <1459332504-1718-1-git-send-email-wnhuang@chromium.org>
Date: Wed, 30 Mar 2016 18:09:29 +0800
Message-ID: <CABicQ-XsOxKT=8rk-=NuwKKOF4a4x6diGi2cTYNEcg=WxTE9WQ@mail.gmail.com> (sfid-20160330_120933_289004_BC5C6E5D)
Subject: Re: [PATCH] CHROMIUM: mwifiex: fix NULL pointer dereference error
From: Wei-Ning Huang <wnhuang@google.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Daniel Kurtz <djkurtz@chromium.org>, snanda@chromium.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Wei-Ning Huang <wnhuang@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, please ignore this one. I forgot to strip the CHROMIUM: tag.

Wei-Ning

On Wed, Mar 30, 2016 at 6:08 PM, Wei-Ning Huang <wnhuang@chromium.org> wrote:
> In mwifiex_enable_hs, we need to check if
> priv->wdev.wiphy->wowlan_config is NULL before accessing it's member.
> This sometimes cause kernel panic when suspend/resume.
>
> Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>
> ---
>  drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
> index d5c56eb..d8de432 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
> @@ -509,7 +509,8 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
>
>         if (priv && priv->sched_scanning) {
>  #ifdef CONFIG_PM
> -               if (!priv->wdev.wiphy->wowlan_config->nd_config) {
> +               if (priv->wdev.wiphy->wowlan_config &&
> +                   !priv->wdev.wiphy->wowlan_config->nd_config) {
>  #endif
>                         mwifiex_dbg(adapter, CMD, "aborting bgscan!\n");
>                         mwifiex_stop_bg_scan(priv);
> --
> 2.1.2
>



-- 
Wei-Ning Huang, 黃偉寧 | Software Engineer, Google Inc., Taiwan |
wnhuang@google.com | Cell: +886 910-380678
