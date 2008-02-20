Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:37138 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762787AbYBTT7G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 14:59:06 -0500
Date: Wed, 20 Feb 2008 20:59:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH] mac80211: check endianness/types in sparse runs
Message-ID: <20080220195913.GE21139@uranus.ravnborg.org> (sfid-20080220_195930_257984_BE5BDF60)
References: <1203503909.17534.14.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1203503909.17534.14.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 20, 2008 at 11:38:29AM +0100, Johannes Berg wrote:
> Make sure sparse checks endianness when run on mac80211.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Sam, is this an OK use of makefiles or is there something else I should
> be doing?

I would prefer it to be kernel wide enabled.
Tried a defconfig build.

When I enabled __CHECK_ENDIAN I got:
8 files with > 100 warnings
14 files with 10 to 99 warnings.

So nothing that should scare a kernel hacker...

warnings without: 1686
warnings with: 2788

OK - thats a lot, but then fixing 8 files will significantly
reduce this.

	Sam
