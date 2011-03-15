Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51764 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758283Ab1COS3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 14:29:07 -0400
Subject: Re: [PATCH 2/2] iwlwifi: setup agg queues with correct aggregation
 parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <365ABD23-2A8B-4024-A039-879BAB879031@cs.washington.edu>
References: <365ABD23-2A8B-4024-A039-879BAB879031@cs.washington.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 19:29:06 +0100
Message-ID: <1300213746.4139.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-15 at 11:25 -0700, Daniel Halperin wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> 
> See this thread for more information:
> http://comments.gmane.org/gmane.linux.kernel.wireless.general/66236
> 
> > the window size and frame limit should
> > both match the information about the aggregation session, and be limited
> > to what we and the peer would like to see.
> >
> > The bad thing is that we set up the queue when we get
> > IEEE80211_AMPDU_TX_START, but we only know the window size when we get
> > IEEE80211_AMPDU_TX_OPERATIONAL. However, I think we can change this
> > since the first TX to the queue will only happen after _OPERATIONAL. We
> > just need to refactor iwlagn_tx_agg_start() into the parts that can
> > fail, and the parts that don't.
> 
> From: Johannes Berg <johannes@sipsolutions.net>
> Tested-by: Daniel Halperin <dhalperi@cs.washington.edu>
> Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>

Thanks for testing, I actually have versions with better changelogs
already so I'll go and submit those.

johannes

