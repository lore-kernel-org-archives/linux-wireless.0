Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22656 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaAYFq1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jan 2014 00:46:27 -0500
From: "Mani, Raja" <rmani@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes.berg@intel.com>
Subject: RE: [PATCH] nl80211: fix scheduled scan RSSI matchset attribute
 confusion
Date: Sat, 25 Jan 2014 05:46:21 +0000
Message-ID: <BD8355E3EE4C424D96D29100D45098AB42C43A80@aphydexd01a.ap.qualcomm.com> (sfid-20140125_064651_390781_C2CA632A)
References: <1390566001-9698-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1390566001-9698-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>@@ -5669,15 +5708,28 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
>                                       nla_data(ssid), nla_len(ssid));
>                                request->match_sets[i].ssid.ssid_len =
>                                        nla_len(ssid);
>+                               /* special attribute - old implemenation w/a */
>+                               request->match_sets[i].rssi_thold =
>+                                       default_match_rssi;

How about this case where RSSI is disabled for SSID1 and and SSID 4
and only SSID2 and SSID3 needs RSSI filter.

   SSID1, SSID2, RSSI, SSID3, RSSI, SSID4

Wouldn't this change set RSSI of SSID3 to SSID1 and SSID4 ?
Did i miss to understand anything ?

>+                               rssi = tb[NL80211_SCHED_SCAN_MATCH_ATTR_RSSI];
>+                               if (rssi)
>+                                       request->match_sets[i].rssi_thold =
>+                                               nla_get_s32(rssi);
>                        }
>-                       rssi = tb[NL80211_SCHED_SCAN_MATCH_ATTR_RSSI];
>-                       if (rssi)
>-                               request->rssi_thold = nla_get_u32(rssi);
