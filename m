Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53786 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731Ab1JZRxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 13:53:32 -0400
Received: by bkbzt19 with SMTP id zt19so1840120bkb.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 10:53:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4EA7DA0F.7050603@sipsolutions.net>
References: <1319350901-31178-1-git-send-email-arik@wizery.com> <4EA7DA0F.7050603@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 26 Oct 2011 19:53:16 +0200
Message-ID: <CA+XVXff+4SLy6y2xbDONDOg_j9CNYd1rkLgtdvHEKpprBW5zog@mail.gmail.com> (sfid-20111026_195342_915623_025BCD71)
Subject: Re: [PATCH] mac80211: support adding IV-room in the skb for CCMP keys
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 26, 2011 at 11:59, Johannes Berg <johannes@sipsolutions.net> wrote:
> On 10/23/2011 8:21 AM, Arik Nemtsov wrote:
>>
>> Some cards can generate CCMP IVs in HW, but require the space for the IV
>> to be pre-allocated in the frame at the correct offset. Add a key flag
>> that allows us to achieve this.
>
> Is it really that expensive to generate the IV and then not use it that this
> is worth the extra complexity? This not just makes it more complex but also
> more expensive in the other case.
>

Some of the platforms with this chip are pretty weak (host CPU is the
bottleneck).

We add another "if" for the other case (for a value that's likely in
the cacheline already). I don't think that's too bad.

Arik
