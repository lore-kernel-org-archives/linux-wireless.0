Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52379 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab1LXXuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Dec 2011 18:50:04 -0500
Received: by vbbfc26 with SMTP id fc26so8066691vbb.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Dec 2011 15:50:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAF8O4-wpjuV6j-beXn8d7bNA7jvSeCXMhV=kXDHNYKPgxQUbyw@mail.gmail.com>
References: <1324462262-10277-1-git-send-email-eyal@wizery.com>
 <1324480244.3401.6.camel@jlt3.sipsolutions.net> <1324629966.2182.317.camel@cumari>
 <CAF8O4-wpjuV6j-beXn8d7bNA7jvSeCXMhV=kXDHNYKPgxQUbyw@mail.gmail.com>
From: Eyal Shapira <eyal@wizery.com>
Date: Sun, 25 Dec 2011 01:49:42 +0200
Message-ID: <CAF8O4-zLgwyUhfnZObooN=VLkkVb7QzTS+08VULJSGtGaZ3g8w@mail.gmail.com> (sfid-20111225_005032_861781_6C6DB4A5)
Subject: Re: [PATCH v2 0/2] report stop sched scan when actually done
To: Luciano Coelho <coelho@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 25, 2011 at 1:48 AM, Eyal Shapira <eyal@wizery.com> wrote:
>
>
>
> On Fri, Dec 23, 2011 at 10:46 AM, Luciano Coelho <coelho@ti.com> wrote:
>>
>> On Wed, 2011-12-21 at 16:10 +0100, Johannes Berg wrote:
>> > On Wed, 2011-12-21 at 12:11 +0200, Eyal Shapira wrote:
>> > > Changes in mac/cfg80211 to notify userspace
>> > > of NL80211_CMD_SCHED_SCAN_STOPPED only when the driver
>> > > actually reported back that it was stopped. Also
>> > > blocks other attempts until we're really done.
>> > >
>> > > This fixes a scenario where stop sched scan
>> > > is issued and immediately afterwards a new sched scan
>> > > is requested (e.g. with other parameters).
>> > > Current state caused a race where the driver started
>> > > stopping the sched scan but didn't finish and got
>> > > another sched scan request which it couldn't handle.
>> >
>> > Luca really needs to take a close look at this, and I think you should
>> > also take a look to see if this kind of API change can be avoided.
>>
>> I had discussed this with Eyal briefly and at first it seemed ok.  But
>> actually I now agree that this is an API change.
>>
>> Looking closer, I see that in the current documentation, there's nothing
>> stating that after sending sched_scan_stop the userspace needs to wait
>> for the stopped event.  It just says that "[this] event is also sent
>> when the %NL80211_CMD_STOP_SCHED_SCAN command is received [...]".
>> Applications may assume that after the stop command completes, it is
>> really stopped, without waiting for the stopped event.
>>
>> Could the code be changed so that we delay the STOP_SCHED_SCAN command
>> completion instead? Then userspace can rely on that (as it should
>> anyway, because the command can fail) instead of having to wait for the
>> stopped event (which is a change in the API).
>>
> Sounds like this would be the best way to go and I'll do that. So no need
> for these patches. I misunderstood the STOP_SCHED_SCAN NL API to be async (due to the NL events) but it can and should be synchronous AFAIU.
> (and might sleep / block).
>
> The only mac80211 change I'd be glad to add is to make sched_scan_stop op return
> a value so errors can be reported back like it's being done in the sched_scan_stop cfg80211 op
>
>> --
>> Cheers,
>> Luca.
>>
>
