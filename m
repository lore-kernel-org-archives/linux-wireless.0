Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab0GTK7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 06:59:51 -0400
Subject: Re: [PATCH v3] mac80211: remove wep dependency
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1278529669-9904-1-git-send-email-linville@tuxdriver.com>
References: <1278528270-9703-1-git-send-email-linville@tuxdriver.com>
	 <1278529669-9904-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 12:59:48 +0200
Message-ID: <1279623588.3706.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-07-07 at 15:07 -0400, John W. Linville wrote:
> The current mac80211 code assumes that WEP is always available.  If WEP
> fails to initialize, ieee80211_register_hw will always fail.
> 
> In some cases (e.g. FIPS certification), the cryptography used by WEP is
> unavailable.  However, in such cases there is no good reason why CCMP
> encryption (or even no link level encryption) cannot be used.  So, this
> patch removes mac80211's assumption that WEP (and TKIP) will always be
> available for use.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> v3 -> actually post changed patch...
> v2 -> make it safe to call ieee80211_wep_free even if ieee80211_wep_init
> 	had failed

I think this is missing a change like this:

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1228,6 +1228,10 @@ static int ieee80211_scan(struct wiphy *wiphy,
 static int ieee80211_auth(struct wiphy *wiphy, struct net_device *dev,
 			  struct cfg80211_auth_request *req)
 {
+	if (req->auth_type == NL80211_AUTHTYPE_SHARED_KEY &&
+	    IS_ERR(sdata->local->wep_tx_tfm))
+		return -EINVAL;
+
 	return ieee80211_mgd_auth(IEEE80211_DEV_TO_SUB_IF(dev), req);
 }
 

since otherwise you could end up trying to encrypt the auth frame with
the uninitialised WEP TFM?

johannes

