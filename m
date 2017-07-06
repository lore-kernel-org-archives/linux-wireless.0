Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:35979 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751751AbdGFRPN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 13:15:13 -0400
Received: by mail-wr0-f180.google.com with SMTP id c11so11492356wrc.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 10:15:12 -0700 (PDT)
Subject: Re: Command equivalent in iw
To: Ben Greear <greearb@candelatech.com>,
        Emmanuel Grumbach <egrumbach@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <a496cdaa-41f3-53e1-bb4f-2843d5bd8b12@lwfinger.net>
 <CANUX_P3E9OASgfHykWsFjN1ii__sM=-8wWKr+6+rMk6GP2utvg@mail.gmail.com>
 <e98f1f21-d053-c5f0-5d17-8344cc5918ce@candelatech.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <4b3ed62e-ed4c-b63b-5adf-c80b9a3cd33a@broadcom.com> (sfid-20170706_191516_741635_9EF5B921)
Date: Thu, 6 Jul 2017 19:15:10 +0200
MIME-Version: 1.0
In-Reply-To: <e98f1f21-d053-c5f0-5d17-8344cc5918ce@candelatech.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06-07-17 16:36, Ben Greear wrote:
> 
> 
> On 07/06/2017 12:38 AM, Emmanuel Grumbach wrote:
>> On Thu, Jul 6, 2017 at 5:51 AM, Larry Finger
>> <Larry.Finger@lwfinger.net> wrote:
>>>
>>> Someone using the rtlwifi code that is posted at GitHub wants to know
>>> the iw equivalent of "iwpriv wlan0 bandcfg" to limit the wireless
>>> interface to 802.11b, 802.11g, or 802.11n. I only use simple iw
>>> commands, and I could not answer the question.
>>
>> This seems to be a private IOCTL and I can't find the code for that
>> handler in the kernel today. Even in wireless extensions..
>> I am not aware of something like this with iw today.
>>
>> In iwlwifi we have module parameter for this since this should really
>> be used seldom.
> 
> I have some patches for wpa_supplicant and the wifi stack (and ath10k)
> that lets this work,
> but it is fairly invasive, somewhat tricky to configure the supplicant
> properly,
> and the kernel related patches were rejected some time back, so
> it will only live in my trees for the foreseeable future.
> 
> If it is important to someone, they can find my kernels and hostapd and
> such here
> and maybe google for past email from me about such things for hints:
> 
> https://github.com/greearb

So what has been accepted in the kernel a while ago is to do the above
through devicetree configuration as it is considered a system use-case.
This was done by

commit e691ac2f75b69bee743f0370d79454ba4429b175
Author: Rafał Miłecki <rafal@milecki.pl>
Date:   Wed Jan 4 18:58:31 2017 +0100

    cfg80211: support ieee80211-freq-limit DT property

The DT property is handled by cfg80211 in net/wireless/of.c.

Regards,
Arend
