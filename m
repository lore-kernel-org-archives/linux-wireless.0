Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39812 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbYIKAGi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 20:06:38 -0400
Date: Wed, 10 Sep 2008 17:06:30 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 16/18] mac80211 hwsim: verify vif pointers
Message-ID: <20080911000630.GC20358@tesla> (sfid-20080911_020640_575400_E3D03E76)
References: <20080910220145.707263000@sipsolutions.net> <20080910220426.564761000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20080910220426.564761000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 10, 2008 at 03:02:01PM -0700, Johannes Berg wrote:
> --- everything.orig/drivers/net/wireless/mac80211_hwsim.c       2008-09-10 23:58:05.000000000 +0200
> +++ everything/drivers/net/wireless/mac80211_hwsim.c    2008-09-10 23:58:11.000000000 +0200
> @@ -28,6 +28,29 @@ static int radios = 2;
>  module_param(radios, int, 0444);
>  MODULE_PARM_DESC(radios, "Number of simulated radios");
> 
> +struct hwsim_vif_priv {
> +       u32 magic;
> +};
> +
> +#define HWSIM_VIF_MAGIC        0x69537748
> +
> +static inline void hwsim_check_magic(struct ieee80211_vif *vif)
> +{
> +       struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
> +       BUG_ON(vp->magic != HWSIM_VIF_MAGIC);

If its a debugging tool then better WARN_ON instead no?

  Luis
