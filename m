Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:57548 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758257Ab1COSbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 14:31:03 -0400
Subject: Re: [PATCH 2/2] iwlwifi: setup agg queues with correct aggregation
 parameters
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <365ABD23-2A8B-4024-A039-879BAB879031@cs.washington.edu>
References: <365ABD23-2A8B-4024-A039-879BAB879031@cs.washington.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 11:14:36 -0700
Message-ID: <1300212876.5082.221.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

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
> ---
> Dan says: ditto from previous patch.
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   46 +++++++++++++++++++---------
>  drivers/net/wireless/iwlwifi/iwl-agn.c    |    4 ++
>  drivers/net/wireless/iwlwifi/iwl-agn.h    |    3 ++
>  drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 +
>  4 files changed, 39 insertions(+), 15 deletions(-)

I will prefer let us testing the patch first before push upstream.

Wey



