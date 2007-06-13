Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 91-65-240-14-dynip.superkabel.de ([91.65.240.14]:50783 "EHLO
	charon.n2.diac24.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756468AbXFMMeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 08:34:13 -0400
Date: Wed, 13 Jun 2007 14:33:35 +0200
From: David Lamparter <lists@diac24.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: David Lamparter <lists@diac24.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: use nl80211_* enums
Message-ID: <20070613123333.GA3440@charon.n2.diac24.net>
References: <20070611221224.GA10598@charon.n2.diac24.net> <200706122355.36078.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <200706122355.36078.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +#include <linux/nl80211.h>
>
> It seems to me that cfg80211 shouldn't depend on nl80211, so the 
> nl80211_iftype enum should be moved to cfg80211.h and become cfg80211_iftype.

That's not possible because nl80211_{iftype,phymode} are userspace API.
If they were defined in cfg80211.h, nl80211.h would need to at least mirror
them. And since nl80211.h can't include cfg80211.h (since the former is a
"public" header supposed to go to /usr/include with some linux-headers-*
package), this way around is the simplest and cleanest solution.

Anyway, I don't really think including a header to be a "dependency". You
can disable the nl80211 implementation and still use the API enum just
fine. (Note that nl80211.h contains enums, more enums and ONLY enums :)

-David

