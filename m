Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:17199 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbZEFV35 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 17:29:57 -0400
Subject: Re: [ath5k-devel] ath5k: scanning while transmitting causes oops
 on 802.11a capable card
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <1241641605.4029.10.camel@johannes.local>
References: <1241626486.30590.13.camel@mj>
	 <b6c5339f0905060936u37f3994cx97cc2344224777a5@mail.gmail.com>
	 <20090506172513.GB30070@tuxdriver.com>  <1241640751.3289.2.camel@mj>
	 <1241641605.4029.10.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 06 May 2009 17:29:55 -0400
Message-Id: <1241645395.3293.3.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-05-06 at 22:26 +0200, Johannes Berg wrote:

> Huh? That's confusing. Also, you say you get a BUG but point out a
> WARN_ON_ONCE, was that an oversight or does something crash there?

Sorry, I meant WARN_ON_ONCE.

> OTOH, I can see one thing happening -- it would access scan_channel.
> Patch should fix that, does it help?

Yes, that does the trick!  Several scans with iw and iwlist while flood
pinging the AP don't cause any kernel messages.  Thank you!

-- 
Regards,
Pavel Roskin
