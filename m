Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:38908 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab0AFQHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 11:07:15 -0500
Received: by ewy19 with SMTP id 19so9754602ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 08:07:14 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix a few work bugs
References: <1262788258.9268.113.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 06 Jan 2010 18:07:11 +0200
In-Reply-To: <1262788258.9268.113.camel@johannes.local> (Johannes Berg's message of "Wed\, 06 Jan 2010 15\:30\:58 +0100")
Message-ID: <87aawrusi8.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Kalle and Lennert reported problems with the new work
> code, and at least Kalle's problem I was able to trace
> to a missing jiffies initialisation.
>
> I also ran into a problem where occasionally I couldn't
> connect, which seems fixed with kicking the work items
> after scanning.
>
> Finally, also add some sanity checking code to verify
> that we're not adding work items while an interface is
> down -- that case could lead to something similar to
> what Lennert was seeing.
>
> There still seems to be a race condition that we're
> trying to figure out separately.

This seems to help with my problem, it associated quickly:

Jan  6 18:05:36 tikku kernel: [  153.527515] wlan0: direct probe
responded
Jan  6 18:05:36 tikku kernel: [  153.536061] wlan0: authenticate with
00:1e:ab:10:e0:c2 (try 1)
Jan  6 18:05:36 tikku kernel: [  153.537910] wlan0: authenticated
Jan  6 18:05:36 tikku kernel: [  153.537924] phy0: device now idle
Jan  6 18:05:36 tikku kernel: [  153.538563] wlan0: associate with
00:1e:ab:10:e0:c2 (try 1)
Jan  6 18:05:36 tikku kernel: [  153.538578] phy0: device no longer
idle - working
Jan  6 18:05:36 tikku kernel: [  153.578808] wlan0: RX AssocResp from
00:1e:ab:10:e0:c2 (capab=0x11 status=0 aid=1)
Jan  6 18:05:36 tikku kernel: [  153.578814] wlan0: associated


Because I'm currently travelling, I have tested this only once. Will
test more when I get back home.

Thanks for the patch.

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Tested-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
