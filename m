Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43392 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1JTQsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 12:48:25 -0400
Received: by wwe6 with SMTP id 6so4462638wwe.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 09:48:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201110201146.00505.chunkeey@googlemail.com>
References: <1319072606-28291-1-git-send-email-thomas@cozybit.com>
	<1319072606-28291-5-git-send-email-thomas@cozybit.com>
	<201110201146.00505.chunkeey@googlemail.com>
Date: Thu, 20 Oct 2011 09:48:24 -0700
Message-ID: <CAG6hwVN8XipeDT979nei7XEQ8vOsy1jVwuvyRbi1fTCDgRgR0Q@mail.gmail.com> (sfid-20111020_184827_899169_0C5C1B25)
Subject: Re: [PATCH 4/6] mac80211: allow frame aggregation for mesh
From: Thomas Pedersen <thomas@cozybit.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, anagar6@uic.edu,
	devel@lists.open80211s.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 20, 2011 at 2:46 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Thursday, October 20, 2011 03:03:24 AM Thomas Pedersen wrote:
>> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
>> Signed-off-by: Ashok Nagarajan <anagar6@uic.edu>
>> ---
>>  net/mac80211/agg-rx.c |    3 ++-
>>  net/mac80211/agg-tx.c |    4 +++-
>>  net/mac80211/ht.c     |    3 ++-
>>  net/mac80211/rx.c     |    1 +
>>  4 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
>> index 2ac0339..36c2836 100644
>> --- a/net/mac80211/agg-tx.c
>> +++ b/net/mac80211/agg-tx.c
>> @@ -378,6 +379,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
>>        * by drivers or the standard.
>>        */
>>       if (sdata->vif.type != NL80211_IFTYPE_STATION &&
>> +         sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
>>           sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
>>           sdata->vif.type != NL80211_IFTYPE_AP)
>>               return -EINVAL;
>
> just a nitpick, but it looks like the comment in agg-tx.c
> seems to be a little out of date. Hence, would you mind
> removing it as well?
>

No problem :)

>        /*
>         * The aggregation code is not prepared to handle
>         * anything but STA/AP due to the BSSID handling.
>         * IBSS could work in the code but isn't supported
>         * by drivers or the standard.
>         */
>        if (sdata->vif.type != NL80211_IFTYPE_STATION &&
>            sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
>            sdata->vif.type != NL80211_IFTYPE_AP)
>                return -EINVAL;
>
> Regards,
>        Chr
>
