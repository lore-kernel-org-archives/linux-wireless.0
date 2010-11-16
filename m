Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:15260 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758229Ab0KPAGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 19:06:07 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 15 Nov 2010 16:05:55 -0800
Date: Mon, 15 Nov 2010 16:06:05 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Mark Mentovai <mark@moxienet.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Fix regulatory bug with multiple cards with
 a delayed CRDA response
Message-ID: <20101116000605.GA5679@tux>
References: <1289528843-21982-1-git-send-email-lrodriguez@atheros.com>
 <AANLkTimKdqoWx2FtvJ9HG3Yj0ofROMDNo30=FJv1vVGG@mail.gmail.com>
 <20101112202732.GI25089@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <20101112202732.GI25089@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 12, 2010 at 12:27:32PM -0800, Luis Rodriguez wrote:
> On Thu, Nov 11, 2010 at 10:05:21PM -0800, Mark Mentovai wrote:
> > Luis R. Rodriguez wrote:
> > > When two cards are connected with the same regulatory domain
> > > if CRDA had a delayed response then cfg80211's own set regulatory
> > > domain would still be the world regulatory domain. There was a bug
> > > on cfg80211's ignore_request() when analyzing incoming driver
> > > regulatory hints as it was only checking against the currently
> > > set cfg80211 regulatory domain and not for any other new
> > > pending requests. This is easily fixed by also checking against
> > > the pending request.
> > 
> > Luis, thanks for taking a look at this bug.
> > 
> > Capsule summary: you’ve overloaded -EALREADY, which until now seemed
> > to mean “that’s the regdomain I’m already using,” to now also mean
> > “I’m going to be using that regdomain soon but I’m waiting on CRDA.”
> > The two cases need to be handled differently.
> > 
> > In my case, this patch makes things a little bit worse. I tested it
> > with compat_wireless 20101110. I’ve included what I see after boot
> > below the explanation.
> > 
> > Your patch changes things so that, according to the steps in my
> > original message, steps 3 and 4 become:
> > 
> > 3. The second card’s driver calls regulatory_hint to provide US as a
> > driver hint. ignore_request sees that the last request came from a
> > driver and that the current and last request sought to set the same
> > hint, so it returns -EALREADY. This triggers the “if the regulatory
> > domain being requested by the driver” block, which calls reg_copy_regd
> > on the apparent assumption that cfg80211_regdomain contains the
> > regdomain that the wiphy actually wants, although it doesn’t, and it’s
> > very wrong to do this copy. cfg80211_regdomain is still on 00, because
> > CRDA hasn’t responded to the first card’s request yet.
> > 
> > 4. When CRDA finally responds to the first card’s request from #2, it
> > gets plumbed to set_regdom, which calls __set_regdom. __set_regdom
> > sees that it’s not intersecting, and enters the block where it would
> > normally copy reg_copy_regd to set the wiphy’s regd, but the wiphy it
> > uses is the one saved from last_request (in step 3), and it already
> > had something copied to it (also in step 3). Since __set_regdom checks
> > for this and bails out with -EALREADY in the “userspace could have
> > sent two replies with only one kernel request” case. Because
> > __set_regdom fails, set_regdom returns early and never makes it to the
> > update_all_wiphy_regulatory or print_regdomain steps. The regdomain
> > remains unchanged. I’m still stuck at 00.
> > 
> > What about using something other than -EALREADY to signal “that
> > request is already pending?” On its face, this works, but I think
> > there’s a deeper flaw that also needs to be addressed. I’m concerned
> > that the wiphys that fall into this state won’t see a reg_copy_regd
> > call at all. The idea is that any such wiphy shouldn’t really be
> > ignored, but it should be joined to a group of wiphys waiting on the
> > pending request, and when the request is satisfied, the regd field
> > should be populated for each of them.
> 
> Thanks for testing and your review.
> 
> We need to address a queue of requests with the associated wiphys,
> as I originally had developed, I'll go ahead and add this and
> treat these, it should take care of even multiple cards with
> different regulatory hints. I expect the amount of code will be
> a bit to large for stable though so likely we may only be able
> to fix this for new kernels.
> 
> I'll take a stab at this now.

OK we did have the queuing mechanism in place but we were not processing
the requests atomically. Please give the patch below a shot.

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 9e103a4..356d6e3 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -43,6 +43,12 @@ enum environment_cap {
  * @intersect: indicates whether the wireless core should intersect
  * 	the requested regulatory domain with the presently set regulatory
  * 	domain.
+ * @processed: indicates whether or not this requests has already been
+ *	processed. When the last request is processed it means that the
+ *	currently regulatory domain set on cfg80211 is updated from
+ *	CRDA and can be used by other regulatory requests. When a
+ *	the last request is not yet processed we must yield until it
+ *	is processed before processing any new requests.
  * @country_ie_checksum: checksum of the last processed and accepted
  * 	country IE
  * @country_ie_env: lets us know if the AP is telling us we are outdoor,
@@ -54,6 +60,7 @@ struct regulatory_request {
 	enum nl80211_reg_initiator initiator;
 	char alpha2[2];
 	bool intersect;
+	bool processed;
 	enum environment_cap country_ie_env;
 	struct list_head list;
 };
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3be18d9..570df1e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1392,8 +1392,10 @@ new_request:
 		 * have applied the requested regulatory domain before we just
 		 * inform userspace we have processed the request
 		 */
-		if (r == -EALREADY)
+		if (r == -EALREADY) {
 			nl80211_send_reg_change_event(last_request);
+			last_request->processed = true;
+		}
 		return r;
 	}
 
