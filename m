Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37231 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab2J2JDi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 05:03:38 -0400
Message-ID: <1351501451.10925.6.camel@jlt4.sipsolutions.net> (sfid-20121029_100342_179656_DFD90806)
Subject: Re: [PATCH v2] wireless: Allow registering more than one beacon
 listener.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 29 Oct 2012 10:04:11 +0100
In-Reply-To: <1351288165-24219-1-git-send-email-greearb@candelatech.com> (sfid-20121026_234937_894351_D69F960C)
References: <1351288165-24219-1-git-send-email-greearb@candelatech.com>
	 (sfid-20121026_234937_894351_D69F960C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Ben,

I was going to apply this but it looks like I missed something on the
previous review:

>  void cfg80211_report_obss_beacon(struct wiphy *wiphy,
>  				 const u8 *frame, size_t len,
> -				 int freq, int sig_dbm, gfp_t gfp)
> +				 int freq, int sig_dbm)
>  {

...

> +	spin_lock_bh(&rdev->beacon_registrations_lock);
...
> +	spin_unlock_bh(&rdev->beacon_registrations_lock);

I have a feeling this is incorrect, this is called with BHs disabled, so
if we disable/enable BHs here we end up with BHs enabled even if the
caller wanted them disabled, no?

So I suppose unless we need to be able to call this from hard interrupt
in some driver (unlikely) we should add a change like this:

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 10a7f45..3b6a11a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3544,6 +3544,7 @@ void cfg80211_probe_status(struct net_device *dev, const u8 *addr,
  * Use this function to report to userspace when a beacon was
  * received. It is not useful to call this when there is no
  * netdev that is in AP/GO mode.
+ * The function must be called with BHs disabled.
  */
 void cfg80211_report_obss_beacon(struct wiphy *wiphy,
 				 const u8 *frame, size_t len,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 15ddbb8..5ff24ef 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8942,11 +8942,11 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
 
 	trace_cfg80211_report_obss_beacon(wiphy, frame, len, freq, sig_dbm);
 
-	spin_lock_bh(&rdev->beacon_registrations_lock);
+	spin_lock(&rdev->beacon_registrations_lock);
 	list_for_each_entry(reg, &rdev->beacon_registrations, list) {
 		msg = nlmsg_new(len + 100, GFP_ATOMIC);
 		if (!msg) {
-			spin_unlock_bh(&rdev->beacon_registrations_lock);
+			spin_unlock(&rdev->beacon_registrations_lock);
 			return;
 		}
 
@@ -8966,11 +8966,11 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
 
 		genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, reg->nlportid);
 	}
-	spin_unlock_bh(&rdev->beacon_registrations_lock);
+	spin_unlock(&rdev->beacon_registrations_lock);
 	return;
 
  nla_put_failure:
-	spin_unlock_bh(&rdev->beacon_registrations_lock);
+	spin_unlock(&rdev->beacon_registrations_lock);
 	if (hdr)
 		genlmsg_cancel(msg, hdr);
 	nlmsg_free(msg);


johannes

