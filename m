Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:35358 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751309AbdEVKOa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 06:14:30 -0400
Received: by mail-pf0-f174.google.com with SMTP id n23so77969740pfb.2
        for <linux-wireless@vger.kernel.org>; Mon, 22 May 2017 03:14:30 -0700 (PDT)
Subject: Re: [PATCH V2 0/9] nl80211: add support for PTK/GTK handshake offload
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
References: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
 <1495030794.2442.21.camel@sipsolutions.net>
 <1de42f39-1912-349b-e20d-4b5c3c44909f@broadcom.com>
 <1495099355.2553.1.camel@sipsolutions.net>
 <4e0672aa-51bc-115f-32b7-b1a8eb747e5b@broadcom.com>
 <1495104012.2553.3.camel@sipsolutions.net>
 <adcf52eb-cc8f-82de-3820-3f96a0d1f8d3@broadcom.com>
 <1495189263.3274.4.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c3c14002-c9c5-490a-2e8f-826d601d0d84@broadcom.com> (sfid-20170522_121437_689356_F431248C)
Date: Mon, 22 May 2017 12:14:26 +0200
MIME-Version: 1.0
In-Reply-To: <1495189263.3274.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/19/2017 12:21 PM, Johannes Berg wrote:
> On Thu, 2017-05-18 at 14:48 +0200, Arend Van Spriel wrote:
> 
>> True. However, we touched this topic a while ago in generic context,
>> ie. preference for ext_features over supported_commands. Right now
>> wpa_supplicant does not check NEW_KEY support so we can go either
>> way.
> 
> Right. That's a separate discussion though - whether we add two flags
> here or check NEW_KEY support doesn't really matter, except that we
> need to decide
> 
>   * if we want to support such an override at all, and
>   * if it should be tested at all
>     (perhaps we can just live with that failing entirely?)
> 
>> I have cleaned up the wpa_supplicant patches for the offloads, but
>> waited with submitting them until the kernel side got applied. So
>> depending on what is decided here I can rework it.
> 
> I don't really know. I personally don't think that we need to allow
> both ways, but then I'm coming with a driver that doesn't even support
> the old way.

Ok. I know for sure that I have firmware in linux-firmware that supports 
the offload. So for people using that out there things will change from 
one way to the other when they change to a newer wpa_supplicant.

> So you should probably decide yourself if you want to keep this
> fallback option, and how well it should work (be rejected if used on a
> driver that doesn't support it, or just fail later?)

There is a (small) chance of regression with older devices as stated 
above and I would like to keep the fallback option for that. Also people 
may like to have a choice. I am not so sure about whether NEW_KEY 
support is enough or a new ext_feature flag is needed. I am inclined to 
say the NEW_KEY support is sufficient.

Regards,
Arend
