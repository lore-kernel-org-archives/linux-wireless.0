Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:36223 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbbF3B32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 21:29:28 -0400
Received: by ykdr198 with SMTP id r198so130942635ykd.3
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jun 2015 18:29:27 -0700 (PDT)
Message-ID: <5591F0F4.3010008@lwfinger.net> (sfid-20150630_033008_898576_62E38E96)
Date: Mon, 29 Jun 2015 20:29:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Nik Nyby <nikolas@gnu.org>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: Fix typo in function name
References: <1435625147-23535-1-git-send-email-nikolas@gnu.org>
In-Reply-To: <1435625147-23535-1-git-send-email-nikolas@gnu.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2015 07:45 PM, Nik Nyby wrote:
> This fixes a typo in the "b43_lo_g_maintenance_work" function
> name.
>
> Signed-off-by: Nik Nyby <nikolas@gnu.org>
> ---
>   drivers/net/wireless/b43/lo.c    | 4 ++--
>   drivers/net/wireless/b43/lo.h    | 2 +-
>   drivers/net/wireless/b43/phy_g.c | 2 +-
>   3 files changed, 4 insertions(+), 4 deletions(-)

This patch is OK; however, can there really be a typo in a function name? How do 
you ever know that the author did not mean to use a name that looks like a typo?

Please be careful with these.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

>
> diff --git a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
> index 916123a..a335f94 100644
> --- a/drivers/net/wireless/b43/lo.c
> +++ b/drivers/net/wireless/b43/lo.c
> @@ -929,8 +929,8 @@ void b43_lo_g_adjust_to(struct b43_wldev *dev,
>   	b43_lo_write(dev, &cal->ctl);
>   }
>
> -/* Periodic LO maintanance work */
> -void b43_lo_g_maintanance_work(struct b43_wldev *dev)
> +/* Periodic LO maintenance work */
> +void b43_lo_g_maintenance_work(struct b43_wldev *dev)
>   {
>   	struct b43_phy *phy = &dev->phy;
>   	struct b43_phy_g *gphy = phy->g;
> diff --git a/drivers/net/wireless/b43/lo.h b/drivers/net/wireless/b43/lo.h
> index 3b27e20..7b4df38 100644
> --- a/drivers/net/wireless/b43/lo.h
> +++ b/drivers/net/wireless/b43/lo.h
> @@ -80,7 +80,7 @@ void b43_lo_g_adjust_to(struct b43_wldev *dev,
>
>   void b43_gphy_dc_lt_init(struct b43_wldev *dev, bool update_all);
>
> -void b43_lo_g_maintanance_work(struct b43_wldev *dev);
> +void b43_lo_g_maintenance_work(struct b43_wldev *dev);
>   void b43_lo_g_cleanup(struct b43_wldev *dev);
>   void b43_lo_g_init(struct b43_wldev *dev);
>
> diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
> index 727ce6e..462310e 100644
> --- a/drivers/net/wireless/b43/phy_g.c
> +++ b/drivers/net/wireless/b43/phy_g.c
> @@ -3004,7 +3004,7 @@ static void b43_gphy_op_pwork_15sec(struct b43_wldev *dev)
>   		   phy->rev == 1) {
>   		//TODO: implement rev1 workaround
>   	}
> -	b43_lo_g_maintanance_work(dev);
> +	b43_lo_g_maintenance_work(dev);
>   	b43_mac_enable(dev);
>   }
>
>

