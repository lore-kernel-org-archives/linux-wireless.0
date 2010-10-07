Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab0JGJRB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 05:17:01 -0400
Date: Thu, 7 Oct 2010 11:18:40 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Latest wireless-testing has broken scan locking.
Message-ID: <20101007091839.GC2435@redhat.com>
References: <4CAD48DA.9010208@candelatech.com>
 <1286440488.3657.23.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286440488.3657.23.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 07, 2010 at 10:34:48AM +0200, Johannes Berg wrote:
> On Wed, 2010-10-06 at 21:13 -0700, Ben Greear wrote:
> > Unless I really screwed up a merge in a strange way, the
> > ieee80211_scan_work is broken.
> > 
> > It calls mutex_unlock(&local->mtx) too many times when it hits
> > this code:
> > 
> > 		case SCAN_DECISION:
> > 			/* if no more bands/channels left, complete scan */
> > 			if (local->scan_channel_idx >= local->scan_req->n_channels) {
> > 				aborted = false;
> > 				goto out_complete;
> > 			}
> 
> So much for trusting Stanislaw :-( I can reproduce this in hwsim.
> Stanislaw, did you ever test software scan at all?

No, sorry.

> Below patch fixes this.
> 
> johannes
> 
> ---
>  net/mac80211/scan.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- wireless-testing.orig/net/mac80211/scan.c	2010-10-07 10:27:37.000000000 +0200
> +++ wireless-testing/net/mac80211/scan.c	2010-10-07 10:31:19.000000000 +0200
> @@ -693,8 +693,6 @@ void ieee80211_scan_work(struct work_str
>  		goto out_complete;
>  	}
>  
> -	mutex_unlock(&local->mtx);
> -
>  	/*
>  	 * as long as no delay is required advance immediately
>  	 * without scheduling a new work
> @@ -725,6 +723,7 @@ void ieee80211_scan_work(struct work_str
>  	} while (next_delay == 0);
>  
>  	ieee80211_queue_delayed_work(&local->hw, &local->scan_work, next_delay);
> +	mutex_unlock(&local->mtx);
>  	return;
>  
>  out_complete:

We never keep locking inside do { } while (next_delay == 0) loop,
perhaps below patch is something better:

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 2c79b83..615a831 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -693,6 +693,7 @@ void ieee80211_scan_work(struct work_struct *work)
 		case SCAN_DECISION:
 			/* if no more bands/channels left, complete scan */
 			if (local->scan_channel_idx >= local->scan_req->n_channels) {
+				mutex_lock(&local->mtx);
 				aborted = false;
 				goto out_complete;
 			}

If so, I will post it officially shortly, if not please proceed
with your patch.

Sorry again
Stanislaw
