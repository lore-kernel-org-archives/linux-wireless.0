Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:11100 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYISIDD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 04:03:03 -0400
Received: by fk-out-0910.google.com with SMTP id 18so298072fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 01:03:02 -0700 (PDT)
Message-ID: <1ba2fa240809190103i69c66978he4762fd350ab2e5d@mail.gmail.com> (sfid-20080919_100312_773600_994670A4)
Date: Fri, 19 Sep 2008 11:03:02 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: technology preview: scan with cfg80211
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Dan Williams" <dcbw@redhat.com>
In-Reply-To: <1221795715.10419.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1221794329.10419.9.camel@johannes.berg>
	 <1221795715.10419.15.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 19, 2008 at 6:41 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-09-19 at 05:18 +0200, Johannes Berg wrote:
>> This is totally incomplete:
>>
>> cfg80211 needs to
>>  * actually hash on the BSSID instead of putting things into a list
>>  * provide BSS list functions so mac80211 need not keep track
>>  * allow a "private" area in each scan result with hw-provided size
>>  * handle mesh properly
>>  * provide a way for the hw to limit the number of SSIDs in a scan
Don't understand this requirement?

  * provide a way to limit the number of channels in a scan (for
faster roaming candidate search)

>
>  * provide a function to just pass in the whole beacon/probe response
>   frame and pick it apart itself
>  * handle aging
>  * provide a wext "set scan" hook that creates a request and passes it
>   off to ->scan(), provide wext "get scan" hook
>  * parse the supported rates into a bitmap like mac80211 does now, based
>   on the bitrate information the wiphy provides
>
>> in mac80211, we need to
>>  * pass the scan request to the hardware offload
>>  * handle multiple SSIDs in a scan
>>  * use BSS list stuff cfg80211 needs to provide
>>  * handle active/passive properly
>
>  * use all those helpers I mentioned above
>
> Also, we need to think about
>  * how fullmac stuff can integrate, can it provide this IE-based
>   information, and if not, is it feasible to just synthesize it?
>  * whether this should really be per wiphy as it is now, or somehow more
>   per netdev, or not related to a netdev at all...
>
> johannes
>
