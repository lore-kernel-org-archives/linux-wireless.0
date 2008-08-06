Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:18470 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYHFWmP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 18:42:15 -0400
Received: by rv-out-0506.google.com with SMTP id k40so147225rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 15:42:15 -0700 (PDT)
Message-ID: <1ba2fa240808061542k7fd3e0dat61df0ee77710e463@mail.gmail.com> (sfid-20080807_004219_654636_9260DBB6)
Date: Thu, 7 Aug 2008 01:42:15 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fill start-sequence-number for BA session start
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1218051926.23048.65.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1218051926.23048.65.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 6, 2008 at 10:45 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Otherwise, drivers are required to keep track of the sequence numbers
> themselves, and they really shouldn't be since we already do it for
> them. I'll fix the race once we figure out how this code should work
> at all, it's currently disabled.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Finally I know why nothing works in iwlwifi. This is most crucial
point of correct driver behavior.
There is direct  mapping between hw queue indexes and sequence numbers....
This is bad.

> ---
>  net/mac80211/ht.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> --- everything.orig/net/mac80211/ht.c   2008-08-06 21:40:24.000000000 +0200
> +++ everything/net/mac80211/ht.c        2008-08-06 21:43:42.000000000 +0200
> @@ -78,7 +78,7 @@ int ieee80211_start_tx_ba_session(struct
>        struct ieee80211_local *local = hw_to_local(hw);
>        struct sta_info *sta;
>        struct ieee80211_sub_if_data *sdata;
> -       u16 start_seq_num = 0;
> +       u16 start_seq_num;
>        u8 *state;
>        int ret;
>        DECLARE_MAC_BUF(mac);
> @@ -158,6 +158,9 @@ int ieee80211_start_tx_ba_session(struct
>         * call back right away, it must see that the flow has begun */
>        *state |= HT_ADDBA_REQUESTED_MSK;
>
> +       /* This is slightly racy because the queue isn't stopped */
> +       start_seq_num = sta->tid_seq[tid];
> +
>        if (local->ops->ampdu_action)
>                ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_START,
>                                                ra, tid, &start_seq_num);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
