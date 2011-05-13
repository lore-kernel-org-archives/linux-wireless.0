Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:42240 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759568Ab1EMRSy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 13:18:54 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 10:18:25 -0700
Date: Fri, 13 May 2011 22:48:49 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: cancel scan_work in ieee80211_unregister_hw
Message-ID: <20110513171849.GA2760@vmraj-lnx.users.atheros.com> (sfid-20110513_191858_814882_41682109)
References: <1305220188-13098-1-git-send-email-rmanoharan@atheros.com>
 <1305221121.3461.32.camel@jlt3.sipsolutions.net>
 <20110513053533.GA20459@vmraj-lnx.users.atheros.com>
 <1305301416.3468.9.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1305301416.3468.9.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 13, 2011 at 09:13:36PM +0530, Johannes Berg wrote:
> On Fri, 2011-05-13 at 11:05 +0530, Rajkumar Manoharan wrote:
> 
> > > How did you come to that conclusion? ieee80211_do_stop() does stop the
> > > scan.
> > >
> > True. But Sometimes ieee80211_scan_cancel is waiting for mutex where
> > the lock was already aquired by scan work and scan_work never releases
> > the lock till scan completion whenever next_delay == 0.
> 
> But that shouldn't take a long time. And if it's "stuck" there, then
> cancel_delayed_work_sync() will also wait for it.
>
Agree. cancel_delayed_work_sync does not help to abort scan when
scan_work is in next_scan_state loop.

> > This scenario was observed while unplug the card during scan.
> 
> If this happens then mac80211 will still make calls to the driver, I
> don't think we can avoid this and drivers will need to handle it. Maybe
> the driver is repeatedly timing out somewhere?
>
These unneccesary driver calls has to be avoided. How about the following
change to abort scan during scan loop.

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 4054399..9d18c43 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -384,11 +384,11 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
        int i;
        enum nl80211_channel_type orig_ct;
 
+       clear_bit(SDATA_STATE_RUNNING, &sdata->state);
+
        if (local->scan_sdata == sdata)
                ieee80211_scan_cancel(local);
 
-       clear_bit(SDATA_STATE_RUNNING, &sdata->state);
-
        /*
         * Stop TX on this interface first.
         */
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index ea44a8e..6353f93 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -719,6 +719,11 @@ void ieee80211_scan_work(struct work_struct *work)
         * without scheduling a new work
         */
        do {
+               if (!test_bit(SDATA_STATE_RUNNING, &sdata->state)) {
+                       aborted = true;
+                       goto out_complete;
+               }
+
                switch (local->next_scan_state) {
                case SCAN_DECISION:
                        /* if no more bands/channels left, complete scan */

--
Rajkumar
