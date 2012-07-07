Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55746 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2GGTnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2012 15:43:00 -0400
Message-ID: <1341690177.5334.2.camel@jlt3.sipsolutions.net> (sfid-20120707_214330_859248_34291513)
Subject: Re: [PATCH 1/2] mac80211: fix read outside array bounds
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Sat, 07 Jul 2012 21:42:57 +0200
In-Reply-To: <3accb52e0c55e2ac8388de7903ed6adfd964671b.1341667309.git.chunkeey@googlemail.com> (sfid-20120707_153449_534821_D143D8DC)
References: <3accb52e0c55e2ac8388de7903ed6adfd964671b.1341667309.git.chunkeey@googlemail.com>
	 (sfid-20120707_153449_534821_D143D8DC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-07-07 at 15:07 +0200, Christian Lamparter wrote:
> ieee802_1d_to_ac is defined as a const int[8],
> but the tid parameter has a range from 0 to 15.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> IMHO the patch should be correct, although it's been a while.

It looks necessary. I'd say it shouldn't be needed for stable, but it
seems safer because we could get incoming frames with TIDs that we don't
support I guess?

It's not really "correct", but as we don't support TIDs 8-15 anyway it
doesn't matter.

John, can you apply it please?

johannes

