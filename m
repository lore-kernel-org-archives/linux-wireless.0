Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:53488 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZFBUnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 16:43:20 -0400
Received: by qw-out-2122.google.com with SMTP id 5so5787836qwd.37
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2009 13:43:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243974886.7176.8.camel@johannes.local>
References: <1243974537-12774-1-git-send-email-lrodriguez@atheros.com>
	<1243974886.7176.8.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 2 Jun 2009 13:43:02 -0700
Message-ID: <43e72e890906021343v41f69346mc844e8a80daf2314@mail.gmail.com>
Subject: Re: [PATCH] mac80211: add missing RCU lock/unlock on
	ieee80211_rx_bss_info()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 2, 2009 at 1:34 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2009-06-02 at 16:28 -0400, Luis R. Rodriguez wrote:
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  net/mac80211/ibss.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
>> index 0b30277..446cada 100644
>> --- a/net/mac80211/ibss.c
>> +++ b/net/mac80211/ibss.c
>> @@ -365,7 +365,9 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
>>                      sdata->dev->name, mgmt->bssid);
>>  #endif
>>               ieee80211_sta_join_ibss(sdata, bss);
>> +             rcu_read_lock();
>>               ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
>> +             rcu_read_unlock();
>>       }
>
> I see no reason for this to be necessary.

Hm yeah, I failed to see it doesn't get the sta before allocating it
and/or adding it. Is that right for this particular case? If the sta
does exist we wouldn't have set up the things for it that
ieee80211_ibss_add_sta() is setting.

  Luis
