Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50378 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732189AbeHNPkN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 11:40:13 -0400
Subject: Re: [PATCH] ath10k: add dynamic vlan support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>
References: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org>
 <87r2n5auvq.fsf@kamboji.qca.qualcomm.com>
 <aa04534d-9677-f42e-a239-b230093ef2f5@dd-wrt.com>
 <f8d6d13943ccac22f363d7d4f53d645c@codeaurora.org>
 <1526637270.3805.15.camel@sipsolutions.net>
 <59ff8201-fc1b-8579-d5a9-f4b08621f5ec@codeaurora.org>
 <1527069018.3759.15.camel@sipsolutions.net>
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-ID: <eede64cf-ecf3-6697-a338-b7eb4c9bcd27@codeaurora.org> (sfid-20180814_145312_801551_BAF166AA)
Date: Tue, 14 Aug 2018 18:23:05 +0530
MIME-Version: 1.0
In-Reply-To: <1527069018.3759.15.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 5/23/2018 3:20 PM, Johannes Berg wrote:
> On Mon, 2018-05-21 at 12:12 +0530, Manikanta Pubbisetty wrote:
>>> Do you know why it actually broke it? I mean, we should've turned off
>>> the strict requirement for sw crypto control only for the GTK, and that
>>> shouldn't matter so much?
>> With the change db3bdcb9c3ff, AP/VLAN support is advertised by the
>> driver conditionally; the primary reason for doing this is to support
>> VLAN operations on sw crypto controlled devices.
> Right, or, well *not* supporting it.
>
>> AP also creates AP/VLAN devices for supporting 4-addr clients and since
>> the driver now advertises AP/VLAN support conditionally, the 4-addr
>> operation which has no relation to the VLANs(Per VLAN GTKs) was broken
>> on some ath10k devices.
> Right. Like I said, splitting those two capabilities somehow would be
> best.
>
>>>> + * @IEEE80211_HW_SUPPORTS_SW_ENCRYPT: Device is capable of transmitting
>>>> + *     frames encrypted in software, only valid when SW_CRYPTO_CONTROL
>>>> + *     is enabled. Based on this flag, mac80211 can allow/disallow VLAN
>>>> + *     operations in the BSS.
>>> Based on the name and initial description, this sounds equivalent to
>>> just turning off SW_CRYPTO_CONTROL. I think that's not the intent, but
>>> would need some renaming.
>> I can rename it to something which is very specific to VLAN support on
>> sw crypto controlled devices if that is okay.
> I don't think that makes sense. If we split the capability of AP_VLAN
> and AP_VLAN_FOR_4ADDR at the "root", then we don't need to play with all
> these things. Yes, this is slightly awkward for userspace, and perhaps
> with the interface combination checks, but I'd like you to look at that.

Hi Johannes,

I was working on splitting the 4-addr functionality from AP/VLAN iftype; 
I have introduced a new iftype NL80211_IFTYPE_AP_4ADDR and moved the 
4-addr handling from AP/VLAN to this new iftype. But this approach 
breaks the backward compatibility with older userspace applications. 
Since I am completely moving the 4-addr handling to the new type, older 
applications which do not understand this new type will simply fail and 
4-addr mode will be completely broken.

Currently, whenever a 4-addr client attempts a connection, hostapd just 
creates a AP/VLAN interface and moves the 4-addr client to the AP/VLAN 
iface; there are no other checks. I had no other option other than going 
with a new iftype for 4-addr handling.

Is there a way we can maintain backward compatibility with this 
approach? Retaining the 4-addr handling in AP/VLAN and duplicating the 
same functionality to the new iftype seems will work but I am not sure 
if this is the right approach.

Thanks,
Manikanta
