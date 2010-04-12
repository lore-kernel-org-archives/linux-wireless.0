Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:19015 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752304Ab0DLHhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 03:37:04 -0400
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-011617816
	for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 16:36:59 +0900 (JST)
Subject: [PATCH 1/2] mac80211: Use G mandatory rates in 2GHz band
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 12 Apr 2010 16:36:58 +0900
Message-ID: <20100412073658.28078.32155.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This changes the mandatory (basic) rates in the 2GHz band to the ERP mandatory
rates (1, 2, 5.5, 11, 6, 12, 24Mbps - as defined in 802.11 section 19.1.)
instead of the "B" mode basic rate (1Mbps - why not 2Mbps too?).

B-only drivers (are there any?) should still work with this change, since they
simply don't have the faster rates. The functional change is that we now
default to faster basic rates, but as far as i can tell this is only really
used in IBSS code (STAs have to adapt to their AP).

BTW: Is there a way to configure mac80211 to B-only mode or G-only mode? When
this is the case this has to be revised...

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 net/mac80211/util.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 2b75b4f..282bda9 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -844,7 +844,8 @@ u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 	}
 
 	if (band == IEEE80211_BAND_2GHZ)
-		mandatory_flag = IEEE80211_RATE_MANDATORY_B;
+		mandatory_flag = IEEE80211_RATE_MANDATORY_B |
+				 IEEE80211_RATE_MANDATORY_G;
 	else
 		mandatory_flag = IEEE80211_RATE_MANDATORY_A;
 

