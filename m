Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:57453 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaAWGWJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 01:22:09 -0500
Received: by mail-bk0-f44.google.com with SMTP id mz12so203065bkb.31
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 22:22:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390403634.4189.39.camel@porter.coelho.fi>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	<1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	<1390316761.6199.27.camel@jlt4.sipsolutions.net>
	<CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	<1390380726.4334.4.camel@jlt4.sipsolutions.net>
	<CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com>
	<1390382020.4334.17.camel@jlt4.sipsolutions.net>
	<CA+BoTQ=iQ26EMyOS4Eroqf2G-uLtUUZHAxN6rD3Eq6CvSUj5Xg@mail.gmail.com>
	<1390385995.4334.27.camel@jlt4.sipsolutions.net>
	<1390394166.4189.28.camel@porter.coelho.fi>
	<1390403432.4334.33.camel@jlt4.sipsolutions.net>
	<1390403634.4189.39.camel@porter.coelho.fi>
Date: Thu, 23 Jan 2014 07:22:07 +0100
Message-ID: <CA+BoTQ=+TGFo0f0z1SymiN5DkeLZUPC_p_YVZ59s=FFqpGV3vQ@mail.gmail.com> (sfid-20140123_072213_385694_E5DCC62D)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 January 2014 16:13, Luca Coelho <luca@coelho.fi> wrote:
> On Wed, 2014-01-22 at 16:10 +0100, Johannes Berg wrote:
>> On Wed, 2014-01-22 at 14:36 +0200, Luca Coelho wrote:
>>
>> > I don't think we should try to merge the channel switches.  We should
>> > just perform them separately, especially because the exact time of the
>> > switch will most likely not be the same (since the TBTTs are not in
>> > sync).
>>
>> Do you mean that we shouldn't even have all that new API to switch
>> multiple interfaces simultaneously?
>
> Right, I'm not really sure it's necessary.  PErhaps with non-chanctx we
> need something like that, but maybe it would still be better not to do
> this in the nl80211 API, but sync/merge in cfg80211/mac80211?

I was thinking about it. This should work, mostly, as long as you're
able to submit CSA requests fast enough and you don't use count 0 or
1, in which case it becomes racy.


Michał
