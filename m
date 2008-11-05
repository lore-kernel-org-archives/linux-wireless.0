Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.177]:52052 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbYKETzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 14:55:24 -0500
Received: by el-out-1112.google.com with SMTP id z25so139139ele.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 11:55:23 -0800 (PST)
Message-ID: <43e72e890811051155q3cf0a16exa0911675d86959ae@mail.gmail.com> (sfid-20081105_205528_458463_E38977B6)
Date: Wed, 5 Nov 2008 11:55:23 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 5/7] cfg80211: expect different rd in cfg80211 when intersecting
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225886489.3619.84.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
	 <1225886489.3619.84.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 5, 2008 at 4:01 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2008-11-04 at 18:50 -0800, Luis R. Rodriguez wrote:
>> When intersecting it is possible that set_regdom() was called
>> with a regulatory domain which we'll only use as an aid to
>> build a final regulatory domain.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  net/wireless/reg.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index 845e2d3..f062b8b 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -880,12 +880,13 @@ int set_regdom(const struct ieee80211_regdomain *rd)
>>       }
>>
>>       /* This would make this whole thing pointless */
>> -     BUG_ON(rd != cfg80211_regdomain);
>> +     if (!last_request->intersect)
>> +             BUG_ON(rd != cfg80211_regdomain);
>>
>>       /* update all wiphys now with the new established regulatory domain */
>>       update_all_wiphy_regulatory(last_request->initiator);
>>
>> -     print_regdomain(rd);
>> +     print_regdomain(cfg80211_regdomain);
>
> Maybe the printing here should be removed? It seems confusing now.

Well IMHO its correct to print it here as *this* is after its been set
and passed through all wiphys. ACK?

  Luis
