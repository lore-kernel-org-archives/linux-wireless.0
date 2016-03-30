Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:34435 "EHLO
	mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbcC3K0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 06:26:38 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1459332895-4563-1-git-send-email-wnhuang@chromium.org>
References: <1459332895-4563-1-git-send-email-wnhuang@chromium.org>
Date: Wed, 30 Mar 2016 12:26:37 +0200
Message-ID: <CA+icZUVpMU0kjEKPpABU415Gv_EhFUkAGbXi82UVf8PbHnz9mw@mail.gmail.com> (sfid-20160330_122658_951327_3AC9DCA6)
Subject: Re: [PATCH RESEND] mwifiex: fix NULL pointer dereference error
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Wei-Ning Huang <wnhuang@chromium.org>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, djkurtz@chromium.org,
	snanda@chromium.org, akarwar@marvell.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 30, 2016 at 12:14 PM, Wei-Ning Huang <wnhuang@chromium.org> wrote:
> In mwifiex_enable_hs, we need to check if
> priv->wdev.wiphy->wowlan_config is NULL before accessing it's member.

it's... its member (not it's) :-).

- Sedat -

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
