Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:18461 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaCENq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 08:46:56 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 05 Mar 2014 14:40:38 +0100
From: michael-dev <michael-dev@fami-braun.de>
To: linville@tuxdriver.com
Cc: projekt-wlan@fem.tu-ilmenau.de, linux-wireless@vger.kernel.org,
	Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCH 1/1] mac80211: fix WPA with VLAN on AP side with ps-sta again
In-Reply-To: <1360686937-17277-1-git-send-email-michael-dev@fami-braun.de>
References: <1360686937-17277-1-git-send-email-michael-dev@fami-braun.de>
Message-ID: <f54e8751cdc525ebc4d0d8abbbc96550@fami-braun.de> (sfid-20140305_144700_435568_A1DD1A4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit de74a1d9032f4d37ea453ad2a647e1aff4cd2591
   "mac80211: fix WPA with VLAN on AP side with ps-sta"
fixed an issue.
commit "7cbf9d017dbb5e3276de7d527925d42d4c11e732"
   "mac80211: fix oops on mesh PS broadcast forwarding"
essentially reverted it, because vif.type cannot be AP_VLAN
due to the check to vif.type in ieee80211_get_buffered_bc before.

As the 7cbf9 commit intended to fix the MESH case, fix it
by checking for IFTYPE_AP instead of IFTYPE_AP_VLAN.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>

---
--- compat-wireless-2014-01-23.1/net/mac80211/tx.c.orig 2014-03-05 
13:19:21.000000000 +0100
+++ compat-wireless-2014-01-23.1/net/mac80211/tx.c      2014-03-05 
13:42:25.187136039 +0100
@@ -2983,7 +2983,7 @@ ieee80211_get_buffered_bc(struct ieee802
                                 cpu_to_le16(IEEE80211_FCTL_MOREDATA);
                 }

-               if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+               if (sdata->vif.type == NL80211_IFTYPE_AP)
                         sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
                 if (!ieee80211_tx_prepare(sdata, &tx, skb))
                         break;
