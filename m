Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51043 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab2JPOsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 10:48:15 -0400
Received: by mail-vb0-f46.google.com with SMTP id ff1so6598954vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2012 07:48:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121016123409.GA2274@redhat.com>
References: <20121016123409.GA2274@redhat.com>
Date: Tue, 16 Oct 2012 16:48:14 +0200
Message-ID: <CAL1gcdPQTqwMTSNXQFzDhjDE0+1=jtWwGM8zQZ9MzT84yMxF-w@mail.gmail.com> (sfid-20121016_164822_829274_D27EE0F8)
Subject: Re: [PATCH] rt2x00: usb: fix reset resume
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	David Herrmann <dh.herrmann@googlemail.com>,
	Stephen Boyd <bebarino@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 16, 2012 at 2:34 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Patch fixes warnings like below happened on resume:
>
> WARNING: at net/mac80211/driver-ops.h:12 check_sdata_in_driver+0x32/0x34()
>
> Problem is that in __ieee80211_susped() we remove sdata (i.e wlan0
> interface) and then during resume we call usb_unbind_interface() ->
> ieee80211_unregister_hw() with sdata removed.
>
> Patch fixes problem by adding .reset_resume calback, hence we do not
> unbind usb device on resume. This callback can be the same as normal
> .resume callback, sice we do all needed initalization during interface
> start, which is performed on resume [ ieee80211_resume() ->
> ieee80211_reconfig() -> rt2x00mac_start() -> rt2x00lib_start ].
>
> Resolves:
> https://bugzilla.kernel.org/show_bug.cgi?id=48041
>
> Reported-by: David Herrmann <dh.herrmann@googlemail.com>
> Reported-and-tested-by: Stephen Boyd <bebarino@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2500usb.c |    1 +
>  drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
>  drivers/net/wireless/rt2x00/rt73usb.c   |    1 +
>  3 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index a12e84f..6b2e1e4 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -1988,6 +1988,7 @@ static struct usb_driver rt2500usb_driver = {
>         .disconnect     = rt2x00usb_disconnect,
>         .suspend        = rt2x00usb_suspend,
>         .resume         = rt2x00usb_resume,
> +       .reset_resume   = rt2x00usb_resume,
>         .disable_hub_initiated_lpm = 1,
>  };
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index c9e9370..3b8fb5a 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -1282,6 +1282,7 @@ static struct usb_driver rt2800usb_driver = {
>         .disconnect     = rt2x00usb_disconnect,
>         .suspend        = rt2x00usb_suspend,
>         .resume         = rt2x00usb_resume,
> +       .reset_resume   = rt2x00usb_resume,
>         .disable_hub_initiated_lpm = 1,
>  };
>
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index e5eb43b..24eec66 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2535,6 +2535,7 @@ static struct usb_driver rt73usb_driver = {
>         .disconnect     = rt2x00usb_disconnect,
>         .suspend        = rt2x00usb_suspend,
>         .resume         = rt2x00usb_resume,
> +       .reset_resume   = rt2x00usb_resume,
>         .disable_hub_initiated_lpm = 1,
>  };
>
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
---
Gertjan
