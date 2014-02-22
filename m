Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:48782 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaBVAKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 19:10:21 -0500
Received: by mail-la0-f52.google.com with SMTP id c6so2889018lan.25
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 16:10:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392896671-4288-6-git-send-email-ilan.peer@intel.com>
References: <1392896671-4288-1-git-send-email-ilan.peer@intel.com> <1392896671-4288-6-git-send-email-ilan.peer@intel.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 21 Feb 2014 16:09:59 -0800
Message-ID: <CAB=NE6Vo2WsVc7zwpB3xnRre1MWL2FeQLvqMsheRFXG5hOxwTw@mail.gmail.com> (sfid-20140222_011024_668746_BC3EB330)
Subject: Re: [PATCH v5 5/5] cfg80211: Enable GO operation on indoor channels
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 20, 2014 at 3:44 AM, Ilan Peer <ilan.peer@intel.com> wrote:
> Allow GO operation on a channel marked with IEEE80211_CHAN_INDOOR_ONLY
> iff there is a user hint indicating that the platform is operating in
> an indoor environment, i.e., the platform is a printer or media center
> device.
>
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> ---
>  net/wireless/chan.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index 1d8c990..b18367d 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -611,6 +611,8 @@ EXPORT_SYMBOL(cfg80211_chandef_usable);
>   * IEEE80211_CHAN_GO_CONCURRENT and there is an additional station interface
>   * associated to an AP on the same channel or on the same UNII band
>   * (assuming that the AP is an authorized master).
> + * In addition allow the GO to operate on a channel on which indoor operation is
> + * allowed, iff we are currently operating in an indoor environment.
>   */
>  static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
>                                         struct ieee80211_channel *chan)
> @@ -621,8 +623,14 @@ static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
>         ASSERT_RTNL();
>
>         if (!config_enabled(CONFIG_CFG80211_REG_RELAX_NO_IR) ||
> -           !(wiphy->regulatory_flags & REGULATORY_ENABLE_RELAX_NO_IR) ||
> -           !(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
> +           !(wiphy->regulatory_flags & REGULATORY_ENABLE_RELAX_NO_IR))
> +               return false;
> +
> +       if (regulatory_indoor_allowed() &&
> +           (chan->flags & IEEE80211_CHAN_INDOOR_ONLY))
> +               return true;
> +
> +       if (!(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
>                 return false;

Shouldn't this check go before the indoor one?

  Luis
