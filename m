Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35196 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752525AbeERJhU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 05:37:20 -0400
Received: by mail-qk0-f194.google.com with SMTP id c137-v6so5914544qkg.2
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2018 02:37:20 -0700 (PDT)
Subject: Re: [RESEND PATCH] cfg80211: dynamically allocate per-tid stats for
 station info
To: Johannes Berg <johannes@sipsolutions.net>
References: <5AF430B2.2060903@broadcom.com> <5AF431F4.9060408@broadcom.com>
 <1526635514.3805.3.camel@sipsolutions.net>
Cc: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AFE9ECE.50306@broadcom.com> (sfid-20180518_113731_261136_2EAA069C)
Date: Fri, 18 May 2018 11:37:18 +0200
MIME-Version: 1.0
In-Reply-To: <1526635514.3805.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/18/2018 11:25 AM, Johannes Berg wrote:
> On Thu, 2018-05-10 at 13:50 +0200, Arend van Spriel wrote:
>>
>> Here an alternative approach. Currently the only cfg80211-based driver
>> providing per-tid stats is mac80211. This patch only changes mac80211
>> and the other driver can keep using stack allocation. Even mac80211 could
>> if wanted, but I left that part as is.
>
> I decided to take this and remove the BIT() thing entirely (you had a
> bug there anyway)

I figured you would drop this one. The error paths may need to do kfree 
here and there. Kalle took dynamic alloc fixes in driver already so my 
patch is not really needed right now.

Gr. AvS
