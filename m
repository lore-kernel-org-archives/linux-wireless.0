Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46025 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab0F2RpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 13:45:17 -0400
Date: Tue, 29 Jun 2010 13:35:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Paul Stewart <pstew@google.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: auth retries if AP sends temporary deauth
Message-ID: <20100629173521.GD5296@tuxdriver.com>
References: <AANLkTilhbYTH2gKJsvqDaMzLG2cIt2tNV-GW-X0K3pNJ@mail.gmail.com>
 <1277624955.3684.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1277624955.3684.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 27, 2010 at 09:49:15AM +0200, Johannes Berg wrote:
> On Fri, 2010-06-25 at 00:33 -0700, Paul Stewart wrote:
> 
> > If a STA gets sent a DEAUTH from an AP it is actively trying to
> > authenticate to, mac80211 currently shoots itself in the foot by
> > letting  ieee80211_sta_rx_mgmt() clean up state for the connection
> > (removing an entry from authtry_bsses[] in wireless/mlme.c),
> > but the retry loop contiinues, leading to a kernel warning but no
> > connection.
> > 
> > An AP is allowed by the spec to return DEAUTH as a result of a
> > temporary failure, one of which is "you are already authenticated
> > -- what are you talking about?"
> 
> Do you know the reason code for that? I think the check here should be
> more fine-grained.

If/when you repost, please be sure to use the proper/expected format:

	http://linux.yyz.us/patch-format.html

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
