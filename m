Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:61191 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaAVGyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 01:54:07 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so4295259eaj.40
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jan 2014 22:54:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390316116.6199.23.camel@jlt4.sipsolutions.net>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	<1390227670-19030-2-git-send-email-michal.kazior@tieto.com>
	<1390316116.6199.23.camel@jlt4.sipsolutions.net>
Date: Wed, 22 Jan 2014 07:54:06 +0100
Message-ID: <CA+BoTQ=RSDMBQYC0nZxP8a6oY6=dH28aeLy3GCxWkup-1DS3SA@mail.gmail.com> (sfid-20140122_075411_613025_0A23BE74)
Subject: Re: [PATCH 1/7] mac80211: fix possible memory leak on AP CSA failure
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 January 2014 15:55, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-01-20 at 15:21 +0100, Michal Kazior wrote:
>> If CSA for AP interface failed and the interface
>> was not stopped afterwards another CSA request
>> would leak sdata->u.ap.next_beacon.
>
>>  void ieee80211_csa_finish(struct ieee80211_vif *vif)
>>  {
>>       struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
>> @@ -3019,15 +3034,9 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
>>       sdata->vif.csa_active = false;
>>       switch (sdata->vif.type) {
>>       case NL80211_IFTYPE_AP:
>> -             err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
>> +             err = ieee80211_ap_finish_csa(sdata);
>>               if (err < 0)
>>                       return;
>> -
>> -             changed |= err;
>
> This looks a bit like somebody had intended to batch the
> ieee80211_bss_info_change_notify() calls, which would probably be a good
> thing. You're breaking them apart even further - maybe we should
> actually batch them instead by moving ieee80211_bss_info_change_notify()
> after the switch()?

Sounds good. I'll fix it.


Michał
