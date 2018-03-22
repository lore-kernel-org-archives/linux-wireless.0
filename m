Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:48090 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751817AbeCVIGR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 04:06:17 -0400
Message-ID: <1521705975.6713.1.camel@sipsolutions.net> (sfid-20180322_090628_007204_99CC5ACC)
Subject: Re: [RFC] mac80211: advertise supported interface types for sw
 encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: mpubbise@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 22 Mar 2018 09:06:15 +0100
In-Reply-To: <089d864c1d6bb9218191dad53713f148@codeaurora.org>
References: <1520576822-1954-1-git-send-email-mpubbise@codeaurora.org>
         <1521618788.2645.5.camel@sipsolutions.net>
         <089d864c1d6bb9218191dad53713f148@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-03-22 at 11:51 +0530, mpubbise@codeaurora.org wrote:
> 
> > So IMHO - just get rid of the bitmap and hard-code AP_VLAN.
> > 
> 
> I agree with you only partially.
> 
> Today, I do not see any driver advertising SW_CRYPTO_CONTROL other than 
> ath10k. There could be some driver which would want to advertise 
> SW_CRYPTO_CONTROL and do not support the software encryption for VLAN 
> devices. In that case, hard-coding doesn't seem to solve the problem 
> completely right? No?

Well, my point is that such a hypothetical driver is completely
irrelevant because it doesn't make any sense to have this behaviour -
it would mean it cannot support AP_VLAN with encryption, so it might as
well not support AP_VLAN at all.

> Or you meant to say that driver should advertise the support for 
> AP_VLANs only if it can support encryption on AP_VLAN devices? 

Right.

> If this 
> the case, then I could see some code in ieee80211_register_hw which says 
> this,
> 
>          /* if low-level driver supports AP, we also support VLAN */
>          if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP)) {
>                  hw->wiphy->interface_modes |= 
> BIT(NL80211_IFTYPE_AP_VLAN);
>                  hw->wiphy->software_iftypes |= 
> BIT(NL80211_IFTYPE_AP_VLAN);
>          }

Yes, but if such a driver comes along we can change this.

johannes
