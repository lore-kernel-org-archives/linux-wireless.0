Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36155 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbaJTJdM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 05:33:12 -0400
Message-ID: <1413797588.10246.3.camel@jlt4.sipsolutions.net> (sfid-20141020_113315_313962_98966419)
Subject: Re: [PATCH] cfg80211: Warn once for delayed scan completion
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 20 Oct 2014 11:33:08 +0200
In-Reply-To: <21568.29077.518022.812356@gargle.gargle.HOWL> (sfid-20141017_033128_096362_B8AFEFAF)
References: <1413385042-17903-1-git-send-email-sujith@msujith.org>
	 <CANUX_P02O-JSQkVvBCg6L9jf8wPyzPv8O_qsZa+prTJJx+20UA@mail.gmail.com>
	 <21568.29077.518022.812356@gargle.gargle.HOWL>
	 (sfid-20141017_033128_096362_B8AFEFAF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-17 at 07:02 +0530, Sujith Manoharan wrote:

> Yes, the scan cancellation is initiated on interface removal,
> but it's async. These commits explain the race:
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/wireless/core.c?id=a617302c531eaf497ccd02a61d380efc119ba999
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/wireless/core.c?id=f9d15d162b3acf28f85b3ac05c4883e5ed588d28
> 
> We see it often with ath9k on a low-powered board, with
> a 'state manager' that plays with the interfaces.

Those commits say they *fix* the race though, so in case I was wrong you
should report the sequence of events so we can look at fixing it
properly?

I'm not going to apply this patch, it's not even a band-aid, it's only
like an aspirin pill that makes the pain go away...

johannes

