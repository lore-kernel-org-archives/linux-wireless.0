Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36184 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab0JLOPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 10:15:52 -0400
Received: by wwj40 with SMTP id 40so5082308wwj.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 07:15:51 -0700 (PDT)
Date: Tue, 12 Oct 2010 16:15:47 +0200
From: Ido Yariv <ido@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 3/4] wl1271: Allocate TX descriptors more efficiently
Message-ID: <20101012141547.GC1836@WorkStation>
References: <1286887752-19321-1-git-send-email-ido@wizery.com>
 <1286887752-19321-4-git-send-email-ido@wizery.com>
 <1286888188.3753.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286888188.3753.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 12, 2010 at 02:56:28PM +0200, Johannes Berg wrote:
> This is all under some lock, right? (If that isn't the case, it's racy)
Right.

> Therefore, you need not use atomic bitops which will be fairly
> expensive...
> 
> Have you actually measured this? It seems that it con't have a huge
> effect, and the atomic bitops you use now might even negate it.
Like I mentioned in the cover letter, this is more of a cosmetic change
than a real optimization. It doesn't really improve performance, but the
code looks nicer.
Using non atomic bitops cannot hurt, I guess.

Thanks,
Ido.
