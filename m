Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:60135 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaESMpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 08:45:06 -0400
Received: by mail-la0-f49.google.com with SMTP id pv20so3981206lab.22
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 05:45:04 -0700 (PDT)
Message-ID: <5379FCD0.2030506@cogentembedded.com> (sfid-20140519_144536_063552_DA933505)
Date: Mon, 19 May 2014 16:45:04 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>,
	"John W. Linville" <linville@tuxdriver.com>
CC: kernel-janitors@vger.kernel.org, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/13] libertas: make return of 0 explicit
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr> <1400473875-22228-2-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1400473875-22228-2-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 19-05-2014 8:31, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>

> Delete unnecessary local variable whose value is always 0 and that hides
> the fact that the result is always 0.

> A simplified version of the semantic patch that fixes this problem is as
> follows: (http://coccinelle.lip6.fr/)

> // <smpl>
> @r exists@
> local idexpression ret;
> expression e;
> position p;
> @@
>
> -ret = 0;
> ... when != ret = e
> return
> - ret
> + 0
>    ;
> // </smpl>

> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

> ---
> Alternatively, was an error code intended in the bad length case, as is
> done in process_brxed_802_11_packet?

>   drivers/net/wireless/libertas/rx.c |    7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)

> diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
> index c7366b0..807c5b8 100644
> --- a/drivers/net/wireless/libertas/rx.c
> +++ b/drivers/net/wireless/libertas/rx.c
[...]
> @@ -154,10 +152,9 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
>   	else
>   		netif_rx_ni(skb);
>
> -	ret = 0;
>   done:
> -	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", ret);
> -	return ret;
> +	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", 0);

    Why not just "ret 0"?

> +	return 0;

WBR, Sergei

