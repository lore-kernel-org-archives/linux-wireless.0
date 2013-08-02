Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:39548 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3HBLwa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 07:52:30 -0400
Received: by mail-bk0-f44.google.com with SMTP id mz10so171617bkb.3
        for <linux-wireless@vger.kernel.org>; Fri, 02 Aug 2013 04:52:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375442751.18144.7.camel@jlt4.sipsolutions.net>
References: <1375087158-22077-1-git-send-email-michal.kazior@tieto.com>
	<1375087158-22077-2-git-send-email-michal.kazior@tieto.com>
	<1375342845.8608.8.camel@jlt4.sipsolutions.net>
	<CA+BoTQm+rWRRpp6XQ_-YHMBfH0Q4ecZ3z-6TV3cvFZ=8uXWsQA@mail.gmail.com>
	<1375442751.18144.7.camel@jlt4.sipsolutions.net>
Date: Fri, 2 Aug 2013 13:52:28 +0200
Message-ID: <CA+BoTQ=XNeYL1KLGQ4gRCZ03a9XsAWde4O7_T-dqKndLLKeX_g@mail.gmail.com> (sfid-20130802_135233_824040_3E83B332)
Subject: Re: [RFC 1/3] nl/cfg80211: add chan_time for scan request
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 August 2013 13:25, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2013-08-01 at 11:14 +0200, Michal Kazior wrote:
>
>> > This seems a bit iffy - you don't differentiate between active/passive
>> > scans?
>>
>> Is there a reason this should be differentiated?
>
> Well they don't usually have the same timing, passive channel dwell time
> usually needs to be longer than on active channels.
>
>> > This also interferes a bit with some other scan optimisations that could
>> > be done at a low firmware level, so I think we should be careful and
>> > actually say that this is really more intended for measurement use cases
>> > and not for normal scans?
>> >
>> > Or maybe we should have a separate measurement command with similar
>> > semantics? This all doesn't seem very clear to me yet :)
>>
>> Motivation behind this patchset is to simplify ACS implementation and
>> depend on scan. This also allows easier fallback from survey-based ACS
>> to BSS-based one.
>
> Sure, I understand.
>
>> Other use cases are a side-effect so perhaps clarifying the intent in
>> the docs is enough.
>
> I'm just saying that this is a fundamentally different usage than actual
> scanning. Let's say for the sake of the argument I find a way to scan
> channels quicker and implement that in my device (hw_scan). I don't
> think this is too far-fetched, imagine I have an 80MHz capable device
> and can send probe request 4x transmissions on all the subchannels, if
> somehow I manage to separate the receive then I could scan 4x as
> quickly. I don't think this particular thing is possible but I could
> imagine scan optimisations like it.
>
> Now this comes along - and suddenly the API requires that you stay on
> each specified channel for the given period of time. Any such
> "non-traditional" scan optimisations would have to be given up, so in a
> sense this fundamentally alters the semantics of the scan primitive,
> where before it was "give me the list of networks (with these SSIDs) on
> these channels" it now becomes "go to each channel, stay there for this
> amount of time and ..."
>
> That's what I'm worried about - the implicit semantic change here.

I think I understand your point now.

I'm thinking of using series of passive scans for ACS now, so perhaps
the whole chan_time stuff is unnecessary. What are your thoughts about
it?


Pozdrawiam / Best regards,
Michał Kazior.
