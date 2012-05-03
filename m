Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:41440 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758221Ab2ECTCk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 15:02:40 -0400
Received: by ghrr11 with SMTP id r11so2102877ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 12:02:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336071305.5167.5.camel@jlt3.sipsolutions.net>
References: <1335477667-1625-1-git-send-email-thomas@cozybit.com>
 <1335477667-1625-2-git-send-email-thomas@cozybit.com> <1336071305.5167.5.camel@jlt3.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 3 May 2012 12:02:18 -0700
Message-ID: <CAG6hwVO1j=Yt1pHXaW_svYS_4rUVcDa_1PzuohhNKt+cWsyKGQ@mail.gmail.com> (sfid-20120503_210243_110518_3A86D72F)
Subject: Re: [PATCH 2/2] mac80211: don't transmit 40MHz frames to 20MHz peer
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 3, 2012 at 11:55 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-04-26 at 15:01 -0700, Thomas Pedersen wrote:
>> If a mesh peer indicates it is operating as 20MHz-only in its HT
>> operation IE, have the rate control algorithm respect this by disabling
>> the equivalent bit in the ieee80211_sta HT capabilities.
>>
>> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
>> ---
>>  net/mac80211/mesh_plink.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
>> index f4124d7..6209327 100644
>> --- a/net/mac80211/mesh_plink.c
>> +++ b/net/mac80211/mesh_plink.c
>> @@ -302,6 +302,12 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
>>       else
>>               memset(&sta->sta.ht_cap, 0, sizeof(sta->sta.ht_cap));
>>
>> +     if (elems->ht_operation)
>> +             if (!(elems->ht_operation->ht_param &
>> +                   IEEE80211_HT_PARAM_CHAN_WIDTH_ANY))
>> +                     sta->sta.ht_cap.cap &=
>> +                                         ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
>
> The double if is a bit odd, why not use && to clean up all the
> formatting?

Good point, but later Ashok adds a patch which takes the same branch anyway.

Thomas
