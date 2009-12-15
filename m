Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33481 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759935AbZLOSLv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 13:11:51 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2009 10:11:51 -0800
Date: Tue, 15 Dec 2009 10:11:49 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: =?utf-8?B?THVrw6HFoQ==?= Turek <8an@praha12.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] [PATCH 2/5] mac80211: Add new callback
 set_coverage_class
Message-ID: <20091215181149.GA2123@tux>
References: <1260899813-17585-1-git-send-email-8an@praha12.net>
 <1260899813-17585-3-git-send-email-8an@praha12.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <1260899813-17585-3-git-send-email-8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 15, 2009 at 09:56:49AM -0800, Lukáš Turek wrote:
> Mac80211 callback to driver set_coverage_class() sets slot time and ACK
> timeout for given IEEE 802.11 coverage class. The callback is optional,
> but it's essential for long distance links.
> 
> Signed-off-by: Lukas Turek <8an@praha12.net>
> ---
>  include/net/mac80211.h |    5 +++++
>  net/mac80211/cfg.c     |    7 +++++++
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 2aff490..786e1d6 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1483,6 +1483,10 @@ enum ieee80211_ampdu_mlme_action {
>   *     need to set wiphy->rfkill_poll to %true before registration,
>   *     and need to call wiphy_rfkill_set_hw_state() in the callback.
>   *
> + * @set_coverage_class: Set slot time for given coverage class as specified
> + *     in IEEE 802.11-2007 section 17.3.8.6 and modify ACK timeout
> + *     accordingly. This callback is not required and may sleep.
> + *
>   * @testmode_cmd: Implement a cfg80211 test mode command.
>   */
>  struct ieee80211_ops {
> @@ -1537,6 +1541,7 @@ struct ieee80211_ops {
>                             struct ieee80211_sta *sta, u16 tid, u16 *ssn);
> 
>         void (*rfkill_poll)(struct ieee80211_hw *hw);
> +       void (*set_coverage_class)(struct ieee80211_hw *hw, u8 coverage_class);
>  #ifdef CONFIG_NL80211_TESTMODE
>         int (*testmode_cmd)(struct ieee80211_hw *hw, void *data, int len);
>  #endif
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 6dc3579..c5537ae 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -1237,6 +1237,13 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
>         struct ieee80211_local *local = wiphy_priv(wiphy);
>         int err;
> 
> +       if (changed & WIPHY_PARAM_COVERAGE_CLASS) {
> +               if (!local->ops->set_coverage_class)
> +                       return -EOPNOTSUPP;

Hm, it seems best to just add the capability bit that way userspace
can stuff what it wishes and the kernel will only set what is supported.
As is now this would lead to -EOPNOTSUPP but we'd have no way of knowing
from userspace what failed.

This comment is not specific to just this parameter but if you see the
current implementation of ieee80211_set_wiphy_params() doesn't fail
with -EOPNOTSUPP because I suppose WIPHY_PARAM_RTS_THRESHOLD is
required.

> +               local->ops->set_coverage_class(&local->hw,
> +                                              wiphy->coverage_class);
> +       }
> +
>         if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
>                 err = drv_set_rts_threshold(local, wiphy->rts_threshold);

  Luis
