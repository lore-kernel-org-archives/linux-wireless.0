Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57464 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbXKVDLt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 22:11:49 -0500
Subject: Re: [PATCH] mac80211: free ifsta->extra_ie in ieee80211_stop
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1195658389.12000.26.camel@johannes.berg>
References: <11955417361539-git-send-email-yi.zhu@intel.com>
	 <1195565876.10920.29.camel@johannes.berg>
	 <1195615039.3250.453.camel@debian.sh.intel.com>
	 <1195658389.12000.26.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 22 Nov 2007 11:10:22 +0800
Message-Id: <1195701022.3250.496.camel@debian.sh.intel.com> (sfid-20071122_031152_140039_0A114350)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-11-21 at 16:19 +0100, Johannes Berg wrote:
> Yeah. Can you amend the patch to also clear the
> IEEE80211_STA_PRIVACY_INVOKED flag?

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 59350b8..69daf0a 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -357,6 +357,11 @@ static int ieee80211_stop(struct net_device *dev)
 			cancel_delayed_work(&local->scan_work);
 		}
 		flush_workqueue(local->hw.workqueue);
+
+		sdata->u.sta.flags &= ~IEEE80211_STA_PRIVACY_INVOKED;
+		kfree(sdata->u.sta.extra_ie);
+		sdata->u.sta.extra_ie = NULL;
+		sdata->u.sta.extra_ie_len = 0;
 		/* fall through */
 	default:
 		conf.if_id = dev->ifindex;
