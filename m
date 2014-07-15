Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:50540 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbaGOEil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 00:38:41 -0400
Received: by mail-oa0-f41.google.com with SMTP id j17so2542801oag.28
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2014 21:38:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405396414-19493-1-git-send-email-bzhao@marvell.com>
References: <1405396414-19493-1-git-send-email-bzhao@marvell.com>
Date: Mon, 14 Jul 2014 21:38:40 -0700
Message-ID: <CAMcMvsh6-WiJd9MTnwqbPmyD1o0QOCqCBw1eBUX14rQ3QsJxsw@mail.gmail.com> (sfid-20140715_063844_485867_46FDC2CB)
Subject: Re: [PATCH 4/7 v2] mwifiex: remove redundant TDLS setup action frame
 check and avoid leaks
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

On Mon, Jul 14, 2014 at 8:53 PM, Bing Zhao <bzhao@marvell.com> wrote:
> The unwanted frame types are already handled in 'default' case
> of the switch/case below.
> The str_ptr is allocated but it can be leaked if the length check
> fails in the REQUEST/RESP cases. Fix it by allocating sta_ptr
> after the length checks.
>
> Reported-by: Paul Stewart <pstew@chromium.org>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Paul Stewart <pstew@chromium.org>
> ---
> v2: fix possible leak of sta_ptr
>
>  drivers/net/wireless/mwifiex/tdls.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
> index a414161..4c5fd95 100644
> --- a/drivers/net/wireless/mwifiex/tdls.c
> +++ b/drivers/net/wireless/mwifiex/tdls.c
> @@ -781,6 +781,7 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
>         struct mwifiex_sta_node *sta_ptr;
>         u8 *peer, *pos, *end;
>         u8 i, action, basic;
> +       __le16 cap = 0;
>         int ie_len = 0;
>
>         if (len < (sizeof(struct ethhdr) + 3))
> @@ -792,18 +793,9 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
>
>         peer = buf + ETH_ALEN;
>         action = *(buf + sizeof(struct ethhdr) + 2);
> -
> -       /* just handle TDLS setup request/response/confirm */
> -       if (action > WLAN_TDLS_SETUP_CONFIRM)
> -               return;
> -
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
> @@ -811,7 +803,7 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
>
>                 pos = buf + sizeof(struct ethhdr) + 4;
>                 /* payload 1+ category 1 + action 1 + dialog 1 */
> -               sta_ptr->tdls_cap.capab = cpu_to_le16(*(u16 *)pos);
> +               cap = cpu_to_le16(*(u16 *)pos);
>                 ie_len = len - sizeof(struct ethhdr) - TDLS_REQ_FIX_LEN;
>                 pos += 2;
>                 break;
> @@ -821,7 +813,7 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
>                         return;
>                 /* payload 1+ category 1 + action 1 + dialog 1 + status code 2*/
>                 pos = buf + sizeof(struct ethhdr) + 6;
> -               sta_ptr->tdls_cap.capab = cpu_to_le16(*(u16 *)pos);
> +               cap = cpu_to_le16(*(u16 *)pos);
>                 ie_len = len - sizeof(struct ethhdr) - TDLS_RESP_FIX_LEN;
>                 pos += 2;
>                 break;
> @@ -833,10 +825,16 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
>                 ie_len = len - sizeof(struct ethhdr) - TDLS_CONFIRM_FIX_LEN;
>                 break;
>         default:
> -               dev_warn(priv->adapter->dev, "Unknown TDLS frame type.\n");
> +               dev_dbg(priv->adapter->dev, "Unknown TDLS frame type.\n");
>                 return;
>         }
>
> +       sta_ptr = mwifiex_add_sta_entry(priv, peer);
> +       if (!sta_ptr)
> +               return;
> +
> +       sta_ptr->tdls_cap.capab = cap;
> +
>         for (end = pos + ie_len; pos + 1 < end; pos += 2 + pos[1]) {
>                 if (pos + 2 + pos[1] > end)
>                         break;
> --
> 1.8.2.3
>
