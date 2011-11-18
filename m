Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39521 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1KRUQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 15:16:56 -0500
Subject: Re: Re: [PATCH] mac80211: Fix endian bug in radiotap header
 generation
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1654464.RY7RQ6RAa1@helmutmobil.site> (sfid-20111118_205842_242976_56215823)
References: <1321626702.10266.59.camel@jlt3.sipsolutions.net>
	 <1321632136-9398-1-git-send-email-helmut.schaa@googlemail.com>
	 <1321632520.10266.66.camel@jlt3.sipsolutions.net>
	 <1654464.RY7RQ6RAa1@helmutmobil.site>
	 (sfid-20111118_205842_242976_56215823)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 21:16:52 +0100
Message-ID: <1321647412.10266.76.camel@jlt3.sipsolutions.net> (sfid-20111118_211659_449104_09F84B6F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-18 at 21:56 +0100, Helmut Schaa wrote:
> Am Freitag, 18. November 2011, 17:08:40 schrieb Johannes Berg:
> > Heh I would've fixed it by just using put_unaligned(txflags, pos) here,
> > but either is fine with me :-)
> 
> Hmm, right, but using this approach we even save some cpu_to_le16 calls on
> BE archs

Not really, because the compiler will translate cpu_to_le16(const) to
swapped-const.

>  and maybe some day I'll learn to always build with "make C=1" to
> catch endian bugs before sending a patch :)

:-)

johannes

