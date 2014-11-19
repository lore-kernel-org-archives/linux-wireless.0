Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57419 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaKSLk0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 06:40:26 -0500
Received: by mail-wg0-f44.google.com with SMTP id b13so578292wgh.31
        for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2014 03:40:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416396152.9374.0.camel@sipsolutions.net>
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
 <1415551822-20121-16-git-send-email-arik@wizery.com> <1416396152.9374.0.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 19 Nov 2014 13:40:09 +0200
Message-ID: <CA+XVXfefE7=o3v52-_a9QZ3FemNJ1KxOHXG6Qt3896Q=Y4CA=A@mail.gmail.com> (sfid-20141119_124029_897252_FFFBFF57)
Subject: Re: [PATCH 16/16] mac80211: synchronously reserve TID per station
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Liad Kaufman <liad.kaufman@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 19, 2014 at 1:22 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2014-11-09 at 18:50 +0200, Arik Nemtsov wrote:
>
>> +     if (WARN_ON(tid >= IEEE80211_NUM_TIDS))
>> +             return -EINVAL;
>
> That validates < 16
>
>> +     queues = BIT(sdata->vif.hw_queue[ieee802_1d_to_ac[tid]]);
>
> but that's only valid for < 8, causing a smatch warning.

It's a valid warning. It should be tid & 7 here. I'll send a fix.

Arik
