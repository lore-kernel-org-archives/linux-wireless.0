Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37856 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753968AbcHYWHC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 18:07:02 -0400
Received: by mail-wm0-f53.google.com with SMTP id i5so92535097wmg.0
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2016 15:07:02 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Fix unfiltered GET_INTERFACE dumps
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
References: <1472157884-3174-1-git-send-email-denkenz@gmail.com>
 <210adf6d-287c-f836-8e2c-78f42de94dee@broadcom.com>
 <57BF689A.5050406@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <61329b32-bd15-1c0d-867f-f50b29424953@broadcom.com> (sfid-20160826_000706_942550_6B226734)
Date: Fri, 26 Aug 2016 00:07:01 +0200
MIME-Version: 1.0
In-Reply-To: <57BF689A.5050406@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25-08-16 23:52, Denis Kenzior wrote:
> Hi Arend,
> 
> On 08/25/2016 04:35 PM, Arend van Spriel wrote:
>> On 25-08-16 22:44, Denis Kenzior wrote:
>>> dump_wiphy_parse only assigns filter_wiphy if one of the supported
>>> NL80211 attributes is present.  So for unfiltered dumps, filter_wiphy
>>> was always initialized to 0, and only interface 0 was dumped.
>>>
>>> This was introduced in commit 2d75da13fbb957e955d212555b91101cef36f0ce.
>>>
>>> Reported-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
>>
>> Actually sent a patch for this issue a little earlier. I should have
>> Cc'ed you explicitly, I guess.
>>
> 
> Whoops.  I saw your regression report and didn't look to see if you
> fixed it :)

I wanted to avoid having to revert so I decided to take a closer look.

> Looking at your patch, I'm worried that
> 
> -    int filter_wiphy = -1;
> +    int filter_wiphy;
> 
> might still break things, since Johannes used:
> 
>     if (!cb->args[2]) {
>         ...

Maybe my look was not close enough. In this branch cb->args[2] is set to
-1. So indeed that would make filter_wiphy uninitialized in subsequent
call(s). Thanks for catching that.

Regards,
Arend

>         } else if (cb->args[2] > 0) {
>                 filter_wiphy = cb->args[2] - 1;
>         }
> 
> So for unfiltered dumps, filter_wiphy would not be initialized properly
> for the second & onward call of nl80211_dump_interface. Right?
> 
> Regards,
> -Denis
