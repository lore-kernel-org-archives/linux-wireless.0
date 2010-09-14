Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45042 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab0INOxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 10:53:36 -0400
Subject: Re: [virtual-sta 1/3] mac80211:  Add more general interface
 iterator.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4C8F8B0D.8050902@candelatech.com>
References: <1284156298-15863-1-git-send-email-greearb@candelatech.com>
	 <1284469166.3704.3.camel@jlt3.sipsolutions.net>
	 <4C8F8B0D.8050902@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 16:53:00 +0200
Message-ID: <1284475980.3704.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-14 at 07:47 -0700, Ben Greear wrote:

> I'll see if I can get ath9k to use the normal iterator.  I didn't need my
> own iterator, because I could just pass in NULL for iterator and pass
> active_only as false.

active_only as false still doesn't seem right. Why would you care about
it before an interface is up?

> I think you should consider returning the count for the number of times the
> iterator was called because it's simple code, and it would save the same logic
> in each driver's iterator methods (or at least, ath9k).

Yeah, that seems like a good change, but I think we should probably get
to the bottom of it first (the sdata->bss change on the other hand seems
fine as is)

johannes

