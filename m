Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:32905 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbXJZUUB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 16:20:01 -0400
Received: from [82.171.216.234] (helo=[192.168.1.2])
	by smtp-out0.tiscali.nl with esmtp (Tiscali http://www.tiscali.nl)
	id 1IlVey-0006S7-JV
	for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2007 22:20:00 +0200
Message-ID: <47224BED.9040009@tiscali.nl> (sfid-20071026_212006_814451_51B02BA8)
Date: Fri, 26 Oct 2007 22:19:57 +0200
From: Roel Kluin <12o3l@tiscali.nl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH split 8/8] fix 'and' typo's net/ieee80211/ieee80211_wx
References: <4722453E.2090801@tiscali.nl> <472248AC.7080201@tiscali.nl>
In-Reply-To: <472248AC.7080201@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

        Fix priority mistakes similar to '!x & y'
    
        Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---

diff --git a/net/ieee80211/ieee80211_wx.c b/net/ieee80211/ieee80211_wx.c
index d309e8f..623489a 100644
--- a/net/ieee80211/ieee80211_wx.c
+++ b/net/ieee80211/ieee80211_wx.c
@@ -709,7 +709,7 @@ int ieee80211_wx_get_encodeext(struct ieee80211_device *ieee,
 	} else
 		idx = ieee->tx_keyidx;
 
-	if (!ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY &&
+	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) &&
 	    ext->alg != IW_ENCODE_ALG_WEP)
 		if (idx != 0 || ieee->iw_mode != IW_MODE_INFRA)
 			return -EINVAL;
