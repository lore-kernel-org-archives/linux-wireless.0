Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:51127 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727683AbeIJQIu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 12:08:50 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH RFC v3 3/4] cfg80211: Add airtime statistics and settings
In-Reply-To: <1536567800.3224.39.camel@sipsolutions.net>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1> <153635897088.14170.10601367738164730253.stgit@alrua-x1> <1536567800.3224.39.camel@sipsolutions.net>
Date: Mon, 10 Sep 2018 13:15:16 +0200
Message-ID: <87efe1li2j.fsf@toke.dk> (sfid-20180910_131520_988814_44F3D165)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2018-09-08 at 00:22 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> This adds airtime statistics to the cfg80211 station dump, and also adds=
 a new
>> parameter to set the airtime weight of each station. The latter allows u=
serspace
>> to implement policies for different stations by varying their weights.
>
> Maybe some documentation on the weights - both for other implementers as
> well as users - would be useful.
>
>> + * @NL80211_STA_INFO_AIRTIME_WEIGHT: current airtime weight for station
>> + *      (u16, usec)
>
> how could the weight be in usec? copy/paste issue?

Well, technically it is a usec value (the amount of airtime added to the
deficit each round); but I agree that it shouldn't be documented as such
if we want freedom to change the mechanism later...

-Toke
