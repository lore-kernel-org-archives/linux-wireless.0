Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:47716 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbYFXMvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 08:51:04 -0400
Received: by py-out-1112.google.com with SMTP id p76so1351926pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 05:51:03 -0700 (PDT)
Message-ID: <1ba2fa240806240551k6b795ccuf1f425cebe64773c@mail.gmail.com> (sfid-20080624_145113_288704_531723BB)
Date: Tue, 24 Jun 2008 15:51:02 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Subject: Re: [PATCH 4/4 V2] mac80211: add phy information to giwname
Cc: linux-wireless@vger.kernel.org,
	"Tomas Winkler" <tomas.winkler@intel.com>
In-Reply-To: <1214310146-730-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214310146-730-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2008 at 3:22 PM, Tomas Winkler <tomas.winkler@intel.com> wrote:
> This patch add phy information to giwname. Currently
> 802.11b is not treated.
>
> Quoting:
> It's not useless, it's supposed to tell you about the protocol
> capability of the device, like "IEEE 802.11b" or "IEEE 802.11abg"
>
> Jean
>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  net/mac80211/wext.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
>
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 308b953..8778c7d 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -135,7 +135,24 @@ static int ieee80211_ioctl_giwname(struct net_device *dev,
>                                   struct iw_request_info *info,
>                                   char *name, char *extra)
>  {
> +       struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> +       struct ieee80211_supported_band *sband;
> +       u8 is_ht = 0;
> +
>        strcpy(name, "IEEE 802.11");
> +       sband = local->hw.wiphy->bands[IEEE80211_BAND_5GHZ];
> +
> +       if (sband) {
> +               strcat(name, "a");
> +               is_ht |= sband->ht_info.ht_supported;
> +       }
> +       sband = local->hw.wiphy->bands[IEEE80211_BAND_2GHZ];
> +       if (sband) {
> +               strcat(name, "g");
> +               is_ht |= sband->ht_info.ht_supported;
> +       }
> +       if (is_ht)
> +               strcat(name, "n");
>
>        return 0;
>  }
> --
Oops. this is not V2
