Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34297 "EHLO
        mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbcHYVxi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 17:53:38 -0400
Received: by mail-pa0-f46.google.com with SMTP id fi15so20406547pac.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2016 14:52:27 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Fix unfiltered GET_INTERFACE dumps
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
References: <1472157884-3174-1-git-send-email-denkenz@gmail.com>
 <210adf6d-287c-f836-8e2c-78f42de94dee@broadcom.com>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <57BF689A.5050406@gmail.com> (sfid-20160825_235342_562627_DEF5A528)
Date: Thu, 25 Aug 2016 16:52:26 -0500
MIME-Version: 1.0
In-Reply-To: <210adf6d-287c-f836-8e2c-78f42de94dee@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On 08/25/2016 04:35 PM, Arend van Spriel wrote:
> On 25-08-16 22:44, Denis Kenzior wrote:
>> dump_wiphy_parse only assigns filter_wiphy if one of the supported
>> NL80211 attributes is present.  So for unfiltered dumps, filter_wiphy
>> was always initialized to 0, and only interface 0 was dumped.
>>
>> This was introduced in commit 2d75da13fbb957e955d212555b91101cef36f0ce.
>>
>> Reported-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
>
> Actually sent a patch for this issue a little earlier. I should have
> Cc'ed you explicitly, I guess.
>

Whoops.  I saw your regression report and didn't look to see if you 
fixed it :)

Looking at your patch, I'm worried that

-	int filter_wiphy = -1;
+	int filter_wiphy;

might still break things, since Johannes used:

	if (!cb->args[2]) {
		...
         } else if (cb->args[2] > 0) {
                 filter_wiphy = cb->args[2] - 1;
         }

So for unfiltered dumps, filter_wiphy would not be initialized properly 
for the second & onward call of nl80211_dump_interface. Right?

Regards,
-Denis
