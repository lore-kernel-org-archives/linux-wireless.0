Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:64763 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaBNK40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 05:56:26 -0500
Received: by mail-ve0-f172.google.com with SMTP id c14so9520053vea.17
        for <linux-wireless@vger.kernel.org>; Fri, 14 Feb 2014 02:56:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392373327-12063-1-git-send-email-luca@coelho.fi>
References: <1392373327-12063-1-git-send-email-luca@coelho.fi>
Date: Fri, 14 Feb 2014 18:56:25 +0800
Message-ID: <CAEFj985KeAFQkeZ3oWFSR5mgpr9X9fU2n6XTofixnb2yapvg_Q@mail.gmail.com> (sfid-20140214_115630_777243_B567A9E7)
Subject: Re: [PATCH] nl80211: make sure we check for DFS with mesh channel switch
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <sw@simonwunderlich.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Luciano Coelho <luciano.coelho@intel.com>
>
> Since mesh support for DFS channels was added, we also need to check
> for DFS channels when performing a channel switch with
> NL80211_IFTYPE_MESHPOINT.
>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---
>  net/wireless/nl80211.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 1797864..b78d734 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -5912,7 +5912,8 @@ skip_beacons:
>
>         if (dev->ieee80211_ptr->iftype == NL80211_IFTYPE_AP ||
>             dev->ieee80211_ptr->iftype == NL80211_IFTYPE_P2P_GO ||
> -           dev->ieee80211_ptr->iftype == NL80211_IFTYPE_ADHOC) {
> +           dev->ieee80211_ptr->iftype == NL80211_IFTYPE_ADHOC ||
> +           dev->ieee80211_ptr->iftype == NL80211_IFTYPE_MESH_POINT) {
>                 err = cfg80211_chandef_dfs_required(wdev->wiphy,
>                                                     &params.chandef);
>                 if (err < 0) {
> --
> 1.8.5.3
>

Acked-by: Chun-Yeow Yeoh <yeohchunyeow@xxxxxxxxxxxxxxxxxx>
