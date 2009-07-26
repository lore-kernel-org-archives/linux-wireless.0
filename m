Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:12518 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbZGZUKR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2009 16:10:17 -0400
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
From: Pavel Roskin <proski@gnu.org>
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linville@tuxdriver.com
In-Reply-To: <c6b1100b0907261215l71ada148y8a15f6595d939192@mail.gmail.com>
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com>
	 <c6b1100b0907140404h4fdbe419p8443da43350f3520@mail.gmail.com>
	 <c6b1100b0907210439jf67d886s3125dafa5f4d3928@mail.gmail.com>
	 <c6b1100b0907261215l71ada148y8a15f6595d939192@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 26 Jul 2009 16:10:13 -0400
Message-Id: <1248639013.32168.15.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-07-26 at 20:15 +0100, Chris Clayton wrote:

> One more data point. I wondered whether the freeze would "time out" if
> I just left the laptop frozen, but my testing shows that it probably
> does not (or if it does it takes more than 27 minutes to do so.

I suggest that you run it on the text console after "dmesg -n 8", so
that all kernel messages are seen.

I'm using rt61pci with wireless-testing, and I don't see any freezes.

> I've also tried to bisect again, but, as last time, once I got to the
> batch of network-related changes that went into -rc1, I get a series
> of kernels that build but either won't boot or have inoperable
> wireless networking.

You can use "git bisect skip" to skip those revisions.

You can specify the paths in "git bisect start" so that only changes to
the interesting places (like drivers/net wireless, net/mac80211 and
net/wireless) are considered when calculating the next commit.  This
will probably help you avoid the bad place.

Also, please try the current wireless-testing.  The problem may be fixed
there.

> Finally, since I haven't had a single reply to the regression report I
> posted almost two weeks ago, I now give up. I'll switch to using the
> card supported by the ath5k driver.

Perhaps there was not enough material for others to comment on, and
nobody was experiencing anything similar.

If I had such problem, I would try to bisect it, but I cannot reproduce
it.

-- 
Regards,
Pavel Roskin
