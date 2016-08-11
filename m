Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35239 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbcHKSUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 14:20:43 -0400
Received: by mail-pf0-f181.google.com with SMTP id x72so981120pfd.2
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2016 11:20:42 -0700 (PDT)
Subject: Re: [RESEND PATCH] nl80211: Allow GET_INTERFACE dumps to be filtered
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1470261735-2977-1-git-send-email-denkenz@gmail.com>
 <1470919643.12075.7.camel@sipsolutions.net> <57ACA9E9.4020507@gmail.com>
 <1470938627.12075.25.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <57ACC1F8.6070908@gmail.com> (sfid-20160811_202047_945640_A7B748DB)
Date: Thu, 11 Aug 2016 13:20:40 -0500
MIME-Version: 1.0
In-Reply-To: <1470938627.12075.25.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

 >> Speaking of indentation, can you point me to a doc of the rules I
>> should follow?
>
> You've seen Documentation/CodingStyle?

Of course.  But that one doesn't discuss that you want your function 
parameters to be aligned to the opening '('.  Is there a dialect 
document specific to linux-wireless?

>
>> I can confirm that I sanity checked this patch. Both ATTR_WIPHY,
>> ATTR_WDEV and wildcard dumps seemed to produce expected results.
>
> I think it probably works due to the other conditions?

The initial conditions are that:
cb->args[0..2] == 0.

So on the first iteration we set filter_wiphy == -1 and check the filter 
attributes.  If set, we modify filter_wiphy accordingly.

Even if filter_wiphy is set to 0, the if statement should still never be 
entered afterwards since wp_start and if_start are incremented.

Is this what you're worried about? Do you see a fault in my logic?

Regards,
-Denis
