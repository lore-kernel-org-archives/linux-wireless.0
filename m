Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34585 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab1BOTAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 14:00:35 -0500
Date: Tue, 15 Feb 2011 13:49:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [PATCH] zd1211rw: change endpoint types of EP_REGS_OUT and
 EP_INT_IN from interrupt to bulk
Message-ID: <20110215184945.GF2557@tuxdriver.com>
References: <20110206083522.16858.24185.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110206083522.16858.24185.stgit@fate.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 06, 2011 at 10:35:22AM +0200, Jussi Kivilinna wrote:
> This fixes high CPU usage when writing beacon frame to hardware. With this
> patch CPU usage of kworker on Intel Atom with 100 TU beacon interval goes
> from ~10% down to <1%.
> 
> Checking vendor driver appears it's also ignoring fact that endpoints are
> interrupt type and is using bulk urbs on these.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

This patch led to a lengthy thread.  I'm not 100% clear on the
outcome, but it seems like the conclusion was that the driver should
be doing something else -- at least that seemed to be the conclusion
for ath9k_htc.

So, is this patch still wanted?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
