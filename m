Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:10469 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbYJNQA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 12:00:58 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1261264tic.23
        for <linux-wireless@vger.kernel.org>; Tue, 14 Oct 2008 09:00:56 -0700 (PDT)
Message-ID: <ea11fea30810140900n572c326r938fa88fdb5843d8@mail.gmail.com> (sfid-20081014_180110_274426_7112AA9F)
Date: Tue, 14 Oct 2008 21:30:56 +0530
From: "Manish Katiyar" <mkatiyar@gmail.com>
To: dcbw@redhat.com, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas : Remove unused variable warning "old_channel" from drivers/net/wireless/libertas/cmd.c
Cc: mkatiyar@gmail.com
In-Reply-To: <ea11fea30810130352i3cea0579g9950289254c8e628@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <ea11fea30810130352i3cea0579g9950289254c8e628@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 13, 2008 at 4:22 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> Below patch removes the following warning during compilation.
>
> drivers/net/wireless/libertas/cmd.c:826: warning: unused variable 'old_channel'

Any ack/nack on this ??

Thanks -
Manish

>
>
> Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>
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
>        struct cmd_ds_802_11_rf_channel cmd;
> +#ifdef DEBUG
>        u8 old_channel = priv->curbssparams.channel;
> +#endif
>        int ret = 0;
>
>        lbs_deb_enter(LBS_DEB_CMD);
> --
> 1.5.4.3
>
>
> Thanks -
> Manish
>
