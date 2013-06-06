Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:34368 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab3FFEbD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 00:31:03 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20912.4064.404766.119533@gargle.gargle.HOWL> (sfid-20130606_063108_218910_1FA8746D)
Date: Thu, 6 Jun 2013 09:58:16 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ath9k: Use minstrel rate control by default
In-Reply-To: <51B00D50.9080606@candelatech.com>
References: <1370488216-11626-1-git-send-email-sujith@msujith.org>
	<51B006AE.6080309@candelatech.com>
	<20912.2720.990590.284874@gargle.gargle.HOWL>
	<51B00D50.9080606@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> Then default to minstrel, but no need to make people re-compile their
> kernel to try a different rate control.  For some users/systems this is
> effectively impossible, and for the rest, it is an extra bit of pain.
> 
> The point of leaving ath9k rate control in is exactly to help make sure
> minstrel has something to compare against.  And if a user happens to know
> they have a clean environment always and forever, then ath9k may be
> the best solution for them.
> 
> It is a trivial amount of change to your patch to enable this
> behaviour.  In fact, if you just remove the code I mentioned then
> they will *automatically* get defaulted to minstrel regardless of
> their kernel config.  The only way to use ath9k rate control after
> that is to set the module option in mac80211 (and enable ath9k rate
> control for compilation).

Yes, I think this can be done instead, since we have always had both
ath9k RC and minstrel compiled in by default. I'll send a v2.

Sujith
