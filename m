Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45649 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab1APIwW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 03:52:22 -0500
Subject: Re: [PATCH] wl12xx: fix some sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=pizkixzqiiHwcN6KjcB-+oiKbsmo3TOw_bCB6@mail.gmail.com>
References: <1295164184-25592-1-git-send-email-eliad@wizery.com>
	 <1295166522.3574.1.camel@jlt3.sipsolutions.net>
	 <AANLkTi=pizkixzqiiHwcN6KjcB-+oiKbsmo3TOw_bCB6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Jan 2011 09:52:20 +0100
Message-ID: <1295167940.3574.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-16 at 10:48 +0200, Eliad Peller wrote:

> >> -     acx->rate_policy_idx = idx;
> >> +     acx->rate_policy_idx = __cpu_to_le32(idx);
> >
> > The underscore version doesn't look appropriate at this point or in fact
> > anywhere in this patch.
> >
> > Also, your patch subject and commit log is wrong -- this doesn't just
> > fix sparse warnings, it fixes actual bugs pointed out by sparse, so
> > commit log should reflect that.
> >
> thanks for your review!
> i'll send a new version.
> 
> what is the difference between the normal and underscore version?
> atomicity? (i didn't find a documentation about it)

Generally underscore versions are more "internal" APIs. In this case, I
believe the underscore version is usable in places where the compiler
needs a constant as the output, I'm not quite sure though.

johannes

