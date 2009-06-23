Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46467 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbZFWLTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 07:19:08 -0400
Subject: Re: [PATCH 2/2 RFC] mac80211: connect API port
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <20090622175154.GC30147@sortiz.org>
References: <20090622170409.GB30147@sortiz.org>
	 <20090622175154.GC30147@sortiz.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 13:19:07 +0200
Message-Id: <1245755947.4184.42.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-06-22 at 19:51 +0200, Samuel Ortiz wrote:
> With the connect()/disconnect() API, some of the mac80211 STA wext
> hooks can now move to cfg80211.
> 
> Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
> ---
>  net/mac80211/cfg.c  |   40 +++++++++++++++++----------
>  net/mac80211/mlme.c |   15 ----------

---
 net/mac80211/mlme.c |   54 ----------------------------------------------------
 1 file changed, 54 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-06-23 13:18:25.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-06-23 13:18:37.000000000 +0200
@@ -868,59 +868,6 @@ static u32 ieee80211_handle_bss_capabili
 	return changed;
 }
 
-static void ieee80211_sta_send_associnfo(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	char *buf;
-	size_t len;
-	int i;
-	union iwreq_data wrqu;
-
-	if (!ifmgd->assocreq_ies && !ifmgd->assocresp_ies)
-		return;
-
-	buf = kmalloc(50 + 2 * (ifmgd->assocreq_ies_len +
-				ifmgd->assocresp_ies_len), GFP_KERNEL);
-	if (!buf)
-		return;
-
-	len = sprintf(buf, "ASSOCINFO(");
-	if (ifmgd->assocreq_ies) {
-		len += sprintf(buf + len, "ReqIEs=");
-		for (i = 0; i < ifmgd->assocreq_ies_len; i++) {
-			len += sprintf(buf + len, "%02x",
-				       ifmgd->assocreq_ies[i]);
-		}
-	}
-	if (ifmgd->assocresp_ies) {
-		if (ifmgd->assocreq_ies)
-			len += sprintf(buf + len, " ");
-		len += sprintf(buf + len, "RespIEs=");
-		for (i = 0; i < ifmgd->assocresp_ies_len; i++) {
-			len += sprintf(buf + len, "%02x",
-				       ifmgd->assocresp_ies[i]);
-		}
-	}
-	len += sprintf(buf + len, ")");
-
-	if (len > IW_CUSTOM_MAX) {
-		len = sprintf(buf, "ASSOCRESPIE=");
-		for (i = 0; i < ifmgd->assocresp_ies_len; i++) {
-			len += sprintf(buf + len, "%02x",
-				       ifmgd->assocresp_ies[i]);
-		}
-	}
-
-	if (len <= IW_CUSTOM_MAX) {
-		memset(&wrqu, 0, sizeof(wrqu));
-		wrqu.data.length = len;
-		wireless_send_event(sdata->dev, IWEVCUSTOM, &wrqu, buf);
-	}
-
-	kfree(buf);
-}
-
-
 static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 				     u32 bss_info_changed)
 {
@@ -953,7 +900,6 @@ static void ieee80211_set_associated(str
 
 	ifmgd->flags |= IEEE80211_STA_PREV_BSSID_SET;
 	memcpy(ifmgd->prev_bssid, sdata->u.mgd.bssid, ETH_ALEN);
-	ieee80211_sta_send_associnfo(sdata);
 
 	ifmgd->last_probe = jiffies;
 	ieee80211_led_assoc(local, 1);


