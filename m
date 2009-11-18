Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129AbZKRVDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 16:03:45 -0500
Subject: Re: mac80211 breaks suspend to disk
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1258576749.8018.7.camel@maxim-laptop>
References: <1258568836.4512.13.camel@maxim-laptop>
	 <20091118202802.GE2911@tuxdriver.com>
	 <1258576749.8018.7.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 22:03:19 +0100
Message-ID: <1258578199.30511.80.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-11-18 at 22:39 +0200, Maxim Levitsky wrote:

> I forgot to pay attention to few lines before the oops message:
> 
> 
> [  331.307139] No probe response from AP 00:1b:9e:d8:77:02 after 500ms, try 1
> [  331.320121] ------------[ cut here ]------------
> [  331.334935] WARNING: at /home/maxim/software/kernel/linux-2.6/kernel/timer.c:791 add_timer+0x36/0x40()
> [  331.347374] Hardware name: Aspire 5720     
> .....

Thanks.

> This reveals that somehow the ieee80211_sta_work manages to run before
> ieee80211_sta_restart and it sets the timer....

Indeed.

> looking at ieee80211_reconfig it seems suspicious that
> 'local->suspended = false;' is set so early.
> In fact it is set again to false just prior to 
> 
> list_for_each_entry(sdata, &local->interfaces, list) {....
> 
> So, I would suspect some lines in this function trigger the work
> queue.

No, I doubt it, it's most likely just receiving a frame to trigger the
function -- ieee80211_sta_rx_mgmt queues the work. If we were still
suspended then we'd run into an error situation, like the comment in
ieee80211_reconfig explains ...

Catch-22.

Then again, we drop RX frames while local->suspended is true, and I
guess we don't really care about missing a few more frames when we're
just waking up, so it should be OK to keep suspended == true while doing
the startup.

EXCEPT drivers are going to start using ieee80211_queue_work() already
then from the callbacks, which we must allow.

So ... maybe this?

johannes

---
 net/mac80211/ieee80211_i.h |    7 +++++++
 net/mac80211/util.c        |   19 +++++++++----------
 2 files changed, 16 insertions(+), 10 deletions(-)

--- wireless-testing.orig/net/mac80211/util.c	2009-11-18 22:02:35.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-11-18 22:02:51.000000000 +0100
@@ -520,9 +520,9 @@ EXPORT_SYMBOL_GPL(ieee80211_iterate_acti
  */
 static bool ieee80211_can_queue_work(struct ieee80211_local *local)
 {
-        if (WARN(local->suspended, "queueing ieee80211 work while "
-		 "going to suspend\n"))
-                return false;
+	if (WARN(local->suspended && !local->resuming,
+		 "queueing ieee80211 work while going to suspend\n"))
+		return false;
 
 	return true;
 }
@@ -1033,13 +1033,9 @@ int ieee80211_reconfig(struct ieee80211_
 	struct sta_info *sta;
 	unsigned long flags;
 	int res;
-	bool from_suspend = local->suspended;
 
-	/*
-	 * We're going to start the hardware, at that point
-	 * we are no longer suspended and can RX frames.
-	 */
-	local->suspended = false;
+	if (local->suspended)
+		local->resuming = true;
 
 	/* restart hardware */
 	if (local->open_count) {
@@ -1137,11 +1133,14 @@ int ieee80211_reconfig(struct ieee80211_
 	 * If this is for hw restart things are still running.
 	 * We may want to change that later, however.
 	 */
-	if (!from_suspend)
+	if (!local->suspended)
 		return 0;
 
 #ifdef CONFIG_PM
+	/* first set suspended false, then resuming */
 	local->suspended = false;
+	mb();
+	local->resuming = false;
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		switch(sdata->vif.type) {
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-11-18 22:02:35.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-11-18 22:02:51.000000000 +0100
@@ -601,6 +601,13 @@ struct ieee80211_local {
 	bool suspended;
 
 	/*
+	 * Resuming is true while suspended, but when we're reprogramming the
+	 * hardware -- at that time it's allowed to use ieee80211_queue_work()
+	 * again even though some other parts of the stack are still suspended.
+	 */
+	bool resuming;
+
+	/*
 	 * quiescing is true during the suspend process _only_ to
 	 * ease timer cancelling etc.
 	 */


