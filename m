Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:56083 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaGLOBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 10:01:24 -0400
Received: by mail-oa0-f41.google.com with SMTP id l6so2459175oag.14
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2014 07:01:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405137435-14045-1-git-send-email-bzhao@marvell.com>
References: <1405137435-14045-1-git-send-email-bzhao@marvell.com>
Date: Sat, 12 Jul 2014 07:01:23 -0700
Message-ID: <CAMcMvshVx4zJkvPf2XgTPNUYNCqXKAm9wvi-iF1tJkODpyJ8bg@mail.gmail.com> (sfid-20140712_160127_915581_6D3D2FCC)
Subject: Re: [PATCH 4/7] mwifiex: remove redundant TDLS setup action frame check
From: Paul Stewart <pstew@chromium.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 11, 2014 at 8:57 PM, Bing Zhao <bzhao@marvell.com> wrote:
> It's already been taken cared by the 'default' case in the
> switch/case below.
>
> Reported-by: Paul Stewart <pstew@chromium.org>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/tdls.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
> index a414161..57f972d 100644
> --- a/drivers/net/wireless/mwifiex/tdls.c
> +++ b/drivers/net/wireless/mwifiex/tdls.c
> @@ -791,19 +791,15 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
>                 return;
>
>         peer = buf + ETH_ALEN;
> -       action = *(buf + sizeof(struct ethhdr) + 2);
>
> -       /* just handle TDLS setup request/response/confirm */
> -       if (action > WLAN_TDLS_SETUP_CONFIRM)
I'm going to assume that the intent of the original test was to avoid
allocation of sta_ptr below in the case where the action was invalid.
Is it okay to allocate this pointer and not do anything with it below?
> +       sta_ptr = mwifiex_add_sta_entry(priv, peer);
> +       if (!sta_ptr)
>                 return;
>
> +       action = *(buf + sizeof(struct ethhdr) + 2);
>         dev_dbg(priv->adapter->dev,
>                 "rx:tdls action: peer=%pM, action=%d\n", peer, action);
>
> -       sta_ptr = mwifiex_add_sta_entry(priv, peer);
> -       if (!sta_ptr)
> -               return;
> -
>         switch (action) {
>         case WLAN_TDLS_SETUP_REQUEST:
>                 if (len < (sizeof(struct ethhdr) + TDLS_REQ_FIX_LEN))
> --
> 1.8.2.3
>
