Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40151
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935264AbXHIACc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 20:02:32 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ssb: Make extif driver compilation depend on extif config
Date: Thu, 9 Aug 2007 02:02:19 +0200
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	John Linville <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
References: <200708071744.40287.mb@bu3sch.de> <46BA4E24.3060400@aurel32.net> <20070808164327.45803a64.akpm@linux-foundation.org>
In-Reply-To: <20070808164327.45803a64.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708090202.20267.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm hopelessly confused by the ssb stuff.  I'm not sure if I have all the
> right stuff, all the latest stuff and I don't understand why some is going
> into git-wireless and some is not.

Everything is going into git-wireless.
git-wireless contains latest ssb. _but_ John complained
about that. And he is right. SSB is not strictly wireless core.
So I thought it was best to get ssb into mainline as soon as
possible. So -mm is really the way to go into mainline.
My plan was to merge mainline with the next merge window.

> I'd prefer to be dumbly pulling a tree which Michael controls rather than
> trying to master it all in -mm, if possible.  A git tree or a quilt tree in
> some open dir somewhere would suit?

It's a bit difficult, as bcm43xx depends on it. Which again depends
on the wireless tree. :)
So basically we are stuck with maintaining it in wireless-dev.

I don't know what your policy is with pulling from wireless-dev.
So wireless-dev currently contains latest SSB. So if you pull from
wireless-dev, you'll also get latest SSB. Though, if we want to
merge SSB soon, we need it broken-out. That is what I was trying
to do.
