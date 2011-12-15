Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41525 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1LOIXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 03:23:48 -0500
Subject: Re: [PATCH] mac80211: Fixing sparse warning at sta_info.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
In-Reply-To: <20111215051343.GA4570@hertz.marvell.com>
References: <20111215051343.GA4570@hertz.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 09:23:45 +0100
Message-ID: <1323937425.3337.4.camel@jlt3.sipsolutions.net> (sfid-20111215_092351_676339_43E45D9A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-15 at 10:43 +0530, Yogesh Ashok Powar wrote:
> The commit 42624d4913a00219a8fdbb4bafd634d1d843be85
> created following sparse warning
> >net/mac80211/sta_info.c:965:24: warning: incorrect type in assignment (different address spaces)
> >net/mac80211/sta_info.c:965:24:    expected struct tid_ampdu_tx *tid_tx
> >net/mac80211/sta_info.c:965:24:    got struct tid_ampdu_tx [noderef] <asn:4>*<noident>
> 
> Making use of rcu_dereference to fix the problem.

That doesn't fix any problem. It trades the compiler warning for a
runtime warning, so NACK.

You will need something like rcu_dereference_protected() here (although
it's not actually protected, but there's also no need to)

johannes

