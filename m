Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56679 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaFQFw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 01:52:57 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so5134001wiv.2
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2014 22:52:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402929323.13599.13.camel@dubbel>
References: <1401972980-21484-1-git-send-email-michal.kazior@tieto.com>
	<1402577680-17888-1-git-send-email-michal.kazior@tieto.com>
	<1402577680-17888-2-git-send-email-michal.kazior@tieto.com>
	<1402929323.13599.13.camel@dubbel>
Date: Tue, 17 Jun 2014 07:52:55 +0200
Message-ID: <CA+BoTQmWCAaMFjmoq4j7oFf3nPHtNxtBOpbGp6UE061-oXdnxA@mail.gmail.com> (sfid-20140617_075300_717344_4841EF26)
Subject: Re: [PATCH v9 1/5] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 June 2014 16:35, Luca Coelho <luca@coelho.fi> wrote:
> On Thu, 2014-06-12 at 14:54 +0200, Michal Kazior wrote:
>> Multi-vif in-place reservations happen when
>> it is impossible to allocate more channel contexts
>> as indicated by interface combinations.
>>
>> Such reservations are not finalized until all
>> assigned interfaces are ready.
>>
>> This still doesn't handle all possible cases
>> (i.e. degradation of number of channels) properly.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>>
>
> [...]
>
>> diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
>> index 3702d64..159f4c3 100644
>> --- a/net/mac80211/chan.c
>> +++ b/net/mac80211/chan.c
>> @@ -63,6 +63,19 @@ static bool ieee80211_can_create_new_chanctx(struct ieee80211_local *local)
>>       return ieee80211_num_chanctx(local) < ieee80211_max_num_channels(local);
>>  }
>>
>> +static struct ieee80211_chanctx *
>> +ieee80211_vif_get_chanctx(struct ieee80211_sub_if_data *sdata)
>> +{
>> +     struct ieee80211_chanctx_conf *conf;
>> +
>> +     conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
>> +                                      lockdep_is_held(&local->chanctx_mtx));
>
> This doesn't compile.  local is undefined here. :(
>
> It's a simple fix though.  s/local/sdata->local/

Oh.. thanks! How did I not catch this -_-?


Michał
