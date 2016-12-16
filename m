Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:36532 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752116AbcLPMR7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 07:17:59 -0500
Received: by mail-pf0-f181.google.com with SMTP id 189so14468887pfz.3
        for <linux-wireless@vger.kernel.org>; Fri, 16 Dec 2016 04:17:57 -0800 (PST)
Subject: Re: [RFC V3 04/11] nl80211: add driver api for gscan notifications
To: Johannes Berg <johannes@sipsolutions.net>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
 <1481543997-24624-5-git-send-email-arend.vanspriel@broadcom.com>
 <1481646049.20412.43.camel@sipsolutions.net>
 <69ec7e9f-cd46-c46d-140c-0b30343cc0f7@broadcom.com>
 <1481882578.27953.20.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9715e731-efcc-0252-ed7b-5ca67e2c0b5b@broadcom.com> (sfid-20161216_131802_574490_BAD32C55)
Date: Fri, 16 Dec 2016 13:17:52 +0100
MIME-Version: 1.0
In-Reply-To: <1481882578.27953.20.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16-12-2016 11:02, Johannes Berg wrote:
> 
>> Not sure what is meant by "through the buckets".
> 
> TBH, I was handwaving because I don't understand this part of gscan
> well :-)
> 
>> Referring to your
>> remark/question in the "Unversal scan proposal" thread:
>>
>> """
>> I'm much more worried about the "bucket reporting" since that doesn't
>> fit into the current full BSS reporting model at all. What's your
>> suggestion for this?
>> """
>>
>> So this is exactly the dilemma I considered so I decided to stick
>> with the full BSS reporting model for gscan as well merely to get it
>> discussed so glad you brought it up ;-).
> 
> Heh.
> 
> Ok, so I missed that. Somehow I thought hidden in the buckets was a
> partial reporting :-)
> 
>> The problem here is that gscan is a vehicle that serves a number of
>> use-cases. So ignoring hotlists, ePNO, etc. the gscan configuration
>> still hold several notification types:
>>
>> - report after completing M scans capturing N best APs or a
>>   percentage of (M * N).
>> - report after completing a scan include a specific bucket.
>> - report full scan results.
>>
>> The first two notification trigger retrieval of gscan results which
>> are historic, ie. partial scan results for max M scans.
>>
>> As said earlier the universal scan proposal has some similarities to
>> gscan. Guess you share that as you are using the term "bucket
>> reporting" in that discussion ;-). The historic results are needed
>> for location (if I am not mistaken) so the full BSS reporting model
>> does not fit that. Question is what particular attribute in the
>> historic results is needed for location (suspecting only rssi and
>> possibly the timestamp, but would like to see that confirmed). I was
>> thinking about have historic storage in cfg80211 so we do not need a
>> per-driver solution.
> 
> Ok, now I'm starting to understand this better, I guess.
> 
> As far as I can tell from our code, for cached results we're reporting
> the following data:
> 
>  * some flags
>  * a scan ID
>  * and for each AP:
>    * RSSI
>    * timestamp
>    * channel
>    * BSSID
>    * SSID (which internally we even have a separate table for and each
>            AP just has an index to it, to save memory I guess)
>    * beacon period
>    * capability field
> 
> No IEs and similar things like differentiating probe response/beacon,
> so we can't use the full reporting for this.
> 
> I have no problem introducing a common storage for this, if necessary
> with some fields/nl attributes being optional, but I suspect this is
> actually a necessary part of gscan, otherwise you're not able to report
> all the necessary data?

If you just look at the gscan api in wifihal then yes. I was just
wondering whether "all the necessary data" really comprises all these
from a use-case perspective. As an example the api also has rtt fields,
but both brcm and intel solutions do not report that.

Regards,
Arend
