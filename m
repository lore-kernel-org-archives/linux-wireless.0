Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40670 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755104AbdCJPiW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 10:38:22 -0500
Message-ID: <58C2CABA.6070007@candelatech.com> (sfid-20170310_163826_271625_2EEBBB10)
Date: Fri, 10 Mar 2017 07:48:10 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rate mask resulting in no usable rates - WARN_ON
References: <1488933811.4723.1.camel@sipsolutions.net>   <a1cd3a56-0453-7675-6895-9521a412a9cd@candelatech.com> <1488955036.31187.1.camel@sipsolutions.net>
In-Reply-To: <1488955036.31187.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2017 10:37 PM, Johannes Berg wrote:
>
>>> Is anyone - other than ChromeOS, which sets it just after
>>> association - actually using this?
>>
>> I know several people who use this and depend on it being sticky.
>
> Do you know how they use it in more detail?

The goal would be to make a more capable station on a radio act like
something less, typically for testing purposes.  Maybe limit to /a rates, for instance:

They do this before association, though they seem to also do it
after association to work around some bug or another, and API is slightly
different on newer kernels.


802.11 ac station :
iw dev vif0 set bitrates legacy-2.4 legacy-5 6 9 12 18 24 36 48 54 ht-mcs-5 vht-mcs-5 3:9

802.11 n (2.4G):
iw dev vif1 set bitrates legacy-2.4 ht-mcs-2.4 23

802.11 b:
iw dev vif2 set bitrates legacy-2.4 11 legacy-5 ht-mcs-2.4 vht-mcs-5  ( setting 1 , 2 , 5.5 .. is not working)

802.11 g:
iw dev vif3 set bitrates legacy-2.4 54 legacy-5 ht-mcs-2.4 vht-mcs-5  (setting 1 2 6 ... is not working)

802.11 a:
iw dev vif0_7962 set bitrates legacy-2.4 legacy-5 6 9 12 18 24 36 48 54 ht-mcs-5 vht-mcs-5

>
>> For that matter, I think LEDE and probably OpenWRT uses 'iw' quite a
>> bit to affect rates.
>
> That seems odd, but ok.
>
> Either way, if people do rely on it being sticky then I'll do the next
> best thing and just clear the mask when detecting a situation where it
> would result in no usable rates, as well as rejecting it when it's
> already known that it would do so.

I just briefly looked at related code in LEDE while debugging something
else, so I might be confused about it.  In particular, if you try to set
up a VHT40 IBSS network, then it ends up configuring an HT40 one since there
is no valid API (that I know of) to configure an IBSS station for VHT40 (VHT80 works fine).

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
