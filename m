Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48991 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933678Ab1ESXNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 19:13:47 -0400
Received: by qyg14 with SMTP id 14so1822330qyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 16:13:47 -0700 (PDT)
MIME-Version: 1.0
From: Matteo Croce <matteo@openwrt.org>
Date: Fri, 20 May 2011 01:13:07 +0200
Message-ID: <BANLkTikcBcobbXzjGv4UtD952kHtrSsvNw@mail.gmail.com> (sfid-20110520_011406_423246_1F00C156)
Subject: [PATCH 2/2]: mac80211: report correct MCS information in tx status info
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Report correct MCS information in tx status info

Signed-off-by: Matteo Croce <matteo@openwrt.org>

--- a/net/mac80211/status.c	2011-05-20 00:22:56.220640264 +0200
+++ b/net/mac80211/status.c	2011-05-20 00:24:14.010640270 +0200
@@ -405,6 +405,20 @@
 	    !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS))
 		rthdr->rate = sband->bitrates[
 				info->status.rates[0].idx].bitrate / 5;
+	/* HT rates */
+	if (info->status.rates[0].flags & IEEE80211_TX_RC_MCS) {
+		rthdr->hdr.it_present |=
+				cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
+		rthdr->rate = 0;
+		rthdr->ht_known =	IEEE80211_RADIOTAP_MCS_HAVE_BW |
+					IEEE80211_RADIOTAP_MCS_HAVE_MCS |
+					IEEE80211_RADIOTAP_MCS_HAVE_GI;
+		rthdr->ht_mcs = info->status.rates[0].idx;
+		if (info->status.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			rthdr->ht_flag |= IEEE80211_RADIOTAP_MCS_BW_40;
+		if (info->status.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
+			rthdr->ht_flag |= IEEE80211_RADIOTAP_MCS_SGI;
+	}

 	/* for now report the total retry_count */
 	rthdr->data_retries = retry_count;
