Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f65.google.com ([209.85.192.65]:33824 "EHLO
	mail-qg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbcAWPSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2016 10:18:01 -0500
Received: by mail-qg0-f65.google.com with SMTP id 94so7002273qgt.1
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2016 07:18:00 -0800 (PST)
Date: Sat, 23 Jan 2016 10:15:48 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: Re: [PATCH 2/2] mac80211: let unused MPP table entries timeout
Message-ID: <20160123151548.GB4621@localhost> (sfid-20160123_161806_785475_9819CDB3)
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1453190672-9748-3-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <20160122203008.GA4621@localhost>
 <CAGnRvur8eKjiwWCR69NESnMDQoA4qro1ryH=DoeMFRd1RPFKOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGnRvur8eKjiwWCR69NESnMDQoA4qro1ryH=DoeMFRd1RPFKOQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 23, 2016 at 10:39:04AM +0100, Henning Rogge wrote:
> > FYI I have a patch set I'm testing which rewrites a big chunk of
> > the path table stuff.
> 
> Does it include some cleanup paths for the MPP table? At the moment
> the "missing cleanup" still allows remote users to make the Linux
> kernel to allocate as much memory as it wants... with no way to free
> it except for shutting down the interface.

No, it needs these patches too.  I did harmonize them a little bit,
so that e.g. the expiry check will be done during lookup, but I didn't
add an equivalent to flush-by-proxy.

One issue it does address is that the path table can eventually shrink
by virtue of the rhashtable, whereas now the bucket size is
ever-growing.

> > Let me know if you want me to base on top.
> 
> I would like them to go in first... my experience of the kernel code
> (outside some parts of the wifi stack) is not that good, so I don't
> know how long I would need to adapt the patches to your new data
> structures.

Ok, sounds good, I'll just rebase on top of yours.

-- 
Bob Copeland %% http://bobcopeland.com/
