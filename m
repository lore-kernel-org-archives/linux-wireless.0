Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:38730 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1AQNjx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 08:39:53 -0500
Received: by mail-qy0-f181.google.com with SMTP id 12so5743734qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jan 2011 05:39:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295268140.18570.128.camel@wimaxnb.nmp.nokia.com>
References: <1295263943-32110-1-git-send-email-juuso.oikarinen@nokia.com>
	<AANLkTikYPCqQy7ra7RHSA8fE_NR9LgoPhaKori2xhbYa@mail.gmail.com>
	<1295268140.18570.128.camel@wimaxnb.nmp.nokia.com>
Date: Mon, 17 Jan 2011 15:39:52 +0200
Message-ID: <AANLkTimPspj+ABCQ-exGkM-pq1Q7pqDth3GaPimOzyDx@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: Increase scan channel dwell time for passive scans
From: "Kahn, Gery" <geryk@ti.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok. Thank you

On Mon, Jan 17, 2011 at 14:42, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:
> On Mon, 2011-01-17 at 14:33 +0200, ext Kahn, Gery wrote:
>> Does it worth to have different value for 5GHz?
>>
>
> I guess the 100ms value benefits 2.4GHz passive scanning as well, does
> it not? In 2.4GHz band there are usually very few channels passive
> scanned (mostly channels 12 and 13 in the 00 region) so the cost of this
> increased wait time is quite little.
>
> -Juuso
>
>> On Mon, Jan 17, 2011 at 13:32,  <juuso.oikarinen@nokia.com> wrote:
>> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
>> >
>> > The passive scan channel dwell time currently used is 30ms-60ms. A typical
>> > beacon interval for AP's is 100ms. This leads to a ~30% worst-case probability
>> > of finding an AP via passive scanning.
>> >
>> > For 5GHz bands for DFS frequencies passive scanning is the only scanning
>> > option. Hence for these, the probability of finding an AP is very low.
>> >
>> > To fix this, increase the passive channel scan dwell times (also the early
>> > leave value, as 5GHz channels are still typically very silent.) Use a value
>> > of 100ms, because that covers most typical AP configurations.
>> >
>> > Based on testing the probability of finding an AP (102.4ms beacon interval) on
>> > a single scan round are as follows (based on 100 iterations):
>> >
>> > dwell min/max (ms)   | probability
>> > ---------------------+------------
>> > 30/60                | 35%
>> > 60/60                | 56%
>> > 80/80                | 77%
>> > 100/100              | 100%
>> >
>> > Total scan times now and after the change:
>> >
>> > Region | Before (s) | After (s)
>> > -------+------------+----------
>> > 00     | 0.77       | 1.48
>> > FI     | 0.95       | 2.01
>> > US     | 0.91       | 1.76
>> >
>> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
>> > ---
>
>
