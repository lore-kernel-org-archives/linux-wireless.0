Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3GaTQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 15:16:04 -0400
Message-ID: <1375298159.8289.17.camel@jlt4.sipsolutions.net> (sfid-20130731_211608_922691_0459C342)
Subject: Re: [PATCH] mac80211: fix infinite loop in
 ieee80211_determine_chantype
From: Johannes Berg <johannes@sipsolutions.net>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-wireless@vger.kernel.org, Derek Atkins <DAtkins@mocana.com>
Date: Wed, 31 Jul 2013 21:15:59 +0200
In-Reply-To: <20130731191224.GB28308@sequoia2.sous-sol.org>
References: <20130731191224.GB28308@sequoia2.sous-sol.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-07-31 at 12:12 -0700, Chris Wright wrote:
> Commit "3d9646d mac80211: fix channel selection bug" introduced a possible
> infinite loop by moving the out target above the chandef_downgrade
> while loop.  When we downgrade to NL80211_CHAN_WIDTH_20_NOHT, we jump
> back up to re-run the while loop...indefinitely.  Replace goto with
> break and carry on.  This may not be sufficient to connect to the AP,
> but will at least keep the cpu from livelocking.  Thanks to Derek Atkins
> as an extra pair of debugging eyes.

Applied, thanks.

johannes

