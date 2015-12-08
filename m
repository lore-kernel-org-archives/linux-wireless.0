Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:35132 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147AbbLHQCh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 11:02:37 -0500
Received: by vkha189 with SMTP id a189so17330413vkh.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2015 08:02:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1449583479-26658-3-git-send-email-emmanuel.grumbach@intel.com>
References: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com> <1449583479-26658-3-git-send-email-emmanuel.grumbach@intel.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 8 Dec 2015 21:32:17 +0530
Message-ID: <CABPxzYJB9M5FtxdjXeB5t-ygqv8OQ9LpVqsMvGTJa_r=nOb4Bw@mail.gmail.com> (sfid-20151208_170240_734757_CD9E7C0F)
Subject: Re: [PATCH 2/9] mac80211: limit the A-MSDU Tx based on peer's capabilities
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 8, 2015 at 7:34 PM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> index 7a76ce6..f4a5287 100644
> --- a/net/mac80211/ht.c
> +++ b/net/mac80211/ht.c
> @@ -230,6 +230,11 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
>         /* set Rx highest rate */
>         ht_cap.mcs.rx_highest = ht_cap_ie->mcs.rx_highest;
>
> +       if (ht_cap.cap & IEEE80211_HT_CAP_MAX_AMSDU)
> +               sta->sta.max_amsdu_len = IEEE80211_MAX_MPDU_LEN_HT_7935;
> +       else
> +               sta->sta.max_amsdu_len = IEEE80211_MAX_MPDU_LEN_HT_3839;
> +
>   apply:
>         changed = memcmp(&sta->sta.ht_cap, &ht_cap, sizeof(ht_cap));
>
> diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
> index 92c9843..d2f2ff6 100644
> --- a/net/mac80211/vht.c
> +++ b/net/mac80211/vht.c
> @@ -281,6 +281,24 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
>         }
>
>         sta->sta.bandwidth = ieee80211_sta_cur_vht_bw(sta);
> +
> +       /* If HT IE reported 3839 bytes only, stay with that size. */
> +       if (sta->sta.max_amsdu_len == IEEE80211_MAX_MPDU_LEN_HT_3839)
> +               return;
> +
> +       switch (vht_cap->cap & IEEE80211_VHT_CAP_MAX_MPDU_MASK) {
> +       case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454:
> +               sta->sta.max_amsdu_len = IEEE80211_MAX_MPDU_LEN_VHT_11454;
> +               break;
> +       case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991:
> +               sta->sta.max_amsdu_len = IEEE80211_MAX_MPDU_LEN_VHT_7991;
> +               break;
> +       case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895:
> +       default:
> +               sta->sta.max_amsdu_len = IEEE80211_MAX_MPDU_LEN_VHT_3895;
> +               break;
> +       }
Ideally speaking shouldn't we use different variables for HT and VHT
and depending on
rate HT/VHT we should aggregate accordingly? of course that will be
tricky as we dont
have the rate control info at the time of aggregation. Standard is
clear about usage of
independent lengths depending on whether its an VHT/HT PPDU.

If we use the same variable to arrive at max_amsdu_len for both VHT
and HT, we might
end up sending 11454 sized MSDU in a HT rate.
