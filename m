Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:52091 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbcDQWKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Apr 2016 18:10:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tina Ruchandani <ruchandani.tina@gmail.com>,
	y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] prism54: isl_38xx: Replace 'struct timeval'
Date: Mon, 18 Apr 2016 00:10:48 +0200
Message-ID: <4679823.7bDEQhE9qO@wuerfel> (sfid-20160418_001118_552771_C10EA7BC)
In-Reply-To: <1460896953.15362.2.camel@sipsolutions.net>
References: <20160413060916.GA21184@localhost> <5521267.mr5HLCdTY6@wuerfel> <1460896953.15362.2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 17 April 2016 14:42:33 Johannes Berg wrote:
> 
> I was thinking more restrictively of just the stuff that can't even be
> built without modifying the sources - like the "#if VERBOSE" thing.

All the DEBUG() statements are inside of this kind of check, so if we
remove the #ifdefs, it would be logical to remove the rest of the debugging
infrastructure (DEBUG() macros, SHOW_*, pc_debug, maybe more) as well.

	Arnd
