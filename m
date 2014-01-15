Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:49181 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaAOQFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 11:05:35 -0500
Received: by mail-la0-f51.google.com with SMTP id c6so1579239lan.38
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 08:05:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389792228.4338.7.camel@jlt4.sipsolutions.net>
References: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
	<1389720570-2430-2-git-send-email-janusz.dziedzic@tieto.com>
	<1389792228.4338.7.camel@jlt4.sipsolutions.net>
Date: Wed, 15 Jan 2014 17:05:31 +0100
Message-ID: <CALhHN=rpWARWuq4TUj2ZRnwUfRZzfs5=TLxj+7s9yaC36U7EOQ@mail.gmail.com> (sfid-20140115_170538_375579_2091110B)
Subject: Re: [RFC 1/5] cfg80211: regulatory rules, fix bw checking
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 January 2014 14:23, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2014-01-14 at 18:29 +0100, Janusz Dziedzic wrote:
>> Allow BW cross over REG_RULES if rules continous.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>> ---
>> I am not sure about rule_intersect() here ...
>
> I'm not sure about the whole thing ...
>
> We did discuss something like this previously (and see our todo list on
> the wiki), but this isn't just some arbitrary internal change, it
> completely changes the interpretation of the regulatory database.
>

We need this because of such split DFS REG_RULE for ETSI:

-       (5250 - 5330 @ 80), (N/A, 20), DFS
-       (5490 - 5710 @ 80), (N/A, 27), DFS
+       (5250 - 5330 @ 80), (N/A, 20), (60), DFS
+       (5490 - 5590 @ 80), (N/A, 27), (60), DFS
+       (5590 - 5650 @ 80), (N/A, 27), (600), DFS   // here different
CAC time but still 80MHz should be available
+       (5650 - 5710 @ 80), (N/A, 27), (60), DFS

In the future could be also usefull for 160MHz:
        (5170 - 5250 @ 160), (N/A, 20)
        (5250 - 5330 @ 160), (N/A, 20), DFS

eg. using channels 36 - 64 @ 160MHz (with current code this is not
possible, due to BW check per single rule)
I am not sure there is a card with 160MHz support on the market today,
but who knows?

We can implement CAC time as hardcoded (already send such patches some
time ago) one but seems this is close connected with regulatory
configuration and seems like good idea put this in regulatory db.

> At a minimum, that means you need a big commit log discussing the impact
> of the changes etc.
>
Because of that I send this RFC, I wasn't sure about all possible
problems with that.
I hope Luis could help here.

BR
Janusz
