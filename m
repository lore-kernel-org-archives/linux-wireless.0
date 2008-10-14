Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55318 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbYJNQh6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 12:37:58 -0400
Subject: Re: [PATCH] libertas : Remove unused variable warning
	"old_channel" from drivers/net/wireless/libertas/cmd.c
From: Dan Williams <dcbw@redhat.com>
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <ea11fea30810130352i3cea0579g9950289254c8e628@mail.gmail.com>
References: <ea11fea30810130352i3cea0579g9950289254c8e628@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 12:36:53 -0400
Message-Id: <1224002213.1799.2.camel@localhost.localdomain> (sfid-20081014_183801_910401_AD678851)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-13 at 16:22 +0530, Manish Katiyar wrote:
> Below patch removes the following warning during compilation.
> 
> drivers/net/wireless/libertas/cmd.c:826: warning: unused variable 'old_channel'
> 
> 
> Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/cmd.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cmd.c
> b/drivers/net/wireless/libertas/cmd.c
> index a912fb6..297696d 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -823,7 +823,9 @@ int lbs_update_channel(struct lbs_private *priv)
>  int lbs_set_channel(struct lbs_private *priv, u8 channel)
>  {
>  	struct cmd_ds_802_11_rf_channel cmd;
> +#ifdef DEBUG
>  	u8 old_channel = priv->curbssparams.channel;
> +#endif
>  	int ret = 0;
> 
>  	lbs_deb_enter(LBS_DEB_CMD);

