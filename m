Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45040 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717AbbFCOwb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 10:52:31 -0400
Message-ID: <1433343146.2274.17.camel@sipsolutions.net> (sfid-20150603_165246_892512_AFF249E6)
Subject: Re: [PATCH] cfg80211: modify lower retry limit to 0
From: Johannes Berg <johannes@sipsolutions.net>
To: "Hodaszi, Robert" <robert.hodaszi@digi.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"royujjal@gmail.com" <royujjal@gmail.com>
Date: Wed, 03 Jun 2015 16:52:26 +0200
In-Reply-To: <1433337281.7119.38.camel@A1-HR-PC>
References: <1433335560-17985-1-git-send-email-robert.hodaszi@digi.com>
	 (sfid-20150603_145244_934464_B91AF765) <1433336717.2274.13.camel@sipsolutions.net>
	 <1433337281.7119.38.camel@A1-HR-PC>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-03 at 13:14 +0000, Hodaszi, Robert wrote:
> The problem is if I change the rt2800 driver to set 0 if it gets 1,
> etc., that will break all existing user-space programs.

Well, I guess it's a question of which userspace even uses it, and how
it'll break.

Perhaps we should modify the wext userspace API to allow 0-254, and add
1 to the value before passing it to the driver. That way, in wext it
would be "compatible" with your expected behaviour, but internally we'd
still use the 802.11 semantics. I'd accept a patch doing this, since
you're the only one to ever even admit to using it (and still using
wext) :-)

Of course we should also fix the driver to treat it as # of transmission
attempts rather than # of retries, since clearly that's required for the
nl80211 API which is documented to do it like the spec.

johannes

