Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54774 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab0BQTNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 14:13:12 -0500
Received: by ewy19 with SMTP id 19so5970647ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 11:13:10 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <c2673ca61002171104xddb6275t6d9e69878a8c5f82@mail.gmail.com>
References: <c2673ca61002171015j375922c0y4c7f61c3d3322bab@mail.gmail.com>
	 <4B7C35C9.30607@lwfinger.net>
	 <c2673ca61002171034q18edf1c2o817ac4e1ff367177@mail.gmail.com>
	 <1266431764.15836.8.camel@jlt3.sipsolutions.net>
	 <c2673ca61002171038u14c7ab2fnf2d3ce2067bd1fd8@mail.gmail.com>
	 <1266433138.9050.27.camel@mj>
	 <c2673ca61002171104xddb6275t6d9e69878a8c5f82@mail.gmail.com>
Date: Wed, 17 Feb 2010 20:13:10 +0100
Message-ID: <2d0a357f1002171113n7ceb8fbdr2f54c17699151949@mail.gmail.com>
Subject: Re: [PATCH] v2: rtl8187: micro cleanup
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: okias <d.okias@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	herton@mandriva.com.br, htl10@users.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You could be more precise on the commit-subject (not blaming you) next time.
Worth reading on this topic: "On Commit Messages" [1].

- Sedat -

[1] http://who-t.blogspot.com/2009/12/on-commit-messages.html

On Wed, Feb 17, 2010 at 8:04 PM, okias <d.okias@gmail.com> wrote:
> ok, sorry I tested it on x86_64. Here is correct patch:
>
> From c4dd3d87e090dd0b44dc030840f2ae1fd0bff729 Mon Sep 17 00:00:00 2001
> From: David Heidelberger <d.okias@gmail.com>
> Date: Wed, 17 Feb 2010 19:41:15 +0100
> Subject: [PATCH] rtl8187: micro cleanup v3
>
> ---
>  drivers/net/wireless/rtl818x/rtl8187_dev.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> index 7ba3052..2cc6881 100644
> --- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -1165,7 +1165,7 @@ static void rtl8187_bss_info_changed(struct
> ieee80211_hw *dev,
>  {
>        struct rtl8187_priv *priv = dev->priv;
>        int i;
> -       u8 reg;
> +       u8 reg = 0;
>
>        if (changed & BSS_CHANGED_BSSID) {
>                mutex_lock(&priv->conf_mutex);
> @@ -1175,8 +1175,6 @@ static void rtl8187_bss_info_changed(struct
> ieee80211_hw *dev,
>
>                if (priv->is_rtl8187b)
>                        reg = RTL818X_MSR_ENEDCA;
> -               else
> -                       reg = 0;
>
>                if (is_valid_ether_addr(info->bssid)) {
>                        reg |= RTL818X_MSR_INFRA;
> --
> 1.7.0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
