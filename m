Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35473 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752441AbcKYKH2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 05:07:28 -0500
Received: by mail-pf0-f178.google.com with SMTP id i88so14689824pfk.2
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2016 02:07:06 -0800 (PST)
Subject: Re: [PATCH] nl80211: provide minimum scheduled scan (plan) interval
To: Johannes Berg <johannes@sipsolutions.net>
References: <1479821515-13261-1-git-send-email-arend.vanspriel@broadcom.com>
 <1479821915.9021.4.camel@sipsolutions.net>
 <5c249c34-5e8c-093a-c5df-3507cabc8872@broadcom.com>
 <1480062330.4317.2.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Luca Coelho <luca@coelho.fi>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3fa55a67-4447-9c41-23d2-689db818b60d@broadcom.com> (sfid-20161125_110741_699147_C851A4DF)
Date: Fri, 25 Nov 2016 11:06:56 +0100
MIME-Version: 1.0
In-Reply-To: <1480062330.4317.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/25/2016 9:25 AM, Johannes Berg wrote:
> Sorry, forgot to reply to this until Luca's email bumped it up...
>
> On Tue, 2016-11-22 at 21:06 +0100, Arend Van Spriel wrote:
>
>> Are we? Currently, the minimum is not checked in nl80211, but that
>> does not say anything about the driver which might validate the
>> interval as well and return an error.
>
> Well, since drivers currently don't return an error (even if they
> ignore the value!) that *does* change the API.
>
>> What made me start looking at this is that in brcmfmac the interval
>> in the request was ignored and a fixed interval was provisioned in
>> the device. I wanted to fix that but was not sure if I needed to
>> check it against our firmware min..max range and what the appropriate
>> error handling should be. If silently changing what user-space is
>> requesting is fine for this, I am happy to make it so. Preferably in
>> nl80211.
>
> I think (agreeing with Luca) bumping it up is fine.

Fine by me although the "drift over time" reason seems only more reason 
to have minimum validation mainly because nowhere is nl80211.h it is 
stated that the interval is a "soft" requirement. Now Luca proposes 
bumping to minimum should be done in the driver. What is your opinion?

I will update the kernel doc to clarify what can be expected from the 
interval value.

Regards,
Arend
