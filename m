Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54048 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab0KLCxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 21:53:24 -0500
Received: by iwn10 with SMTP id 10so2922498iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 18:53:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTik9w0_ZJJ273m7B30H4mUcaVeGVirOWAaMuPO-s@mail.gmail.com>
References: <1289528843-21982-1-git-send-email-lrodriguez@atheros.com> <AANLkTik9w0_ZJJ273m7B30H4mUcaVeGVirOWAaMuPO-s@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 11 Nov 2010 18:53:03 -0800
Message-ID: <AANLkTimCxqmpxfNoxAVtHhLx5Lkx+HPcA8iwacOYLYHg@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: Fix regulatory bug with multiple cards with a
 delayed CRDA response
To: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>
Cc: mark@moxienet.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 6:45 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Nov 11, 2010 at 6:27 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> When two cards are connected with the same regulatory domain
>> if CRDA had a delayed response then cfg80211's own set regulatory
>> domain would still be the world regulatory domain. There was a bug
>> on cfg80211's ignore_request() when analyzing incoming driver
>> regulatory hints as it was only checking against the currently
>> set cfg80211 regulatory domain and not for any other new
>> pending requests. This is easily fixed by also checking against
>> the pending request.
>>
>> Without this fix the second card would end up with an intersected
>> regulatory domain and now allow it to use the channels it really
>> is designed for.
>>
>> This was reproduced and tested against mac80211_hwsim using this
>> CRDA delayer:
>>
>>        #!/bin/bash
>>        echo $COUNTRY >> /tmp/log
>>        sleep 2
>>        /sbin/crda.orig
>>
>> And this regulatory test:
>>
>>        modprobe mac80211_hwsim regtest=2
>>
>> This patch has fixes for cfg80211 all the way back.
>>
>> Reported-by: Mark Mentovai <mark@moxienet.com>
>> Cc: stable@kernel.org
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>
> Hrm,
>
> modprobe mac80211_hwsim regtest=3
>
> Does the similar test but using two different regulatory domains,
> however this ends up slapping an intersection over to both. Going to
> think this through a bit more.

Actually this highlights an issue in design that I originally
addressed in my code by setting up a queue. Without a queue for all
pending requests we have to drop all pending requests that differ. The
extra race here happens because of the new delay. Without the delay
things work as expected, each card would get two separate regulatory
domains and with a core intersected for cards that have no hints. With
the delay we end up getting an intersection but since the cfg80211's
regulatory domain hasn't yet been set and the previous request hasn't
yet been processed by differ we tell cfg80211 to intersect.

I'd like to keep this simple too though, but without a queue not sure
how other than rejecting the new requests under the assumption a
timeout was reached and no CRDA was present. This is of course
incorrect logic given that you can just install CRDA later.

Anyway, that's the issue, the patch is still correct as without the
delay it does not introduce a regression. There is still a lingering
bug for when two cards issue separate regulatory domains and the
pending request is not yet processed. What do do there.

  Luis
