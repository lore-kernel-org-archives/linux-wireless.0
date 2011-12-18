Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49267 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab1LRSha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Dec 2011 13:37:30 -0500
Received: by dajs34 with SMTP id s34so3064019daj.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Dec 2011 10:37:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324232745-22928-2-git-send-email-eliad@wizery.com>
References: <1324232745-22928-1-git-send-email-eliad@wizery.com> <1324232745-22928-2-git-send-email-eliad@wizery.com>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Sun, 18 Dec 2011 20:37:14 +0200
Message-ID: <CA+XVXfcexCXc00-oH9O=3TeQuzzm3kkpR+e0u2ycyaeM-3Qdrg@mail.gmail.com> (sfid-20111218_193734_148718_F48F9887)
Subject: Re: [PATCH 1/7] wl12xx: implement change_interface
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 18, 2011 at 20:25, Eliad Peller <eliad@wizery.com> wrote:
> Implement the change_interface callback by simply removing the
> current vif and adding a new one after updating the vif type.
>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/main.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index c305841..86a7ee3 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -2269,6 +2269,16 @@ out:
>        cancel_work_sync(&wl->recovery_work);
>  }
>
> +static int wl12xx_op_change_interface(struct ieee80211_hw *hw,
> +                                     struct ieee80211_vif *vif,
> +                                     enum nl80211_iftype new_type, bool p2p)
> +{
> +       wl1271_op_remove_interface(hw, vif);
> +
> +       vif->type = ieee80211_iftype_p2p(new_type, p2p);

Isn't this internal?
