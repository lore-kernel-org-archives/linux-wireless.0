Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65263 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab2KSNgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 08:36:32 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so4798768obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 05:36:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353322865-7500-1-git-send-email-arend@broadcom.com>
References: <1353322865-7500-1-git-send-email-arend@broadcom.com>
Date: Mon, 19 Nov 2012 15:36:31 +0200
Message-ID: <CAB3XZEcv9kV1TG_CfeK7TeNu+kdhb9TcfsFff9jn7aVLCcz+YA@mail.gmail.com> (sfid-20121119_143635_477436_8F9F72D9)
Subject: Re: [PATCH] mac80211: check add_chanctx callback before use in ieee80211_reconfig
From: Eliad Peller <eliad@wizery.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Arend,

On Mon, Nov 19, 2012 at 1:01 PM, Arend van Spriel <arend@broadcom.com> wrote:
> During testing our mac80211 driver a fatal error occurred which was
> signalled to mac80211. Upon performing the reconfiguration of the
> device a WARN_ON was triggered. This warning checked the return value
> of drv_add_chanctx(). However, this returns -EOPNOTSUPP when the
> driver does not provide the callback. As the callback is optional
> better check it is defined before calling drv_add_chanctx().
>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---

> +       if (local->ops->add_chanctx) {
> +               mutex_lock(&local->chanctx_mtx);
> +               list_for_each_entry(ctx, &local->chanctx_list, list)
> +                       WARN_ON(drv_add_chanctx(local, ctx));
> +               mutex_unlock(&local->chanctx_mtx);
> +       }

i think checking local->use_chanctx is a bit cleaner.

Eliad.
