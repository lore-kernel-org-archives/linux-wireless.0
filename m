Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:44257 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751117AbeERKwx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 06:52:53 -0400
Subject: Re: [PATCH] ath10k: add dynamic vlan support
To: Johannes Berg <johannes@sipsolutions.net>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, nbd@nbd.name
References: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org>
 <87r2n5auvq.fsf@kamboji.qca.qualcomm.com>
 <aa04534d-9677-f42e-a239-b230093ef2f5@dd-wrt.com>
 <f8d6d13943ccac22f363d7d4f53d645c@codeaurora.org>
 <1526637270.3805.15.camel@sipsolutions.net>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <d2dfdfb4-72d6-00e7-3952-bb38ef88ea5f@dd-wrt.com> (sfid-20180518_125257_698886_366846AE)
Date: Fri, 18 May 2018 12:52:53 +0200
MIME-Version: 1.0
In-Reply-To: <1526637270.3805.15.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Am 18.05.2018 um 11:54 schrieb Johannes Berg:
> On Fri, 2018-05-04 at 12:20 +0530, Manikanta Pubbisetty wrote:
>> Johannes,
>>
>> It seems like commit db3bdcb9c3ff ("mac80211: allow AP_VLAN operation on
>> crypto controlled devices") has broken 4-addr operation on crypto
>> controlled devices as reported by sebastian.
>> The commit was mainly focused in addressing the problem in supporting
>> VLANs on crypto controlled devices but since 4-addr mode is also
>> dependent on AP_VLAN interface, this commit breaks the 4-addr AP mode.
> Ok.
>
> Do you know why it actually broke it? I mean, we should've turned off
> the strict requirement for sw crypto control only for the GTK, and that
> shouldn't matter so much?
>
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
>
>> 2) Allow mac80211 to call set_key for GTKs on AP_VLAN interfaces for
>> crypto controlled devices, let the driver decide whether to return '1'
>> or some error code based on their support for transmitting sw encrypted
>> frames. I am little skeptical with this approach as drivers are totally
>> unaware of AP_VLAN interfaces.
> No, that won't work.
>
> I'm unsure how 4-addr VLAN can work with ath10k either way?
>
> Maybe it just doesn't normally need a GTK, so nothing broke before, but
> your other patch changed things to remove VLAN and then of course it's
> no longer available?
>
> But then I don't understand the complaint that
>
> So maybe the solution should be to add a separate flag for whether or
> not 4-addr VLAN is supported?
>
> johannes

let me explain. the vlan mode is used to create local interfaces in 
4addr mode

like wlan0.sta0, wlan0.sta1 per peer. this is required to put these 
peers into the local linux bridge since the local ap interface cannot

handle the bridging capabilities like correct forwarding, stp or even 
filtering. this is a long term behaviour since the beginning of ath9k.

so the ap_vlan feature is used to pass the frames per peer in a 
indepenened way. you may ask felix fietkau, since he developed it 
originally in madwifi

and later in mac80211 / ath9k. so ap_vlan capability is a requiredment 
for all 4addr capable wireless drivers.


example of a 4addr capable ap in ath10k with 2 connected 4addr stations

root@apreithalle:~# brctl show
bridge name     bridge id               STP enabled     interfaces
br0             8000.dcef09e4ce07       no              ath0
                                                         ath0.1
                                                         ath0.2
                                                         ath0.sta1
                                                         ath0.sta4
                                                         ath1
                                                         ath1.2
                                                         eth0
                                                         eth1

>
