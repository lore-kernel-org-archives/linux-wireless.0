Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33902 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab1LYKQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Dec 2011 05:16:47 -0500
Received: by vbbfc26 with SMTP id fc26so8173164vbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 25 Dec 2011 02:16:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324801334.2182.403.camel@cumari>
References: <1324462262-10277-1-git-send-email-eyal@wizery.com>
 <1324480244.3401.6.camel@jlt3.sipsolutions.net> <1324629966.2182.317.camel@cumari>
 <CAF8O4-wpjuV6j-beXn8d7bNA7jvSeCXMhV=kXDHNYKPgxQUbyw@mail.gmail.com>
 <CAF8O4-zLgwyUhfnZObooN=VLkkVb7QzTS+08VULJSGtGaZ3g8w@mail.gmail.com> <1324801334.2182.403.camel@cumari>
From: Eyal Shapira <eyal@wizery.com>
Date: Sun, 25 Dec 2011 12:16:26 +0200
Message-ID: <CAF8O4-wjiNxWb7HcPaQm6dQ_fBGdkLC01OEZLbi4tqgQsf4QzQ@mail.gmail.com> (sfid-20111225_111709_249270_EA79AB74)
Subject: Re: [PATCH v2 0/2] report stop sched scan when actually done
To: Luciano Coelho <coelho@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 25, 2011 at 10:22 AM, Luciano Coelho <coelho@ti.com> wrote:
> On Sun, 2011-12-25 at 01:49 +0200, Eyal Shapira wrote:
>> On Sun, Dec 25, 2011 at 1:48 AM, Eyal Shapira <eyal@wizery.com> wrote:
>> > On Fri, Dec 23, 2011 at 10:46 AM, Luciano Coelho <coelho@ti.com> wrote:
>> >>
>> >> Could the code be changed so that we delay the STOP_SCHED_SCAN command
>> >> completion instead? Then userspace can rely on that (as it should
>> >> anyway, because the command can fail) instead of having to wait for the
>> >> stopped event (which is a change in the API).
>> >>
>> > Sounds like this would be the best way to go and I'll do that. So no need
>> > for these patches. I misunderstood the STOP_SCHED_SCAN NL API to be async (due to the NL events) but it can and should be synchronous AFAIU.
>> > (and might sleep / block).
>
> Yep, this sounds better.
>
>> > The only mac80211 change I'd be glad to add is to make sched_scan_stop op return
>> > a value so errors can be reported back like it's being done in the sched_scan_stop cfg80211 op
>
> Returning errors from driver errors is not exactly the same things as we
> already do now.  If sched_scan_stop in cfg80211 fails it is either
> because the userspace screwed up (and sent a stop when it was not
> running) or because someone else already stopped the scan.  In both
> cases, it is okay, because the userspace can just ignore it and be sure
> the scan is stopped.
>
> Now, if the driver fails for some other reason and we return the error
> to the userspace, how should it react? In this case it would mean that
> the scan is still running, but should the userspace try again? Or
> ignore? Hard to know what to do.  (This was Johannes's original opinion
> about returning errors there, IIRC).
>
I was referring to sched_scan_stop op in cfg80211_ops which can return
an int. This is used by ath6kl for example in
ath6kl_cfg80211_sscan_stop() to return -EIO
in case there's an error in stopping so userspace might get that.
What's the difference between this and having our driver return an error ?

Since there might be real errors which would prevent us from stopping
, isn't it better
to report to userspace (and let it decide what to do - retry, ignore,
exit program, panic ,....)
other than just silently ignore it and let the userspace think that it
succeeded ?

> --
> Cheers,
> Luca.
>
