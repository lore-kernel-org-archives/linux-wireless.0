Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:43123 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751380AbeEVOuq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 10:50:46 -0400
Received: by mail-oi0-f68.google.com with SMTP id p62-v6so16455334oie.10
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2018 07:50:46 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: Fix support for flushing old scan results
To: Johannes Berg <johannes@sipsolutions.net>,
        Tim Kourt <tim.a.kourt@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
References: <20180511164835.40161-1-tim.a.kourt@linux.intel.com>
 <1526631206.3805.1.camel@sipsolutions.net>
 <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com>
 <1526976774.6787.7.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <00d912c8-ecf1-8dea-fc54-c73c73f01afb@gmail.com> (sfid-20180522_165053_005088_EDFEE6D7)
Date: Tue, 22 May 2018 09:50:44 -0500
MIME-Version: 1.0
In-Reply-To: <1526976774.6787.7.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 05/22/2018 03:12 AM, Johannes Berg wrote:
> Hi Denis,
> 
>> Just FYI, there's definitely something funny with the scanning code:
>>
>> denkenz@iwd-test ~ $ sudo iw dev wlp2s0 scan flush
>> BSS 10:c3:7b:54:74:d4(on wlp2s0)
>> 	last seen: 274.815s [boottime]
>> 	freq: 5765
>> 	beacon interval: 100 TUs
>> 	signal: -35.00 dBm
>> 	last seen: 349 ms ago
>> 	Information elements from Probe Response frame:
>> 	SSID: \x00\x00\x00\x00\x00\x00\x00\x00\x00
> 
> This is already rather strange to start with. Can you provide a sniffer
> capture of this situation?

Will do

> 
> Thing is - the all-zero-bytes there points to using hidden SSID with a
> length of 9 characters, BUT
>   * "myssid" is just 6 characters long - or did you edit that?

Good eyes!  Yes this was edited to protect the innocent neighbors ;)

>   * normally the zeroed-out SSID isn't transmitted in a *probe response*
>     but only in beacons

Exactly.  That's what makes this really weird.

Regards,
-Denis
