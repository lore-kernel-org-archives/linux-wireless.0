Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38810 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab2KZM7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 07:59:24 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so10678975oag.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 04:59:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353930289-2710-3-git-send-email-johannes@sipsolutions.net>
References: <1353930289-2710-1-git-send-email-johannes@sipsolutions.net>
	<1353930289-2710-3-git-send-email-johannes@sipsolutions.net>
Date: Mon, 26 Nov 2012 14:59:23 +0200
Message-ID: <CAB3XZEdRa2=_eq9q0Bt07SA=qasnpA6cm1r8YiLZ-qkiQAg5JA@mail.gmail.com> (sfid-20121126_135927_596690_FB0ACA7F)
Subject: Re: [PATCH 2/2] mac80211: support P2P GO powersave configuration
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 26, 2012 at 1:44 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> If the low-level driver wants to support P2P GO
> powersave configuration, it must set the cfg80211
> flags and mac80211 will pass the parameters to it.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/cfg.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 5d30e5f..97cf615 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -893,7 +893,8 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
>         u32 changed = BSS_CHANGED_BEACON_INT |
>                       BSS_CHANGED_BEACON_ENABLED |
>                       BSS_CHANGED_BEACON |
> -                     BSS_CHANGED_SSID;
> +                     BSS_CHANGED_SSID |
> +                     BSS_CHANGED_P2P_PS;
>         int err;
>
you'd probably want to add it to ieee80211_reconfig as well.

Eliad.
