Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60079 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1IAUKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 16:10:01 -0400
Received: by pzk37 with SMTP id 37so3467837pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Sep 2011 13:10:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314905534-24190-1-git-send-email-thomas@cozybit.com>
References: <1314905534-24190-1-git-send-email-thomas@cozybit.com>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 1 Sep 2011 13:09:41 -0700
Message-ID: <CAPjQAd-GWdJawo4wFQXD_Lpfzcq7_DxG0zS+bgTtZ433-m6cnA@mail.gmail.com> (sfid-20110901_221009_156990_69056AEC)
Subject: Re: [PATCH] mac80211: check if mesh frame is in RMC after decrypt
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 1, 2011 at 12:32 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
> To check whether a frame is in the RMC, we need access to the mesh
> header.  This header is encrypted in encrypted data frames, so make this
> check after the frame has been decrypted.
>
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>

> ---
>  net/mac80211/rx.c |   15 ++++++---------
>  1 files changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 1fe26fa..9410b9f 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -476,7 +476,6 @@ static ieee80211_rx_result
>  ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
>  {
>        struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
> -       unsigned int hdrlen = ieee80211_hdrlen(hdr->frame_control);
>        char *dev_addr = rx->sdata->vif.addr;
>
>        if (ieee80211_is_data(hdr->frame_control)) {
> @@ -524,14 +523,6 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
>
>        }
>
> -#define msh_h_get(h, l) ((struct ieee80211s_hdr *) ((u8 *)h + l))
> -
> -       if (ieee80211_is_data(hdr->frame_control) &&
> -           is_multicast_ether_addr(hdr->addr1) &&
> -           mesh_rmc_check(hdr->addr3, msh_h_get(hdr, hdrlen), rx->sdata))
> -               return RX_DROP_MONITOR;
> -#undef msh_h_get
> -
>        return RX_CONTINUE;
>  }
>
> @@ -1827,6 +1818,12 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
>        hdrlen = ieee80211_hdrlen(hdr->frame_control);
>        mesh_hdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
>
> +       /* frame is in RMC, don't forward */
> +       if (ieee80211_is_data(hdr->frame_control) &&
> +           is_multicast_ether_addr(hdr->addr1) &&
> +           mesh_rmc_check(hdr->addr3, mesh_hdr, rx->sdata))
> +               return RX_DROP_MONITOR;
> +
>        if (!ieee80211_is_data(hdr->frame_control))
>                return RX_CONTINUE;
>
> --
> 1.7.4.1
>
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
