Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f177.google.com ([209.85.222.177]:38649 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbZJGBBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 21:01:51 -0400
Received: by pzk7 with SMTP id 7so4378684pzk.33
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2009 18:01:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1254873770-31241-1-git-send-email-bzhao@marvell.com>
References: <1254873770-31241-1-git-send-email-bzhao@marvell.com>
Date: Tue, 6 Oct 2009 18:01:14 -0700
Message-ID: <45e8e6c40910061801u2b67abb5v4658a7bbf1e0726a@mail.gmail.com>
Subject: Re: [PATCH] libertas: Use lbs_is_cmd_allowed() check in command
	handling routines.
From: Andrey Yurovsky <andrey@cozybit.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: libertas-dev@lists.infradead.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

On Tue, Oct 6, 2009 at 5:02 PM, Bing Zhao <bzhao@marvell.com> wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> +static int lbs_is_cmd_allowed(struct lbs_private *priv)
> +{
> +       int         ret = 1;
> +
> +       lbs_deb_enter(LBS_DEB_CMD);
> +
> +       if (!priv->is_auto_deep_sleep_enabled) {
> +               if (priv->is_deep_sleep) {
> +                       lbs_deb_cmd("IOCTLS called when station"
> +                                       " is in deep sleep\n");
> +                       ret = 0;
> +               }
> +       }

Can this debug message be something like "command not allowed in deep
sleep" instead of mentioning IOCTLS?

  -Andrey
