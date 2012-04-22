Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44440 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2DVRBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 13:01:14 -0400
Received: by wibhr17 with SMTP id hr17so1953785wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2012 10:01:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1335110415-12695-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335110415-12695-1-git-send-email-wey-yi.w.guy@intel.com>
Date: Sun, 22 Apr 2012 20:01:12 +0300
Message-ID: <CANUX_P3EUTKsJG=J6tqZMNULbm3E+q8hTbtFz3emQyS8bN7sQw@mail.gmail.com> (sfid-20120422_190147_496942_E2822878)
Subject: Re: [PATCH 1/1] mac80211: check for non-managed interface
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 22, 2012 at 19:00, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> Average beacon signal only keep tracked by managed interface,
> give warning and return 0 for the others.
>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  net/mac80211/util.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 89c1e5b..2cbcb6a 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1799,5 +1799,10 @@ int ieee80211_ave_rssi(struct ieee80211_vif *vif)
>        struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
>        struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
>
> +       if (sdata->vif.type != NL80211_IFTYPE_STATION) {
> +               /* non-managed type inferfaces */
> +               WARN_ON(1);

WARN_ON_ONCE ?
We don't need to flood the kernel log here

> +               return 0;
> +       }
>        return ifmgd->ave_beacon_signal;
>  }
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
