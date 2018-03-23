Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37410 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750789AbeCWFvG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 01:51:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 23 Mar 2018 11:21:05 +0530
From: mpubbise@codeaurora.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: advertise supported interface types for sw
 encryption
In-Reply-To: <1521705975.6713.1.camel@sipsolutions.net>
References: <1520576822-1954-1-git-send-email-mpubbise@codeaurora.org>
 <1521618788.2645.5.camel@sipsolutions.net>
 <089d864c1d6bb9218191dad53713f148@codeaurora.org>
 <1521705975.6713.1.camel@sipsolutions.net>
Message-ID: <f85ad2ddb54b6f628f436c3b16eb1146@codeaurora.org> (sfid-20180323_065113_109136_90885FD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-22 13:36, Johannes Berg wrote:
> On Thu, 2018-03-22 at 11:51 +0530, mpubbise@codeaurora.org wrote:
>> 
>> > So IMHO - just get rid of the bitmap and hard-code AP_VLAN.
>> >
>> 
>> I agree with you only partially.
>> 
>> Today, I do not see any driver advertising SW_CRYPTO_CONTROL other 
>> than
>> ath10k. There could be some driver which would want to advertise
>> SW_CRYPTO_CONTROL and do not support the software encryption for VLAN
>> devices. In that case, hard-coding doesn't seem to solve the problem
>> completely right? No?
> 
> Well, my point is that such a hypothetical driver is completely
> irrelevant because it doesn't make any sense to have this behaviour -
> it would mean it cannot support AP_VLAN with encryption, so it might as
> well not support AP_VLAN at all.
> 
>> Or you meant to say that driver should advertise the support for
>> AP_VLANs only if it can support encryption on AP_VLAN devices?
> 
> Right.
> 
>> If this
>> the case, then I could see some code in ieee80211_register_hw which 
>> says
>> this,
>> 
>>          /* if low-level driver supports AP, we also support VLAN */
>>          if (local->hw.wiphy->interface_modes & 
>> BIT(NL80211_IFTYPE_AP)) {
>>                  hw->wiphy->interface_modes |=
>> BIT(NL80211_IFTYPE_AP_VLAN);
>>                  hw->wiphy->software_iftypes |=
>> BIT(NL80211_IFTYPE_AP_VLAN);
>>          }
> 
> Yes, but if such a driver comes along we can change this.
> 

It makes sense, I will send out the change by hard-coding only for 
AP-VLAN interface.

--
mkp
