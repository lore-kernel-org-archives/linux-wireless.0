Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2642 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbXK3Wzl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2007 17:55:41 -0500
Date: Fri, 30 Nov 2007 17:55:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
Subject: Re: [PATCH 1/2] mac80211: add power management support -v2
Message-ID: <20071130225525.GB31953@tuxdriver.com> (sfid-20071130_225546_062555_42A48A6D)
References: <200711170007.01676.mboton.lkml@gmail.com> <200711170113.58396.mboton.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200711170113.58396.mboton.lkml@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 17, 2007 at 01:13:58AM +0100, Miguel Bot=F3n wrote:

> This patch adds power management support in mac80211.
>=20
> This allows us to enable power management through the "iwconfig <devi=
ce> power <off/on>" command.
> The code is based on "mac80211-10.0.0" but it is a little bit modifie=
d.
>=20
> Signed-off-by: Miguel Bot=F3n <mboton@gmail.com>
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 5fcc4c1..c82b6fa 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -452,6 +452,8 @@ struct ieee80211_conf {
>  	u8 antenna_max;
>  	u8 antenna_sel_tx;
>  	u8 antenna_sel_rx;
> +
> +	u8 power_management_enable;     /* flag to enable/disable power man=
agement */
>  };
> =20
>  /**

I'm not overly happy with this.  What about folding this into the
flags variable?

John
--=20
John W. Linville
linville@tuxdriver.com
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
