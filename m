Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56857 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab0JGIew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 04:34:52 -0400
Subject: Re: Latest wireless-testing has broken scan locking.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
In-Reply-To: <4CAD48DA.9010208@candelatech.com>
References: <4CAD48DA.9010208@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 10:34:48 +0200
Message-ID: <1286440488.3657.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 21:13 -0700, Ben Greear wrote:
> Unless I really screwed up a merge in a strange way, the
> ieee80211_scan_work is broken.
> 
> It calls mutex_unlock(&local->mtx) too many times when it hits
> this code:
> 
> 		case SCAN_DECISION:
> 			/* if no more bands/channels left, complete scan */
> 			if (local->scan_channel_idx >= local->scan_req->n_channels) {
> 				aborted = false;
> 				goto out_complete;
> 			}

So much for trusting Stanislaw :-( I can reproduce this in hwsim.
Stanislaw, did you ever test software scan at all?

Below patch fixes this.

johannes

---
 net/mac80211/scan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/scan.c	2010-10-07 10:27:37.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2010-10-07 10:31:19.000000000 +0200
@@ -693,8 +693,6 @@ void ieee80211_scan_work(struct work_str
 		goto out_complete;
 	}
 
-	mutex_unlock(&local->mtx);
-
 	/*
 	 * as long as no delay is required advance immediately
 	 * without scheduling a new work
@@ -725,6 +723,7 @@ void ieee80211_scan_work(struct work_str
 	} while (next_delay == 0);
 
 	ieee80211_queue_delayed_work(&local->hw, &local->scan_work, next_delay);
+	mutex_unlock(&local->mtx);
 	return;
 
 out_complete:


