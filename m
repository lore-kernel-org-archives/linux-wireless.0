Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38916 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbeHXJXW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 05:23:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 24 Aug 2018 11:20:17 +0530
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>
Subject: Re: [PATCH] ath10k: add dynamic vlan support
In-Reply-To: <1534408023.3547.64.camel@sipsolutions.net>
References: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org>
 <87r2n5auvq.fsf@kamboji.qca.qualcomm.com>
 <aa04534d-9677-f42e-a239-b230093ef2f5@dd-wrt.com>
 <f8d6d13943ccac22f363d7d4f53d645c@codeaurora.org>
 <1526637270.3805.15.camel@sipsolutions.net>
 <59ff8201-fc1b-8579-d5a9-f4b08621f5ec@codeaurora.org>
 <1527069018.3759.15.camel@sipsolutions.net>
 <eede64cf-ecf3-6697-a338-b7eb4c9bcd27@codeaurora.org>
 <1534408023.3547.64.camel@sipsolutions.net>
Message-ID: <80f8e88e5161f2731e67e1c0e1d7225c@codeaurora.org> (sfid-20180824_075024_046807_6C51B414)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-16 13:57, Johannes Berg wrote:
> On Tue, 2018-08-14 at 18:23 +0530, Manikanta Pubbisetty wrote:
> 
>> > I don't think that makes sense. If we split the capability of AP_VLAN
>> > and AP_VLAN_FOR_4ADDR at the "root", then we don't need to play with all
>> > these things. Yes, this is slightly awkward for userspace, and perhaps
>> > with the interface combination checks, but I'd like you to look at that.
> 
>> I was working on splitting the 4-addr functionality from AP/VLAN 
>> iftype;
>> I have introduced a new iftype NL80211_IFTYPE_AP_4ADDR and moved the
>> 4-addr handling from AP/VLAN to this new iftype. But this approach
>> breaks the backward compatibility with older userspace applications.
> 
> Yeah ...
> 
> I'm confused and no longer sure what I was thinking, nor even what 
> we're
> trying to achieve here...
> 

I had introduced a change db3bdcb9c3ff (" mac80211: allow AP_VLAN 
operation on crypto controlled devices ") for supporting VLAN 
functionality on ath10k devices; this commit has broken 4 addr support 
on ath10k devices as I was advertising the AP/VLAN support 
conditionally. Since 4 addr operation is tied to AP/VLAN support, with 
this change, only the chips which support VLAN functionality can support 
4 addr operation but other ath10k chips don't.

 From what I can understand from our previous discussions, we had to 
separate the 4addr support from the AP/VLAN iftype but doing so could 
lead to backward compatibility issues. I have the code which separates 
the 4addr functionality from AP/VLAN but the bigger problem is the 
backward compatibility.

I am hoping that now I have set the context correctly :)

>> Since I am completely moving the 4-addr handling to the new type, 
>> older
>> applications which do not understand this new type will simply fail 
>> and
>> 4-addr mode will be completely broken.
>> 
>> Currently, whenever a 4-addr client attempts a connection, hostapd 
>> just
>> creates a AP/VLAN interface and moves the 4-addr client to the AP/VLAN
>> iface; there are no other checks. I had no other option other than 
>> going
>> with a new iftype for 4-addr handling.
>> 
>> Is there a way we can maintain backward compatibility with this
>> approach? Retaining the 4-addr handling in AP/VLAN and duplicating the
>> same functionality to the new iftype seems will work but I am not sure
>> if this is the right approach.
> 
> I think we have to keep the 4-addr handling in AP_VLAN iftype either
> way, to not break existing hostapd. We could introduce a separate
> AP_VLAN_NO_4ADDR and then require updating hostapd to get non-4addr
> VLAN, but that also seems awkward.
> 
> Since hostapd doesn't currently check anything...
> 
> Ok, no, I'm confused now. If we just clear WIPHY_FLAG_4ADDR_AP, don't 
> we
> get what we want? 4-addr AP_VLAN interfaces would no longer be 
> permitted
> to be created?

As I explained above, the agenda is to provide the driver (in this case, 
ath10k) a better control for advertising the device capabilities; only 
few ath10k chips can support VLAN functionality but all of them can 
support 4 addr operation.

Manikanta
