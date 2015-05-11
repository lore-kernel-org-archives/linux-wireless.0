Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35282 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbbEKLwC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 07:52:02 -0400
Received: by widdi4 with SMTP id di4so102061292wid.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 04:52:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431338007.1964.16.camel@sipsolutions.net>
References: <1431337193-17472-1-git-send-email-janusz.dziedzic@tieto.com>
	<1431337921.1964.15.camel@sipsolutions.net>
	<1431338007.1964.16.camel@sipsolutions.net>
Date: Mon, 11 May 2015 13:52:01 +0200
Message-ID: <CALhHN=rYWtBycQiXmi5_zp0rHxxQR6TW0hrK05RLNvZ-sYucfw@mail.gmail.com> (sfid-20150511_135207_468561_3AD5944D)
Subject: Re: [PATCH] mac80211: IBSS, clear fast_sta when update rates
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 May 2015 at 11:53, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2015-05-11 at 11:52 +0200, Johannes Berg wrote:
>> On Mon, 2015-05-11 at 11:39 +0200, Janusz Dziedzic wrote:
>> > This is required to handle sta.wme correctly
>> > after update rates (eg. when using HT/VHT) when
>> > driver using IEEE80211_HW_SUPPORT_FAST_XMIT.
>>
>> Wouldn't you want to check, so it can be re-assigned?
>
> i.e. something like
>
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index bfef1b215050..7e62183525aa 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -1031,8 +1031,11 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
>                 }
>         }
>
> -       if (sta && elems->wmm_info && local->hw.queues >= IEEE80211_NUM_ACS)
> +       if (sta && !sta->sta.wme && elems->wmm_info &&
> +           local->hw.queues >= IEEE80211_NUM_ACS) {
>                 sta->sta.wme = true;
> +               ieee80211_check_fast_xmit(sta);
> +       }
>
>         if (sta && elems->ht_operation && elems->ht_cap_elem &&
>             sdata->u.ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
>
Your version also works fine.
Should I send new patch or you already have this in your tree?

BR
Janusz
