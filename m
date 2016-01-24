Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f194.google.com ([209.85.217.194]:36662 "EHLO
	mail-lb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbcAXRyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2016 12:54:06 -0500
Received: by mail-lb0-f194.google.com with SMTP id ad5so5327354lbc.3
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2016 09:54:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160123151548.GB4621@localhost>
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1453190672-9748-3-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <20160122203008.GA4621@localhost> <CAGnRvur8eKjiwWCR69NESnMDQoA4qro1ryH=DoeMFRd1RPFKOQ@mail.gmail.com>
 <20160123151548.GB4621@localhost>
From: Henning Rogge <hrogge@gmail.com>
Date: Sun, 24 Jan 2016 18:53:35 +0100
Message-ID: <CAGnRvupwvwV6a84zcO06p3rohReGMaQTz9FLUKG62DZC2TVyeQ@mail.gmail.com> (sfid-20160124_185410_881842_1F2F1D98)
Subject: Re: [PATCH 2/2] mac80211: let unused MPP table entries timeout
To: Bob Copeland <me@bobcopeland.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 23, 2016 at 4:15 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sat, Jan 23, 2016 at 10:39:04AM +0100, Henning Rogge wrote:
>> > FYI I have a patch set I'm testing which rewrites a big chunk of
>> > the path table stuff.
>>
>> Does it include some cleanup paths for the MPP table? At the moment
>> the "missing cleanup" still allows remote users to make the Linux
>> kernel to allocate as much memory as it wants... with no way to free
>> it except for shutting down the interface.
>
> No, it needs these patches too.  I did harmonize them a little bit,
> so that e.g. the expiry check will be done during lookup, but I didn't
> add an equivalent to flush-by-proxy.
>
> One issue it does address is that the path table can eventually shrink
> by virtue of the rhashtable, whereas now the bucket size is
> ever-growing.
>
>> > Let me know if you want me to base on top.
>>
>> I would like them to go in first... my experience of the kernel code
>> (outside some parts of the wifi stack) is not that good, so I don't
>> know how long I would need to adapt the patches to your new data
>> structures.
>
> Ok, sounds good, I'll just rebase on top of yours.

Thank you...

if you have problem with the "remove by proxy" patch I could look over
the patches you made... this part was quite trivial to do on the old
code and it should be easy for the new one too (as long as there is a
"remove MPath" and a "remove MPP" function).

Henning
