Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41613 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbZCTKh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 06:37:27 -0400
Received: by fxm2 with SMTP id 2so846593fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2009 03:37:24 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC PATCH v2 1/4] mac80211: decrease execution of the associated timer
References: <20090314171234.11126.21125.stgit@tikku>
	<20090314171431.11126.51242.stgit@tikku>
	<1237051084.5235.97.camel@johannes.local> <49BBFB78.6070708@nokia.com>
	<87zlfglfa2.fsf@litku.valot.fi>
	<1237542166.5100.137.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 20 Mar 2009 12:37:21 +0200
In-Reply-To: <1237542166.5100.137.camel@johannes.local> (Johannes Berg's message of "Fri\, 20 Mar 2009 10\:42\:46 +0100")
Message-ID: <87vdq4lbtq.fsf@litku.valot.fi> (sfid-20090320_113731_723258_63088C2A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2009-03-20 at 11:22 +0200, Kalle Valo wrote:
>
>> Now I remember what this test was about. In ieee80211_associated()
>> there are two tests: probe request check after an data idle period
>> (currently 60 secs) and beacon loss check for drivers not supporting
>> filtering (2 secs).
>> 
>> The former test has been originally (even before my beacon filter
>> patches) implemented so that the probe request is sent even though we
>> are receiving beacons. mod_timer() is called only for unicast traffic
>> so that the probe request test will trigger when we are still
>> receiving beacons.
>
> Why would we not want to change that? I don't see a reason to send a
> probe request when we're still receiving beacons. It was meant to be
> used when beacons got lost _during_ a data idle period to verify that
> the AP is still there, afaict.

The original (or current) implementation sends probe requests even
when beacons are received or there is unicast traffic going on. My
patches change this so that the probe request is only sent when there
is data idle period (ie. no unicast traffic).

Like we discussed earlier, I think the most optimal solution would be
to send nullfunc frames during data idle periods just to check that the
connection is working bothways.

What should AP do if it receives a nullfunc frame from a station which
is not associated? Send a deauth frame back to the station? It would
be nice to check the association state also during the data idle
period. Sometimes I have noticed that AP might deauthenticate the
station without station noticing it. It would be just perfect if
nullfunc frame would do the assocition also during data idle periods.

>> I'll add a proper comment explaining all this.
>> 
>> Also currently ieee80211_associated() is called every two seconds, we
>> need to fix this in future to avoid waking up cpu needlessly. I don't
>> want to make too intrusive changes right now.
>
> I thought you already did that too :)

Sorry, I did that only for the period when there is data transmission.
To get rid of unncessary wakeups altogether I need to do something
more advanced, like using two timers or something. I haven't thought
that yet.

I'll mention this in the commit logs.

-- 
Kalle Valo
