Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37484 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149AbbGQJf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 05:35:56 -0400
Received: by wibud3 with SMTP id ud3so37792406wib.0
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2015 02:35:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1437124199.1933.6.camel@sipsolutions.net>
References: <1435823996-32510-1-git-send-email-michal.kazior@tieto.com>
	<1437123955.1933.3.camel@sipsolutions.net>
	<1437124038.1933.4.camel@sipsolutions.net>
	<1437124199.1933.6.camel@sipsolutions.net>
Date: Fri, 17 Jul 2015 11:35:55 +0200
Message-ID: <CA+BoTQnMFLLq9tFdXR42YArd2m=WuxfKbyguQc+G2cZSSJ8nAw@mail.gmail.com> (sfid-20150717_113600_735242_68C0B8E1)
Subject: Re: [PATCH] mac80211: don't clear all tx flags when requeing
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 July 2015 at 11:09, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2015-07-17 at 11:07 +0200, Johannes Berg wrote:
>>
>> > > Once (a) is not stripped (b) becomes important
>> > > because it's the main condition to clear the
>> > > Service Period bit of the station when Tx status
>> > > for the released frame is reported back.
>> > >
>> > > This problem was observed with ath9k acting as P2P
>> > > GO in some testing scenarios but isn't limited to
>> > > it. AP operation with mac80211 based Tx A-MPDU
>> > > control combined with clients using PS-Poll frames
>> > > is subject to this race.
>> >
>> > I'm not sure I quite understand - how is the aggregation teardown
>> > causing frame filtering?
>> >
>>
>> Never mind, I was looking at the wrong code. I'll apply this.
>>
>
> However, I'd like to ask you to look at this again - I can see how it
> fixes the problem now, but it seems like a fairly unreliable fix since
> the frame is sent through TX processing again, and you're relying on
> that preserving a flag that's otherwise marked temporary...
>
> So I think it may be better to adjust the station flags in this case to
> let a new (the same) frame be the ps-poll response again.

Hmm.. I did contemplate on clearing the station flag. I didn't explore
the idea thoroughly but my feeling was it could introduce new u-APSD
corner-case bug(s) since you'd be changing the station state before
it'd normally be done and hence would behave differently when handling
Rx. I'll look into it more.


Michał
