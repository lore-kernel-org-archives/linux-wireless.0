Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0057.outbound.protection.outlook.com ([104.47.40.57]:13450
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932674AbdKFTuu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 14:50:50 -0500
Subject: Re: [PATCH] mac80211: Update last_ack status for all except probing
 frames
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
References: <1509409746-26592-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1509964164.2669.0.camel@sipsolutions.net>
 <8bb232d231884f9595c81f945a5eef4f@NALASEXR01H.na.qualcomm.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <49241af7-a50f-5758-0c7e-77f2fae5d93d@quantenna.com> (sfid-20171106_205053_948369_19DC1E9A)
Date: Mon, 6 Nov 2017 11:50:40 -0800
MIME-Version: 1.0
In-Reply-To: <8bb232d231884f9595c81f945a5eef4f@NALASEXR01H.na.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/06/2017 09:44 AM, Rajkumar Manoharan wrote:
>> On Mon, 2017-10-30 at 17:29 -0700, Rajkumar Manoharan wrote:
>>> Update last_ack status for all except station probing frames (i.e null
>>> data). Otherwise the station inactivity duration is cleared whenever
>>> AP is checking presence of idle stations by sending null data frame
>>> for every inactive threshold (ap_max_inactivity).
>>
>> You make it sound like this is a problem, but don't explain why it would be? I
>> don't really see it anyway.
>>
> For steering an idle station from one BSS to another, the steering application
> has to know the actual station idle period. But if the idle period is cleared by
> ap_max_inactivity, the steering application cannot steer the station even though
> the station is not sending or receiving any data or mgmt. frame.
> 
> Though keeping longer idle threshold (ap_max_inactivity) than steering application
> limit may help to identify idle station, it will differ removing the stations that left BSS.
> 
> -Rajkumar
> 

Hi Rajkumar, this will not help in all the cases as some drivers may 
choose to implement "inactivity" logic in firmware and firmware will 
send probing frames itself if required, resetting inactivity period. 
Besides, at this level we do not know who sent NULL frames and for which 
purpose, it doesn't look like a good idea to just ignore it.

I think that for what it was supposed to be, inactivity_ms works as 
expected and it can be used to identify "dead" stations. What you 
probably need is something different, called for example "rx_idle_time" 
that will keep track of how long STA itself did not send any frames 
(ignoring ACKs).
