Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:51763 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZFBVBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 17:01:34 -0400
Received: by qw-out-2122.google.com with SMTP id 5so5797375qwd.37
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2009 14:01:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243974947.7176.9.camel@johannes.local>
References: <1243974603-15058-1-git-send-email-lrodriguez@atheros.com>
	<1243974947.7176.9.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 2 Jun 2009 14:01:16 -0700
Message-ID: <43e72e890906021401r2200bad9n1ffbe2c56c3a2c22@mail.gmail.com>
Subject: Re: [PATCH] mac80211: check for existance sta before adding it
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 2, 2009 at 1:35 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2009-06-02 at 16:30 -0400, Luis R. Rodriguez wrote:
>> Lets just check for the STA before its addition through
>> sta_info_insert() and make this mandatory. It simpifies
>> code.
>>
>> In our mac80211 cfg80211 callback for device addition we
>> also can simplify the code by first checking for the STA
>> before trying to add it and then checking for -EEXIST which
>> we were not doing. If that actualy would happen we could
>> end up potentially with a stale sta and the rate info was
>> never updated. We should now be updating accordingly.
>>
>> Since we are making part of the API to check for the STA
>> prior to addition lets warn in sta_info_insert() if the
>> sta does already exist instead of passing an -EEXIST.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>
>> johill, this is what I meant. Still not the right approach?
>
> This may sound flippy, but you do need to understand RCU first. This is
> simply not correct, even with rcu_read_lock() the sta info might be
> unlinked from the list, your pointer will just point to something no
> longer on the list.

Thanks, yeah I see where I was making an incorrect assumption here.

There still is a case here where userpsace can try to add a sta twice
and the second parameters passed would be ignored.

  Luis
