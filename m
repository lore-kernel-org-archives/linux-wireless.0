Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56548 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752004AbeCVGVd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 02:21:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 22 Mar 2018 11:51:22 +0530
From: mpubbise@codeaurora.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: advertise supported interface types for sw
 encryption
In-Reply-To: <1521618788.2645.5.camel@sipsolutions.net>
References: <1520576822-1954-1-git-send-email-mpubbise@codeaurora.org>
 <1521618788.2645.5.camel@sipsolutions.net>
Message-ID: <089d864c1d6bb9218191dad53713f148@codeaurora.org> (sfid-20180322_072138_500645_71BB59C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-21 13:23, Johannes Berg wrote:
> On Fri, 2018-03-09 at 11:57 +0530, mpubbise@codeaurora.org wrote:
>> From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
>> 
>> Extending SW_CRYPTO_CONTROL interface so that drivers can advertise
>> the interface types on which they can support software encryption.
>> Driver's job is not done by advertising the supported vif types alone,
>> they should also return -EOPNOTSUPP from set_key.
>> 
>> Mac80211 will make the fallback decision to sw ecryption based
>> on the return type of set_key callback and the driver's support for
>> software encryption.
>> 
>> This change is done with the sole reason of adding the support of
>> VLANs for drivers which enable SW_CRYPTO_CONTROL(ex:ath10k).
>> 
>> With the current logic, configuring GTKs for specific VLAN groups will
>> always fail with the drivers enabling SW_CRYPTO_CONTROL. I understand
>> that the driver can return 1 from set_key to enable software 
>> encryption
>> in mac80211, but GTKs for VLANs are never passed down to the driver.
>> Since the return value is initialized to -EOPNOTSUPP, with this 
>> approach,
>> we get away with the failure.
> 
> Is there much value in having this control to start with, rather than
> saying it's *always* allowed for AP_VLAN interfaces?
> 
> I mean - if the driver wants to support (encryption on) AP_VLAN
> interfaces with SW_CRYPTO_CONTROL it basically has to set this to allow
> it, which is kinda pointless - it's hard to imagine a driver that wants
> to support AP_VLAN only for unencrypted, so if it doesn't support this
> it might as well just disable AP_VLAN support entirely.
> 
> So IMHO - just get rid of the bitmap and hard-code AP_VLAN.
> 

I agree with you only partially.

Today, I do not see any driver advertising SW_CRYPTO_CONTROL other than 
ath10k. There could be some driver which would want to advertise 
SW_CRYPTO_CONTROL and do not support the software encryption for VLAN 
devices. In that case, hard-coding doesn't seem to solve the problem 
completely right? No?

In some way driver has to advertise that it supports encryption on 
AP_VLANs, No?
Or you meant to say that driver should advertise the support for 
AP_VLANs only if it can support encryption on AP_VLAN devices? If this 
the case, then I could see some code in ieee80211_register_hw which says 
this,

         /* if low-level driver supports AP, we also support VLAN */
         if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP)) {
                 hw->wiphy->interface_modes |= 
BIT(NL80211_IFTYPE_AP_VLAN);
                 hw->wiphy->software_iftypes |= 
BIT(NL80211_IFTYPE_AP_VLAN);
         }

Please correct if I misinterpreted your comment.


--
mkp
