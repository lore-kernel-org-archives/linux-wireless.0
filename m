Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:26868 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYISKhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 06:37:52 -0400
Received: by fk-out-0910.google.com with SMTP id 18so350424fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 03:37:50 -0700 (PDT)
Message-ID: <1ba2fa240809190337ke17d2aanaca6d0f194b11f03@mail.gmail.com> (sfid-20080919_123755_774366_D5A9138E)
Date: Fri, 19 Sep 2008 13:37:50 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: technology preview: scan with cfg80211
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Dan Williams" <dcbw@redhat.com>
In-Reply-To: <1221814565.10419.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1221794329.10419.9.camel@johannes.berg>
	 <1221795715.10419.15.camel@johannes.berg>
	 <1ba2fa240809190103i69c66978he4762fd350ab2e5d@mail.gmail.com>
	 <1221814565.10419.19.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 19, 2008 at 11:56 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-09-19 at 11:03 +0300, Tomas Winkler wrote:
>> On Fri, Sep 19, 2008 at 6:41 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Fri, 2008-09-19 at 05:18 +0200, Johannes Berg wrote:
>> >> This is totally incomplete:
>> >>
>> >> cfg80211 needs to
>> >>  * actually hash on the BSSID instead of putting things into a list
>> >>  * provide BSS list functions so mac80211 need not keep track
>> >>  * allow a "private" area in each scan result with hw-provided size
>> >>  * handle mesh properly
>> >>  * provide a way for the hw to limit the number of SSIDs in a scan
>
>> Don't understand this requirement?
>
> Limiting the number of SSIDs? Well I don't want to have userspace
> request an active scan for like 100 SSIDs, which currently _is_ possible
> (mac80211 will reject anything but 1 right now though). Hence, I want to
> have a "max probes" or something like that in the wiphy structure that
> we can use (a) tell userspace how many we support and (b) limit the
> number appropriately.
>
>>   * provide a way to limit the number of channels in a scan (for
>> faster roaming candidate search)
>
> Hey, unfair! ;) I did leave a lot of TODOs but this wasn't one of them.
> You can provide a channel list and it'll scan only those (except hw scan
> right now but that'll be fixed once we pass the scan request struct
> through)

Agree, this would be the correct approach.
Tomas