@@ -1409,16 +1411,13 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 
 	BUG_ON(!reg_request->alpha2);
 
-	mutex_lock(&cfg80211_mutex);
-	mutex_lock(&reg_mutex);
-
 	if (wiphy_idx_valid(reg_request->wiphy_idx))
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
 
 	if (reg_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    !wiphy) {
 		kfree(reg_request);
-		goto out;
+		return;
 	}
 
 	r = __regulatory_hint(wiphy, reg_request);
@@ -1426,28 +1425,52 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	if (r == -EALREADY && wiphy &&
 	    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
 		wiphy_update_regulatory(wiphy, initiator);
-out:
-	mutex_unlock(&reg_mutex);
-	mutex_unlock(&cfg80211_mutex);
 }
 
-/* Processes regulatory hints, this is all the NL80211_REGDOM_SET_BY_* */
+static void reg_delayed_todo(struct work_struct *work);
+static DECLARE_DELAYED_WORK(reg_delayed_work, reg_delayed_todo);
+
+/*
+ * Processes regulatory hints, this is all the NL80211_REGDOM_SET_BY_*
+ * Regulatory hints come on a first come first serve basis and we
+ * must process each one atomically.
+ */
 static void reg_process_pending_hints(void)
 	{
 	struct regulatory_request *reg_request;
 
+	mutex_lock(&cfg80211_mutex);
+	mutex_lock(&reg_mutex);
+
+	if (!last_request->processed) {
+		REG_DBG_PRINT("Pending regulatory request, waiting "
+			      "for it to be processed...");
+		schedule_delayed_work(&reg_delayed_work, HZ / 20);
+		goto unlock;
+	}
+
 	spin_lock(&reg_requests_lock);
-	while (!list_empty(&reg_requests_list)) {
-		reg_request = list_first_entry(&reg_requests_list,
-					       struct regulatory_request,
-					       list);
-		list_del_init(&reg_request->list);
 
+	if (list_empty(&reg_requests_list)) {
 		spin_unlock(&reg_requests_lock);
-		reg_process_hint(reg_request);
-		spin_lock(&reg_requests_lock);
+		goto unlock;
 	}
+
+	reg_request = list_first_entry(&reg_requests_list,
+				       struct regulatory_request,
+				       list);
+	list_del_init(&reg_request->list);
+
+	reg_process_hint(reg_request);
+
+	if (!list_empty(&reg_requests_list))
+		schedule_delayed_work(&reg_delayed_work, HZ / 20);
+
 	spin_unlock(&reg_requests_lock);
+
+unlock:
+	mutex_unlock(&reg_mutex);
+	mutex_unlock(&cfg80211_mutex);
 }
 
 /* Processes beacon hints -- this has nothing to do with country IEs */
@@ -1494,6 +1517,12 @@ static void reg_todo(struct work_struct *work)
 	reg_process_pending_beacon_hints();
 }
 
+static void reg_delayed_todo(struct work_struct *work)
+{
+	reg_process_pending_hints();
+	reg_process_pending_beacon_hints();
+}
+
 static DECLARE_WORK(reg_work, reg_todo);
 
 static void queue_regulatory_request(struct regulatory_request *request)
@@ -1746,11 +1775,11 @@ static void restore_regulatory_settings(bool reset_user)
 	/* First restore to the basic regulatory settings */
 	cfg80211_regdomain = cfg80211_world_regdom;
 
+	regulatory_hint_core(cfg80211_regdomain->alpha2);
+
 	mutex_unlock(&reg_mutex);
 	mutex_unlock(&cfg80211_mutex);
 
-	regulatory_hint_core(cfg80211_regdomain->alpha2);
-
 	/*
 	 * This restores the ieee80211_regdom module parameter
 	 * preference or the last user requested regulatory
@@ -2061,6 +2090,8 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 
 	nl80211_send_reg_change_event(last_request);
 
+	last_request->processed = true;
+
 	mutex_unlock(&reg_mutex);
 
 	return r;
@@ -2105,10 +2136,15 @@ int __init regulatory_init(void)
 	user_alpha2[0] = '9';
 	user_alpha2[1] = '7';
 
+	mutex_lock(&cfg80211_mutex);
+	mutex_lock(&reg_mutex);
+
 	/* We always try to get an update for the static regdomain */
 	err = regulatory_hint_core(cfg80211_regdomain->alpha2);
 	if (err) {
 		if (err == -ENOMEM)
+			mutex_unlock(&cfg80211_mutex);
+			mutex_unlock(&reg_mutex);
 			return err;
 		/*
 		 * N.B. kobject_uevent_env() can fail mainly for when we're out
@@ -2125,6 +2161,9 @@ int __init regulatory_init(void)
 #endif
 	}
 
+	mutex_unlock(&reg_mutex);
+	mutex_unlock(&cfg80211_mutex);
+
 	/*
 	 * Finally, if the user set the module parameter treat it
 	 * as a user hint.
@@ -2141,6 +2180,7 @@ void /* __init_or_exit */ regulatory_exit(void)
 	struct reg_beacon *reg_beacon, *btmp;
 
 	cancel_work_sync(&reg_work);
+	cancel_delayed_work_sync(&reg_delayed_work);
 
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
