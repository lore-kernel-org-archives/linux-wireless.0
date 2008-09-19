Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:7597 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYISLpE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 07:45:04 -0400
Received: by fg-out-1718.google.com with SMTP id 19so538533fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 04:45:03 -0700 (PDT)
Message-ID: <1ba2fa240809190445v370ee80dk316d3b474db86132@mail.gmail.com> (sfid-20080919_134513_465236_A03C9782)
Date: Fri, 19 Sep 2008 14:45:03 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: technology preview: scan with cfg80211
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Dan Williams" <dcbw@redhat.com>
In-Reply-To: <1221820966.10419.81.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1221794329.10419.9.camel@johannes.berg>
	 <1221795715.10419.15.camel@johannes.berg>
	 <1ba2fa240809190103i69c66978he4762fd350ab2e5d@mail.gmail.com>
	 <1221814565.10419.19.camel@johannes.berg>
	 <1ba2fa240809190337ke17d2aanaca6d0f194b11f03@mail.gmail.com>
	 <1221820966.10419.81.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 19, 2008 at 1:42 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-09-19 at 13:37 +0300, Tomas Winkler wrote:
>
>> > Hey, unfair! ;) I did leave a lot of TODOs but this wasn't one of them.
>> > You can provide a channel list and it'll scan only those (except hw scan
>> > right now but that'll be fixed once we pass the scan request struct
>> > through)
>>
>> Agree, this would be the correct approach.
>
> Yeah, but I pulled this together in about five hours :)
>
> Wrt. the SSIDs, how many SSIDs do you think we should allow scanning for
> at the same time? Three? Four? Five? I was thinking something like that,
> sending out more probe requests is probably not too great an idea.

iwlwifi  HW is able to issue 10 probes per channel in a single scan.
Empirically this probably maximum of networks/SSIDs an average user
will be interested in.   But we can go with less for example 5  probes
per scan if we for example round robin SSID list in background scans.
This number are based on user feedback we've been collecting for few
years. For example 2 years ago it was increased from 5 to 10 according
to user feedback.
 As I understand the second approach is better as it lowers collisions
on the air and is more flexible as it's not dependent on HW limitation
(10 in iwlwifi) but requires more book keeping.

> guess we would set the default to something we decide on in mac80211's
> alloc_hw and the driver gets to overwrite it if it has hw scan offload.

Sounds good.

Tomas
