Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56412 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbeDMUcI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 16:32:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 13 Apr 2018 13:32:05 -0700
From: asinghal@codeaurora.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Kiran Kumar Lokere <klokere@codeaurora.org>,
        jjohnson@codeaurora.org
Subject: Re: [PATCH 2/2] cfg80211: Modify wiphy registration semantics for
 self managed hints
In-Reply-To: <1521627352.2645.27.camel@sipsolutions.net>
References: <1520106021-16836-1-git-send-email-jouni@codeaurora.org>
 <1520106021-16836-2-git-send-email-jouni@codeaurora.org>
 <1521627352.2645.27.camel@sipsolutions.net>
Message-ID: <5f8caab7e7cfb88072c2e221ea45063e@codeaurora.org> (sfid-20180413_223212_667445_67569A93)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Johannes,
             please fine some replies inline:

On 2018-03-21 03:15, Johannes Berg wrote:
> So I really think this should just be one patch - it's not about
> "registration semantics" but about which types of requests get passed
> to reg_notifier(), and if you do it in one place you'd better also do
> it in the other.

Sure, I have combined the two patches in one patch now:

 From: Amar Singhal <asinghal@codeaurora.org>

Call the regulatory notifier for self managed hints only if
initiator is NL80211_REGDOM_SET_BY_USER and hint type is
NL80211_USER_REG_HINT_CELL_BASE. Also call regulatory
notifier when wiphy is registered under similar conditions.

Signed-off-by: Amar Singhal <asinghal@codeaurora.org>
Signed-off-by: Kiran Kumar Lokere <klokere@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
  net/wireless/reg.c | 31 +++++++++++++++++++++----------
  1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 16c7e4e..d74de76 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2768,20 +2768,25 @@ static void reg_process_hint(struct 
regulatory_request *reg_request)
  	reg_free_request(reg_request);
  }

-static bool reg_only_self_managed_wiphys(void)
+static bool reg_only_self_managed_wiphys(struct regulatory_request 
*request)
  {
  	struct cfg80211_registered_device *rdev;
  	struct wiphy *wiphy;
-	bool self_managed_found = false;
+	bool self_managed_found = true;

  	ASSERT_RTNL();

  	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
  		wiphy = &rdev->wiphy;
-		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
+		if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
  			self_managed_found = true;
-		else
-			return false;
+			if (request->initiator == NL80211_REGDOM_SET_BY_USER &&
+			    request->user_reg_hint_type ==
+			    NL80211_USER_REG_HINT_CELL_BASE)
+				reg_call_notifier(wiphy, request);
+		} else {
+			self_managed_found = false;
+		}
  	}

  	/* make sure at least one self-managed wiphy exists */
@@ -2819,7 +2824,7 @@ static void reg_process_pending_hints(void)

  	spin_unlock(&reg_requests_lock);

-	if (reg_only_self_managed_wiphys()) {
+	if (reg_only_self_managed_wiphys(reg_request)) {
  		reg_free_request(reg_request);
  		return;
  	}
@@ -3700,15 +3705,21 @@ void wiphy_regulatory_register(struct wiphy 
*wiphy)
  {
  	struct regulatory_request *lr;

-	/* self-managed devices ignore external hints */
-	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
+	lr = get_last_request();
+
+	/* self-managed devices ignore beacon hints and 11d IE */
+	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
  		wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS |
-					   REGULATORY_COUNTRY_IE_IGNORE;
+			REGULATORY_COUNTRY_IE_IGNORE;
+
+		if (lr->initiator == NL80211_REGDOM_SET_BY_USER &&
+		    lr->user_reg_hint_type == NL80211_USER_REG_HINT_CELL_BASE)
+			reg_call_notifier(wiphy, lr);
+	}

  	if (!reg_dev_ignore_cell_hint(wiphy))
  		reg_num_devs_support_basehint++;

-	lr = get_last_request();
  	wiphy_update_regulatory(wiphy, lr->initiator);
  	wiphy_all_share_dfs_chan_state(wiphy);
  }
-- 
1.9.1
> 
> Secondly, this changes behaviour - not only for ath which presumably is
> what you want, but also for
>  * brcmfmac
>  * brcmsmac
>  * libertas
>  * mwifiex
>  * mt76
>  * qtnfmac
>  * rtlwifi (& its staging cousin)
>  * rsi
>  * wlcore
>  * rtl8723bs (staging)
> 
> So I'm not really convinced we should do this unconditionally.

I am calling the callback conditionally.
Only couple of drivers are registering regulatory flag 
REGULATORY_WIPHY_SELF_MANAGED:
> drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:              
> >hw->wiphy->regulatory_flags |= REGULATORY_WIPHY_SELF_MANAGED;
above driver does not register reg_notifier callback
> drivers/net/wireless/quantenna/qtnfmac/cfg80211.c:              
> >wiphy->regulatory_flags |= REGULATORY_WIPHY_SELF_MANAGED;
> drivers/net/wireless/quantenna/qtnfmac/cfg80211.c:
> (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
Above driver registers reg_notifier callback only when flag 
REGULATORY_WIPHY_SELF_MANAGED is not defined.

Also, in this change, when REGULATORY_WIPHY_SELF_MANAGED is defined, the 
callback is conditional on request initiator being 
NL80211_REGDOM_SET_BY_USER and user_reg_hint_type being 
NL80211_USER_REG_HINT_CELL_BASE.

> 
> Johannes

regards,
Amar
