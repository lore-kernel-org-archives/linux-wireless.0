Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57692 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbeHNOjT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 10:39:19 -0400
Subject: Re: [PATCH] mac80211: allow station search on AP/VLANs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <1532931620-3161-1-git-send-email-mpubbise@codeaurora.org>
 <1534246103.3547.23.camel@sipsolutions.net>
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-ID: <1f50369a-61ae-cd7b-1300-78392852ebb5@codeaurora.org> (sfid-20180814_135231_876176_FD8C8C3D)
Date: Tue, 14 Aug 2018 17:22:25 +0530
MIME-Version: 1.0
In-Reply-To: <1534246103.3547.23.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/14/2018 4:58 PM, Johannes Berg wrote:

> On Mon, 2018-07-30 at 11:50 +0530, Manikanta Pubbisetty wrote:
>> When mac80211 receives a packet, we interate over the list of
>> active interfaces to find the station(which transmitted the packet).
>> Currently, station search is not allowed on AP/VLAN interface; since
>> stations can also get mapped to AP/VLAN interfaces, they are worth
>> considering for station search.
> I don't see how this makes sense. We use sta_info_get_bss() later, so
> any AP/AP_VLAN would be OK, so we don't need to try it twice for
> AP_VLAN?

AP/VLANs are skipped currently, we don't even get to sta_info_get_bss() 
if the iftype is AP/VLAN. No?

Manikanta
