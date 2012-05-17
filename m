Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45243 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760685Ab2EQVj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 17:39:28 -0400
Received: by obbtb18 with SMTP id tb18so3023341obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 14:39:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FB55197.8070308@candelatech.com>
References: <1337270768-22719-1-git-send-email-eliad@wizery.com>
	<4FB55197.8070308@candelatech.com>
Date: Fri, 18 May 2012 00:39:27 +0300
Message-ID: <CAB3XZEdw1N7Sn8ffL1GyMRX4G=NLUb1Q8_QeJuNXJS16nxpGFg@mail.gmail.com> (sfid-20120517_233932_323538_09B4A765)
Subject: Re: [PATCH] cfg80211: fix memory leak/corruption of bss_list
From: Eliad Peller <eliad@wizery.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Ben,

On Thu, May 17, 2012 at 10:29 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 05/17/2012 09:06 AM, Eliad Peller wrote:
>>
>> cfg80211_dev_free() calls cfg80211_put_bss() directly on all
>> the remaining bss entries, skipping the proper bss entry
>> cleanup that usually made by __cfg80211_unlink_bss(), and
>> leaving the bss_list and the rb_tree with dangling pointers.
>>
>> Fix it by calling cfg80211_unlink_bss() instead.
>
>
> This doesn't apply clean against 3.3..though not too hard
> to fix it up by hand.
>
> Do you know how far back this does need to be applied (3.0, for instance)?
>
as Johannes noted, this patch doesn't seem to solve an actual bug, so
it's not needed.

Eliad.
