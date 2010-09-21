Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60002 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab0IUTkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 15:40:21 -0400
Received: by iwn5 with SMTP id 5so5352413iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Sep 2010 12:40:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285097460.12764.13.camel@jlt3.sipsolutions.net>
References: <1285097222-10286-1-git-send-email-lrodriguez@atheros.com> <1285097460.12764.13.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 21 Sep 2010 12:39:59 -0700
Message-ID: <AANLkTikAbwntNzX43zAfNjkV56sVeFhOuHiV5odpuL5T@mail.gmail.com>
Subject: Re: [RFC] mac80211: Deny new BA sessions from being started during
 offchannel operation
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, srinivasa.duvvuri@atheros.com,
	matt.smith@atheros.com, bennyam.malavazi@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 21, 2010 at 12:31 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-09-21 at 15:27 -0400, Luis R. Rodriguez wrote:
>
>> +     mutex_lock(&local->sta_mtx);
>> +     list_for_each_entry(sta, &local->sta_list, list)
>> +             if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)
>> +                     set_sta_flags(sta, WLAN_STA_BLOCK_BA);
>> +     mutex_unlock(&local->sta_mtx);
>> +
>
> This is really expensive, I don't think we should do it this way.
> Wouldn't it be possible to put a check into place wherever the flag is
> checked too?

Good point, sure, we'll need more checks and conditions added later
too so that would also help to avoid running into this code for
non-11n cards.

  Luis
