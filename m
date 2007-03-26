Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:63152 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933430AbXCZCdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2007 22:33:37 -0400
Message-ID: <460730FF.1050603@lwfinger.net>
Date: Sun, 25 Mar 2007 21:33:35 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx: Fix machine check on PPC for version 1 PHY
References: <46067d12.1uF8l72xIYAG6Vyb%Larry.Finger@lwfinger.net> <200703251613.23880.mb@bu3sch.de>
In-Reply-To: <200703251613.23880.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Sunday 25 March 2007 15:45, Larry Finger wrote:
>> From: David Woodhouse <dwmw2@infradead.org>
>>
>> Recent changes in the specs that were introduced in commit 
>> 740ac4fb08866d702be90f167665d03759bd27d0 were incorrect and resulted in machine check
>> errors on the PPC architecture for G PHY's with a revision number equal to 1. The
>> two offending changes are reverted.
> 
> I'm not sure this patch is complete.
> Joseph made changes to the specs that should fix the issue completely.
> I didn't look at the changes, yet.

Joseph has fixed the problem in initb5 (the first hunk), but the second hunk is still not in the new
specs. It was in the previous version in a slightly different form, but was found largely by trial
and error.

I would prefer that this patch go forward as is so that we don't end up with this bug in the
released version of 21.6.21. I am in the process of making the initg code match the current specs,
but that will certainly require more testing than I think we have time to complete before 2.6.21 is
released.

Larry

