Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbaIEVne (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 17:43:34 -0400
Date: Fri, 5 Sep 2014 23:43:31 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	lkml20140418@newton.leun.net, Arik Nemtsov <arik@wizery.com>,
	linux@eikelenboom.it
Subject: Re: [PATCH 2/2] cfg80211: fix processing world regdomain when non
	modular
Message-ID: <20140905214331.GE17986@wotan.suse.de> (sfid-20140905_234337_985654_5C60A466)
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com> <1398137975-14275-3-git-send-email-mcgrof@do-not-panic.com> <CAGXE3d8yq_-EwacqXi2fMHC=KLU-6n=11U2wrYvpfwd++WryCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d8yq_-EwacqXi2fMHC=KLU-6n=11U2wrYvpfwd++WryCg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 02, 2014 at 02:00:00PM +0200, Helmut Schaa wrote:
> Hi Luis,
> 
> On Tue, Apr 22, 2014 at 5:39 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >
> > This allows processing of the last regulatory request when
> > we determine its still pending. Without this if a regulatory
> > request failed to get processed by userspace we wouldn't
> > be able to re-process it later. An example situation that can
> > lead to an unprocessed last_request is enabling cfg80211 to
> > be built-in to the kernel, not enabling CFG80211_INTERNAL_REGDB
> > and the CRDA binary not being available at the time the udev
> > rule that kicks of CRDA triggers.
> >
> > In such a situation we want to let some cfg80211 triggers
> > eventually kick CRDA for us again. Without this if the first
> > cycle attempt to kick off CRDA failed we'd be stuck without
> > the ability to change process any further regulatory domains.
> >
> > cfg80211 will trigger re-processing of the regulatory queue
> > whenever schedule_work(&reg_work) is called, currently this
> > happens when:
> >
> >   * suspend / resume
> >   * disconnect
> >   * a beacon hint gets triggered (non DFS 5 GHz AP found)
> >   * a regulatory request gets added to the queue
> >
> > We don't have any specific opportunistic late boot triggers
> > to address a late mount of where CRDA resides though, adding
> > that should be done separately through another patch.
> > Without an opportunistic fix then this fix relies at least
> > one of the triggeres above to happen.
> >
> > Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
> > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > ---
> >  net/wireless/reg.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> > index 081c571..625c41e 100644
> > --- a/net/wireless/reg.c
> > +++ b/net/wireless/reg.c
> > @@ -1912,7 +1912,7 @@ static void reg_process_pending_hints(void)
> >
> >         /* When last_request->processed becomes true this will be rescheduled */
> >         if (lr && !lr->processed) {
> > -               REG_DBG_PRINT("Pending regulatory request, waiting for it to be processed...\n");
> > +               reg_process_hint(lr);
> >                 return;
> >         }
> >
> 
> This change created a race in my setup (ar9344 based AP with two ath9k devices):
> Sometimes during boot the following happens:
> 
> ...
> [    6.190000] ath: Country alpha2 being used: US
> ...
> [    6.210000] ath: Country alpha2 being used: US
> ...
> [    6.240000] cfg80211: Calling CRDA for country: US
> [    6.240000] cfg80211: Calling CRDA for country: US
> [    6.240000] cfg80211: Current regulatory domain intersected:
> [    6.240000] cfg80211:  DFS Master region: unset
> [    6.240000] cfg80211:   (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp), (dfs_cac_time)
> [    6.240000] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
> (N/A, 2000 mBm), (N/A)
> [    6.240000] cfg80211:   (2457000 KHz - 2472000 KHz @ 15000 KHz),
> (N/A, 2000 mBm), (N/A)
> [    6.240000] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz),
> (N/A, 1700 mBm), (N/A)
> [    6.240000] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz),
> (N/A, 2000 mBm), (0 s)
> [    6.240000] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
> (N/A, 2000 mBm), (N/A)
> [    6.240000] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000
> KHz), (N/A, 0 mBm), (N/A)
> ...
> 
> CRDA (or in my case the internal regdb) is called twice for country
> code US by two different devices.
> In this case the second request came in before the first one was
> completely processed and the first
> request will be re-processed (due to this patch) leading to an
> intersected regdomain (US with US :) ).

Doh yeah that's an issue, thanks for reporting this.

> Reverting this patch fixes this race for me but I think you had some
> good reasons to do this patch.

Indeed.

> Any ideas?

Yeah this seems to be a corner case of the fact that we deal with
locking for the last request only through RCU and we only annotate
that the request was processed but don't add checks for when its
about to be processed. At least that's what I gather could be
the issue here given that if you see __reg_process_hint_driver()
we already check for two driver hints matching and and just
request the core to copy the existing regulatory domain onto
the new device.

        if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
            !regdom_changes(driver_request->alpha2))
                return REG_REQ_ALREADY_SET;

        return REG_REQ_INTERSECT;

The intersection would happen otherwise and I think this is caused
by a small race here. Can you try the following:

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 2599924..f3011d8 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -67,6 +67,10 @@ enum environment_cap {
  *	CRDA and can be used by other regulatory requests. When a
  *	the last request is not yet processed we must yield until it
  *	is processed before processing any new requests.
+ * @processing: tells the regulatory core if the request is currently
+ *	being processed. This is used to avoid contention on processing
+ *	a request twice since we treat only the last request atomically
+ *	with RCU.
  * @country_ie_checksum: checksum of the last processed and accepted
  *	country IE
  * @country_ie_env: lets us know if the AP is telling us we are outdoor,
@@ -82,6 +86,7 @@ struct regulatory_request {
 	enum nl80211_dfs_regions dfs_region;
 	bool intersect;
 	bool processed;
+	bool processing;
 	enum environment_cap country_ie_env;
 	struct list_head list;
 };
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1afdf45..ae35385 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1912,7 +1912,7 @@ static void reg_process_pending_hints(void)
 	lr = get_last_request();
 
 	/* When last_request->processed becomes true this will be rescheduled */
-	if (lr && !lr->processed) {
+	if (lr && !lr->processed && !lr->processing) {
 		reg_process_hint(lr);
 		return;
 	}
@@ -2595,6 +2595,7 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	}
 
 	lr = get_last_request();
+	lr->processing = true;
 
 	/* Note that this doesn't update the wiphys, this is done below */
 	switch (lr->initiator) {
