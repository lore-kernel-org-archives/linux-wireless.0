Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36326 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbaETHtx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 03:49:53 -0400
Message-ID: <1400572176.4474.0.camel@jlt4.sipsolutions.net> (sfid-20140520_094957_475603_CFC74E96)
Subject: Re: [PATCH] mac80211: avoid "uninitialised variable" warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 20 May 2014 09:49:36 +0200
In-Reply-To: <1400571414-19116-1-git-send-email-antonio@meshcoding.com>
References: <1400571414-19116-1-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-20 at 09:36 +0200, Antonio Quartulli wrote:
> gcc is not able to correlate chan_pwr and have_chan_pwr
> in ieee80211_handle_pwr_constr(), therefore it throws a
> warning about chan_pwr being potentially used uninitialised
> even if this is not true.
> 
> However, initialise chan_pwr to 0 to silent the warning.

I don't see any warnings (even with -Wmaybe-uninitialized added
manually) and don't like gratuitous initializations, so I'll drop this.

johannes

