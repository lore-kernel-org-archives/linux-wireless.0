Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:33823 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbbCRKLX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 06:11:23 -0400
Received: by igbue6 with SMTP id ue6so70222954igb.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2015 03:11:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1426671981.3001.12.camel@sipsolutions.net>
References: <1426615118-17516-1-git-send-email-emmanuel.grumbach@intel.com>
	<CAB3XZEd7cQwKm_yLztzeTB0S_-uEp4FwzDUV1O8cG6mNtkiY_A@mail.gmail.com>
	<1426671981.3001.12.camel@sipsolutions.net>
Date: Wed, 18 Mar 2015 12:11:22 +0200
Message-ID: <CAB3XZEdJTjRS9tek_KnR9t_HT5+AHjvcjKuBavY2KSrHj9jLkw@mail.gmail.com> (sfid-20150318_111126_666590_EAB7ACA4)
Subject: Re: [PATCH] mac80211: stop scan before connection
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	David Spinadel <david.spinadel@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 18, 2015 at 11:46 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2015-03-18 at 11:36 +0200, Eliad Peller wrote:
>> On Tue, Mar 17, 2015 at 7:58 PM, Emmanuel Grumbach
>> <emmanuel.grumbach@intel.com> wrote:
>> > From: David Spinadel <david.spinadel@intel.com>
>> >
>> > Stop scan before authentication or association to make sure
>> > that nothing interferes with connection flow.
>> >
>> this makes sense
>>
>> > Currently mac80211 defers RX auth and assoc packets (among other ones)
>> > until after the scan is complete, so auth during scan is likely to fail
>> > if scan took too much time.
>> >
>> but i don't think deferring the frame handling makes sense in case of
>> hw_scan (there was a similar case with BA request handling).
>> i should have such (one-liner) patch pending somewhere...
>
> We did consider that, but ultimately I think it's not desirable.
>
> The aggregation case is different, but during auth/assoc the relevant
> frames cannot be buffered by the AP. So unless you have a hardware
> mechanism that makes the device not continue the scan for say 30-50ms
> after the auth/assoc req frame went out, the connection process will be
> very unreliable.
>
i'm not sure. the AP will probably have some retransmissions, so the
station should have good chances to get the frames (assuming the
hardware will give this interface some airtime during the scan).

> So in a sense you could say deferring the handling doesn't make sense,
> but I'd still argue you shouldn't start this process while you're in the
> middle of scanning, hence this patch.
>
i agree the patch makes sense anyway, i just noted that mac80211
behavior seems wrong.
you should avoid scanning while connecting in first place, not defer
the handling.

btw, note that both this patch and ieee80211_iface_work() don't count
for the sched scan case, which is basically the same.

> We may have to do more exclusions (e.g. don't start a scan while
> authenticating or associating) here though, and ultimately not
> *processing* the frames will be irrelevant as they shouldn't be coming
> in anyway.
that's true for auth/assoc frames. but some other frames (e.g. deauth)
can come anytime, and i don't see why we should defer processing in
this case.

Eliad.
