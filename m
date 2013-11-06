Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:38547 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3KFHie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 02:38:34 -0500
MIME-Version: 1.0
In-Reply-To: <20131105202101.GD3949@elgon.mountain>
References: <20131105202101.GD3949@elgon.mountain>
Date: Wed, 6 Nov 2013 07:38:33 +0000
Message-ID: <CAFSJ42ZDg+1Z0jFqf_jTPBL_Sw+mtMk0wMNQ6WMenzFo-1gWmg@mail.gmail.com> (sfid-20131106_083839_684703_29E9D6BA)
Subject: Re: [patch] wcn36xx: missing unlocks on error paths
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wcn36xx <wcn36xx@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks good to me, thanx!

On Tue, Nov 5, 2013 at 8:21 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> There are several places which are missing unlocks.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index f8c3a10..de9eb2c 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -1286,7 +1286,8 @@ int wcn36xx_smd_send_beacon(struct wcn36xx *wcn, struct ieee80211_vif *vif,
>         } else {
>                 wcn36xx_err("Beacon is to big: beacon size=%d\n",
>                               msg_body.beacon_length);
> -               return -ENOMEM;
> +               ret = -ENOMEM;
> +               goto out;
>         }
>         memcpy(msg_body.bssid, vif->addr, ETH_ALEN);
>
> @@ -1327,7 +1328,8 @@ int wcn36xx_smd_update_proberesp_tmpl(struct wcn36xx *wcn,
>         if (skb->len > BEACON_TEMPLATE_SIZE) {
>                 wcn36xx_warn("probe response template is too big: %d\n",
>                              skb->len);
> -               return -E2BIG;
> +               ret = -E2BIG;
> +               goto out;
>         }
>
>         msg.probe_resp_template_len = skb->len;
> @@ -1606,7 +1608,8 @@ int wcn36xx_smd_keep_alive_req(struct wcn36xx *wcn,
>                 /* TODO: it also support ARP response type */
>         } else {
>                 wcn36xx_warn("unknow keep alive packet type %d\n", packet_type);
> -               return -EINVAL;
> +               ret = -EINVAL;
> +               goto out;
>         }
>
>         PREPARE_HAL_BUF(wcn->hal_buf, msg_body);



-- 
Best regards,
Eugene
