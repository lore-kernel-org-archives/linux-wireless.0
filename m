Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:56489 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab3HBM41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 08:56:27 -0400
Received: by mail-we0-f173.google.com with SMTP id x55so491535wes.32
        for <linux-wireless@vger.kernel.org>; Fri, 02 Aug 2013 05:56:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACA4iOrZSARKFVFx1E2QPyH=xZzQp+VoyPu_tuFWgBR3tQwOmw@mail.gmail.com>
References: <1375087158-22077-1-git-send-email-michal.kazior@tieto.com>
	<1375087158-22077-2-git-send-email-michal.kazior@tieto.com>
	<1375342845.8608.8.camel@jlt4.sipsolutions.net>
	<CA+BoTQm+rWRRpp6XQ_-YHMBfH0Q4ecZ3z-6TV3cvFZ=8uXWsQA@mail.gmail.com>
	<1375442751.18144.7.camel@jlt4.sipsolutions.net>
	<CACA4iOrZSARKFVFx1E2QPyH=xZzQp+VoyPu_tuFWgBR3tQwOmw@mail.gmail.com>
Date: Fri, 2 Aug 2013 18:26:26 +0530
Message-ID: <CACA4iOrGGoZVneOgZvY2jf=SvcC3ta5gYVLThG7qUbzNbS+Zkw@mail.gmail.com> (sfid-20130802_145631_521456_9671B86D)
Subject: Re: [RFC 1/3] nl/cfg80211: add chan_time for scan request
From: Sunil Dutt <usdutt@gmail.com>
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes and Michal ,
In this context I would also like to mention that there are also some
use cases ( Ex WiFi Positioning) ,  where good performance shall
result from using signals from as many Access Points as possible, a
fixed dwell / chan time in the host driver shall result in the poor
discovery efficiency of the Access Points,negatively impacting WiFi
positioning performance.

I would say such applications shall benefit by configuring a chan (dwell)_time.
Also,an attribute corresponding to the mode of the scan ( active /
passive ) , along with chan_time would benefit such applications with
more configurable options. Isn't it ?
Please correct me .

Regards,
Sunil

On Fri, Aug 2, 2013 at 6:00 PM, Sunil Dutt <usdutt@gmail.com> wrote:
> Hi Johannes and Michal ,
> In this context I would also like to mention that there are also some use
> cases ( Ex WiFi Positioning) ,  where good performance shall result from
> using signals from as many Access Points as possible, a fixed dwell / chan
> time in the host driver shall result in the poor discovery efficiency of the
> Access Points,negatively impacting WiFi positioning performance.
>
> I would say such applications shall benefit by configuring a chan
> (dwell)_time.
> Also,an attribute corresponding to the mode of the scan ( active / passive )
> , along with chan_time would benefit such applications with more
> configurable options. Isn't it ?
> Please correct me .
>
> Regards,
> Sunil
>
>
>
>
> On Fri, Aug 2, 2013 at 4:55 PM, Johannes Berg <johannes@sipsolutions.net>
> wrote:
>>
>> On Thu, 2013-08-01 at 11:14 +0200, Michal Kazior wrote:
>>
>> > > This seems a bit iffy - you don't differentiate between active/passive
>> > > scans?
>> >
>> > Is there a reason this should be differentiated?
>>
>> Well they don't usually have the same timing, passive channel dwell time
>> usually needs to be longer than on active channels.
>>
>> > > This also interferes a bit with some other scan optimisations that
>> > > could
>> > > be done at a low firmware level, so I think we should be careful and
>> > > actually say that this is really more intended for measurement use
>> > > cases
>> > > and not for normal scans?
>> > >
>> > > Or maybe we should have a separate measurement command with similar
>> > > semantics? This all doesn't seem very clear to me yet :)
>> >
>> > Motivation behind this patchset is to simplify ACS implementation and
>> > depend on scan. This also allows easier fallback from survey-based ACS
>> > to BSS-based one.
>>
>> Sure, I understand.
>>
>> > Other use cases are a side-effect so perhaps clarifying the intent in
>> > the docs is enough.
>>
>> I'm just saying that this is a fundamentally different usage than actual
>> scanning. Let's say for the sake of the argument I find a way to scan
>> channels quicker and implement that in my device (hw_scan). I don't
>> think this is too far-fetched, imagine I have an 80MHz capable device
>> and can send probe request 4x transmissions on all the subchannels, if
>> somehow I manage to separate the receive then I could scan 4x as
>> quickly. I don't think this particular thing is possible but I could
>> imagine scan optimisations like it.
>>
>> Now this comes along - and suddenly the API requires that you stay on
>> each specified channel for the given period of time. Any such
>> "non-traditional" scan optimisations would have to be given up, so in a
>> sense this fundamentally alters the semantics of the scan primitive,
>> where before it was "give me the list of networks (with these SSIDs) on
>> these channels" it now becomes "go to each channel, stay there for this
>> amount of time and ..."
>>
>> That's what I'm worried about - the implicit semantic change here.
>>
>> johannes
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
