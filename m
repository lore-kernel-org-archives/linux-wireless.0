Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:36946 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbeEVOsi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 10:48:38 -0400
Received: by mail-ot0-f172.google.com with SMTP id 77-v6so21285764otd.4
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2018 07:48:38 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: Fix support for flushing old scan results
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Tim Kourt <tim.a.kourt@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
References: <20180511164835.40161-1-tim.a.kourt@linux.intel.com>
 <1526631206.3805.1.camel@sipsolutions.net>
 <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com>
 <5AFF2169.4010003@broadcom.com>
 <51c56faf-267d-c204-243a-31fc91976c5e@gmail.com>
 <5B03C5BA.50804@broadcom.com>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <c8f3d9a7-b978-8af8-6594-d0ae66652956@gmail.com> (sfid-20180522_164842_551857_7F70ECC4)
Date: Tue, 22 May 2018 09:48:36 -0500
MIME-Version: 1.0
In-Reply-To: <5B03C5BA.50804@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

>> Are you saying the first result is from the Beacon and the other is from
>> the Probe Response?  Then why are the 'Information elements from Probe
>> Response frame' the way they are?
> 
> Nope. I am not saying that. I am saying that there are two probe 
> requests being sent. One with broadcast ssid, ie. ssid_len == 0, and 
> with ssid 'myssid'. But it is speculation without a sniffer capture.

Ah I see what you mean now.  No, we traced this down to hostapd itself 
and it was receiving a single Probe Request with the ssid set and 
replying to it per spec.  So I'm pretty confident this scenario isn't 
what is happening.  Let me try to get some actual packet captures...

Regards
-Denis
