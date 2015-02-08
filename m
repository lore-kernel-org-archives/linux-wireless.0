Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:55883 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbbBHP40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 10:56:26 -0500
Date: Sun, 8 Feb 2015 17:56:23 +0200
From: Jouni Malinen <j@w1.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] mac80211: don't defer scans in case of radar
 detection
Message-ID: <20150208155623.GA5485@w1.fi> (sfid-20150208_165630_065702_93425BD8)
References: <1420645811-17877-1-git-send-email-eliad@wizery.com>
 <1420645811-17877-3-git-send-email-eliad@wizery.com>
 <20150207115758.GA503@w1.fi>
 <CAB3XZEfhCkHFNg1ypxGd7sHreYmGDiUZUjOBokrsbGwJs-qP6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB3XZEfhCkHFNg1ypxGd7sHreYmGDiUZUjOBokrsbGwJs-qP6A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 08, 2015 at 12:41:14PM +0200, Eliad Peller wrote:
> There was indeed stale state. I've just sent a patch to fix it.

Thanks, that fixed the issue.

> I don't see why returning EBUSY is wrong, though.
> Actually, it just make the test fail immediately, instead of waiting
> indefinitely until a timeout occurs (i guess, didn't actually test it
> with the reverted patch).
> This was exactly the intended behavior, and i think it makes much more sense.

I have no issues with EBUSY being returned for a case where an
offchannel operation would be required while on a channel that require
constant monitoring for radars. I guess it would be fine to run a
single-channel scan on that same channel in such a state, but I'm not
sure whether this code prevents that or not. (Or whether there is really
that much of a real use case for such an operation.)

-- 
Jouni Malinen                                            PGP id EFC895FA
