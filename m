Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60746 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750911AbeEUGmu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 02:42:50 -0400
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
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-ID: <59ff8201-fc1b-8579-d5a9-f4b08621f5ec@codeaurora.org> (sfid-20180521_084259_084325_9E69247F)
Date: Mon, 21 May 2018 12:12:40 +0530
MIME-Version: 1.0
In-Reply-To: <1526637270.3805.15.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> Do you know why it actually broke it? I mean, we should've turned off
> the strict requirement for sw crypto control only for the GTK, and that
> shouldn't matter so much?

With the change db3bdcb9c3ff, AP/VLAN support is advertised by the 
driver conditionally; the primary reason for doing this is to support 
VLAN operations on sw crypto controlled devices.
AP also creates AP/VLAN devices for supporting 4-addr clients and since 
the driver now advertises AP/VLAN support conditionally, the 4-addr 
operation which has no relation to the VLANs(Per VLAN GTKs) was broken 
on some ath10k devices.

>> I have couple of ideas on how to address the problem,
>>
>> 1) Add a new hw_flag and based on the hardware flag, allow/disallow the
>> creation of AP_VLAN interface.
>>
>> + * @IEEE80211_HW_SUPPORTS_SW_ENCRYPT: Device is capable of transmitting
>> + *     frames encrypted in software, only valid when SW_CRYPTO_CONTROL
>> + *     is enabled. Based on this flag, mac80211 can allow/disallow VLAN
>> + *     operations in the BSS.
> Based on the name and initial description, this sounds equivalent to
> just turning off SW_CRYPTO_CONTROL. I think that's not the intent, but
> would need some renaming.

I can rename it to something which is very specific to VLAN support on 
sw crypto controlled devices if that is okay.

>> 2) Allow mac80211 to call set_key for GTKs on AP_VLAN interfaces for
>> crypto controlled devices, let the driver decide whether to return '1'
>> or some error code based on their support for transmitting sw encrypted
>> frames. I am little skeptical with this approach as drivers are totally
>> unaware of AP_VLAN interfaces.
> No, that won't work.
>
> I'm unsure how 4-addr VLAN can work with ath10k either way?
> Maybe it just doesn't normally need a GTK, so nothing broke before, but
> your other patch changed things to remove VLAN and then of course it's
> no longer available?
>
> But then I don't understand the complaint that
>
> So maybe the solution should be to add a separate flag for whether or
> not 4-addr VLAN is supported?

IIUC, the combination of 4-addr and VLAN doesn't work even without this
change db3bdcb9c3ff (" mac80211: allow AP_VLAN operation on crypto
controlled devices ").

AP/VLAN devices are used separately to either support 4-addr operation
or VLAN (separating the clients into VLAN groups each having unique GTK),
I believe both are mutually exclusive.

One reason why the combination of 4-addr+VLAN doesn't work could be that
a single AP/VLAN interface can cater to several wireless clients but to
support 4-addr operation every client device should have an exclusive
AP/VLAN interface.

It is possible where few clients in a specific VLAN group can use 4-addr
mode and few might not, if this is the case then AP has to create
individual AP/VLAN device for each 4-addr client and since these clients
belong to specific VLAN group, all of these clients should be tied
to AP/VLAN device created for VLAN operation(Created for maintaining
unique GTKs). I am not sure if the current stack supports this complex
combination, I could not make it work in my testing though.
