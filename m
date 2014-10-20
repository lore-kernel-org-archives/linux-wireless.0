Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36333 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbaJTJv5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 05:51:57 -0400
Message-ID: <1413798712.10246.14.camel@jlt4.sipsolutions.net> (sfid-20141020_115201_686175_724C46E3)
Subject: Re: [PATCH] cfg80211: Warn once for delayed scan completion
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 20 Oct 2014 11:51:52 +0200
In-Reply-To: <21572.55536.308167.684155@gargle.gargle.HOWL>
References: <1413385042-17903-1-git-send-email-sujith@msujith.org>
	 <CANUX_P02O-JSQkVvBCg6L9jf8wPyzPv8O_qsZa+prTJJx+20UA@mail.gmail.com>
	 <21568.29077.518022.812356@gargle.gargle.HOWL>
	 <1413797588.10246.3.camel@jlt4.sipsolutions.net>
	 <21572.55536.308167.684155@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-20 at 15:12 +0530, Sujith Manoharan wrote:
> Johannes Berg wrote:
> > Those commits say they *fix* the race though, so in case I was wrong you
> > should report the sequence of events so we can look at fixing it
> > properly?
> 
> The commits fix both the issues (use-after-free, new scan) correctly,
> so I don't see a race ? If the driver is slow in notifying scan completion
> and the interface is removed in the meantime, this warning is hit.

But the driver can/should just do it when the interface is removed from
it? Otherwise it has no valid way to run/continue the scan anyway?

johannes

