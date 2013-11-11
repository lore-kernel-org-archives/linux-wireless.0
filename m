Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:53088 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3KKSHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 13:07:00 -0500
MIME-Version: 1.0
In-Reply-To: <1384189227.14334.48.camel@jlt4.sipsolutions.net>
References: <1384119945-31213-1-git-send-email-felipe.contreras@gmail.com>
	<1384160932.14334.6.camel@jlt4.sipsolutions.net>
	<CAMP44s3TFSgWuR8gVoFBznNP+t9mz+to===9i1PAnra4ogKu9w@mail.gmail.com>
	<1384184624.14334.31.camel@jlt4.sipsolutions.net>
	<CAMP44s2cVVe4-yW214B9hJu7n6M1onZpZaPCj5N0Fi1JWDKKsw@mail.gmail.com>
	<1384188067.14334.45.camel@jlt4.sipsolutions.net>
	<CAMP44s3nkj2wZYCPve7EhyeD7sEFmpUN=-h015dOP68PcNSTug@mail.gmail.com>
	<1384189227.14334.48.camel@jlt4.sipsolutions.net>
Date: Mon, 11 Nov 2013 12:06:58 -0600
Message-ID: <CAMP44s1yJMd+9G5yu988GqafRYnAteN-y-WWDe-rJh_qQpSPkQ@mail.gmail.com> (sfid-20131111_190709_738895_1E5684F1)
Subject: Re: [PATCH v2] mac80211: add assoc beacon timeout logic
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 11, 2013 at 11:00 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-11-11 at 10:53 -0600, Felipe Contreras wrote:

>> > Like I said before - trying to work with an AP without beacons at all is
>> > really bad, we shouldn't be doing it.
>>
>> Why not? For all intents and purposes my system is not receiving any
>> beacons, and I don't see any problems.
>
> The not receiving part is a bug. I think you're probably receiving
> beacons once associated though?

Nope. Never.

>> What would you prefer? That nothing works at all?
>
> Yes, that'd be much safer.

How exactly?

>> > We might not properly react to
>> > radar events, and other things, for example.
>>
>> So? I don't know what that means, but it can't be worst than not being
>> able to connect to the Internet whatsoever at all.
>
> It can make you break the law.

How?

I'm reading this document[1], and if that's what you are referring to,
then for starters it only applies to the master mode, my patch changes
the behavior only on station mode.

Moreover, if continuing the association without beacons has a legal a
problem, that problem would exist for drivers that don't have the
IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC flag, wouldn't it? How exactly
would trying to associate with need_beacon break the law, but not if
!need_beacon?

[1] http://wireless.kernel.org/en/developers/DFS

-- 
Felipe Contreras
