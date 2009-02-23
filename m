Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:57491 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZBWRrR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 12:47:17 -0500
Received: by wf-out-1314.google.com with SMTP id 28so2593974wfa.4
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 09:47:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090223163738.20939.25890.stgit@tikku>
References: <20090223163626.20939.4879.stgit@tikku>
	 <20090223163738.20939.25890.stgit@tikku>
Date: Mon, 23 Feb 2009 09:47:15 -0800
Message-ID: <43e72e890902230947x6e55bf36ve715295f43f74fbb@mail.gmail.com> (sfid-20090223_184720_894144_111D6FBA)
Subject: Re: [RFC PATCH v1 3/3] mac80211: add beacon filtering support
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2009 at 8:37 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Add IEEE80211_HW_BEACON_FILTERING flag so that driver inform that it supports
> beacon filtering. Drivers need to call the new function
> ieee80211_beacon_loss() to notify about beacon loss.
>
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
> ---
>
>  include/net/mac80211.h     |    2 ++
>  net/mac80211/ieee80211_i.h |    2 ++
>  net/mac80211/iface.c       |    3 +++
>  net/mac80211/mlme.c        |   34 +++++++++++++++++++++++++++++++++-
>  4 files changed, 40 insertions(+), 1 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index e01c63a..f74bada 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -903,6 +903,7 @@ enum ieee80211_hw_flags {
>        IEEE80211_HW_PS_NULLFUNC_STACK                  = 1<<11,
>        IEEE80211_HW_SUPPORTS_DYNAMIC_PS                = 1<<12,
>        IEEE80211_HW_MFP_CAPABLE                        = 1<<13,
> +       IEEE80211_HW_BEACON_FILTERING                   = 1<<14,

Not sure this conveys what it means, how about BEACON_MISS ?

>  };
>
>  /**
> @@ -1971,6 +1972,7 @@ void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, const u8 *ra,
>  struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_hw *hw,
>                                         const u8 *addr);
>
> +void ieee80211_beacon_loss(struct ieee80211_hw *hw);
>
>  /* Rate control API */
>

Some kdoc would be nice for this. Also I suspect you designed this
with 2 GHz legacy (802.11bg) single band cards in mind. For the case
or cards capable of 5 GHz or of HT I believe we should consider the
cases of dealing with DFS or HT channel switch both of which can occur
dynamically while the STAs are associated. If hardware is capable of
differentiating this (through beacon checksums) then that's an
enhancement but for now I suspect that is not the case for most
hardware that implements this and as such for the case when on DFS or
using HT we can simply have mac80211 disable this. Not sure...
Thoughts?

  Luis
