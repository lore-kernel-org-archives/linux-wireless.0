Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759233Ab3BYKUR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 05:20:17 -0500
Date: Mon, 25 Feb 2013 11:20:21 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Clean up work-queues on disassociation.
Message-ID: <20130225102020.GA1735@redhat.com> (sfid-20130225_112025_800503_40CB9108)
References: <1361326267-16847-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361326267-16847-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 19, 2013 at 06:11:07PM -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> The monitor_work and beacon_connection_loss_work items were
> not being canceled on disassociation (and not on deletion
> either).  This leads to work-items trying to run after memory
> has been deleted.
> 
> I could not find a cleaner way to do this because the
> cancel_work_sync for these items must be done outside
> of the ifmgd->mtx.
> 
> In addition, re-order the quiesce code so that timers are
> always stopped before work-items are flushed.  This was
> not the problem I saw, but I think it may still be more
> correct.

I think this patch is quite complicated and simpler solution
can be used. We stop timers on disassociate, and since
we nullify ifmgd->associated under ifmgd->mtx, work procedures
will perform no action. The only thing we should care are works
queued to workqueue internals, and stop them before we remove
the interface, to stop workqueue code to use our freed
ifmgd->*_work data.

Regarding quiesce, I'm working on suspend/resume changes where this
function become not necessary, so I'll remove it.

Below is alternative fix proposition for the problem.

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index bdddb0b..15a24214 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3992,6 +3992,17 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	/*
+	 * We canceled timers during disassoc, but works still can be pending.
+	 * Even if we they do not perform action when unassociated, we should
+	 * assure we stop them, before freeing resources.
+	 */
+	cancel_work_sync(&ifmgd->request_smps_work);
+	cancel_work_sync(&ifmgd->monitor_work);
+	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
+	cancel_work_sync(&ifmgd->csa_connection_drop_work);
+	cancel_work_sync(&ifmgd->chswitch_work);
+
 	mutex_lock(&ifmgd->mtx);
 	if (ifmgd->assoc_data)
 		ieee80211_destroy_assoc_data(sdata, false);
-- 
1.7.11.7

