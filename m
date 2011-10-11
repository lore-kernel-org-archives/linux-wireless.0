Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46381 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1JKKQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 06:16:25 -0400
Received: by eye27 with SMTP id 27so2348301eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 03:16:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318326555-13905-1-git-send-email-eliad@wizery.com>
References: <1318326555-13905-1-git-send-email-eliad@wizery.com>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Tue, 11 Oct 2011 12:16:09 +0200
Message-ID: <CA+XVXfdM7=G1YdWVYpzfKajRYu+sAJcfKSFkbtgneUPTPabQ=w@mail.gmail.com> (sfid-20111011_121628_597213_4B8144F9)
Subject: Re: [PATCH v2 08/29] wl12xx: configure sleep_policy according to
 active roles
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 11, 2011 at 11:49, Eliad Peller <eliad@wizery.com> wrote:
> If there is an active AP role, stay always on.
> Otherwise, allow chip to enter elp.
>
> (Note that this is a global configuration, so if the
> device is already configured according to our policy,
> we don't have to configure it again)
>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
> v2: use ap_count/sta_count instead of iterating
> +       if (!wl->ap_count) {
> +               if (is_ap) {
> +                       /* Configure for power always on */
> +                       ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
> +                       if (ret < 0)
> +                               return ret;
> +               } else if (!wl->sta_count) {
> +                       /* Configure for ELP power saving */
> +                       ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
> +                       if (ret < 0)
> +                               return ret;
> +               }
> +       }

Probably need to add a symmetric part on remove_interface(). If ap was
shutdown we can return to normal ELP.

btw, elp_work() still gets called even in AP-mode. I'm guessing it has
no effect, but if you want to prevent the SDIO transaction from taking
place (like you said on IRC), you can check for it :)
(Just nitpicking here)
