Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37826 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729420AbeHNPAE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 11:00:04 -0400
Subject: Re: [PATCH] mac80211: allow station search on AP/VLANs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <1532931620-3161-1-git-send-email-mpubbise@codeaurora.org>
 <1534246103.3547.23.camel@sipsolutions.net>
 <1f50369a-61ae-cd7b-1300-78392852ebb5@codeaurora.org>
 <1534247624.3547.28.camel@sipsolutions.net>
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-ID: <3dda8067-6a9c-4d3f-5332-0cb6f9904d6a@codeaurora.org> (sfid-20180814_141315_109582_074ADE94)
Date: Tue, 14 Aug 2018 17:43:03 +0530
MIME-Version: 1.0
In-Reply-To: <1534247624.3547.28.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 8/14/2018 5:23 PM, Johannes Berg wrote:
> On Tue, 2018-08-14 at 17:22 +0530, Manikanta Pubbisetty wrote:
>> On 8/14/2018 4:58 PM, Johannes Berg wrote:
>>
>>> On Mon, 2018-07-30 at 11:50 +0530, Manikanta Pubbisetty wrote:
>>>> When mac80211 receives a packet, we interate over the list of
>>>> active interfaces to find the station(which transmitted the packet).
>>>> Currently, station search is not allowed on AP/VLAN interface; since
>>>> stations can also get mapped to AP/VLAN interfaces, they are worth
>>>> considering for station search.
>>> I don't see how this makes sense. We use sta_info_get_bss() later, so
>>> any AP/AP_VLAN would be OK, so we don't need to try it twice for
>>> AP_VLAN?
>> AP/VLANs are skipped currently, we don't even get to sta_info_get_bss()
>> if the iftype is AP/VLAN. No?
> Yes, we won't try anything for the AP_VLANs, but when we hit the AP we
> look up through everything, no?

I think it does, it gets the correct station information when AP iftype 
is hit.
Makes sense, we can drop this patch.

Manikanta
