Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44661 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbaEVOyx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:54:53 -0400
Message-ID: <1400770484.4174.35.camel@jlt4.sipsolutions.net> (sfid-20140522_165455_565875_3612FCC6)
Subject: Re: [PATCH v6 4/6] mac80211: use chanctx reservation for AP CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Thu, 22 May 2014 16:54:44 +0200
In-Reply-To: <1400767676-15994-5-git-send-email-michal.kazior@tieto.com> (sfid-20140522_161511_888080_631CE6DE)
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	 <1400767676-15994-5-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140522_161511_888080_631CE6DE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-22 at 16:07 +0200, Michal Kazior wrote:
> Channel switch finalization is now 2-step. First
> step is when driver calls csa_finish(), the other
> is when reservation is actually finalized (which
> be defered for in-place reservation).
> 
> It is now safe to call ieee80211_csa_finish() more
> then once.

But you'll WARN_ON() if they're actually not at the same time and you
grab a beacon (or for the template case, call csa_update) in the
meantime, right? I'd really like to have all those driver requirements
(e.g. to stop beaconing) better documented.

johannes

