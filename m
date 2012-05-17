Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44922 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760685Ab2EQVer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 17:34:47 -0400
Received: by yhmm54 with SMTP id m54so2350791yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 14:34:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1337284032.4687.1.camel@jlt3.sipsolutions.net>
References: <1337270768-22719-1-git-send-email-eliad@wizery.com>
	<1337284032.4687.1.camel@jlt3.sipsolutions.net>
Date: Fri, 18 May 2012 00:34:46 +0300
Message-ID: <CAB3XZEcWGYAsPpuxs7Fs3a5c8ufkJOeEpJ3FgWyWttos6dYdKQ@mail.gmail.com> (sfid-20120517_233451_897166_AAC2E97A)
Subject: Re: [PATCH] cfg80211: fix memory leak/corruption of bss_list
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 17, 2012 at 10:47 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-05-17 at 19:06 +0300, Eliad Peller wrote:
>> cfg80211_dev_free() calls cfg80211_put_bss() directly on all
>> the remaining bss entries, skipping the proper bss entry
>> cleanup that usually made by __cfg80211_unlink_bss(), and
>> leaving the bss_list and the rb_tree with dangling pointers.
>
>>       list_for_each_entry_safe(scan, tmp, &rdev->bss_list, list)
>> -             cfg80211_put_bss(&scan->pub);
>> +             cfg80211_unlink_bss(&rdev->wiphy, &scan->pub);
>>       kfree(rdev);
>
> I don't see why we care, we free rdev anyway.
>
yeah, you have a point here...

we got a crash report for an older kernel with some custom patches,
that indicated a possible write-after-free on the bss release. i was
probably too rushed to blame this code.

thanks,
Eliad.
