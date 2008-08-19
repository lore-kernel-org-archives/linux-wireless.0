Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:43276 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbYHSNoh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 09:44:37 -0400
Date: Tue, 19 Aug 2008 15:44:35 +0200
From: Daniel Wagner <wagi@monom.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] Use only precedence level of DSCP field for frame
	classification
Message-ID: <20080819134435.GB11660@notlob.celestrius.com> (sfid-20080819_154443_067597_CEF40621)
References: <48AA887D.5090307@monom.org> <ee101a74bd16a9467853b5ac049c5da4.squirrel@secure.sipsolutions.net> <48AA8E2C.4060303@monom.org> <48AAAD30.2080207@monom.org> <48AAB70A.4090402@monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48AAB70A.4090402@monom.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bit 4-5 of DSCP should not be considered by classify_d1. The
802.11 QoS Priority field is only depending on the precedence level.

Signed-off-by: Daniel Wagner <wagi@monom.org>
---
 net/mac80211/wme.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 4310e2f..7229e95 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -47,8 +47,6 @@ static unsigned int classify_1d(struct sk_buff *skb)
 		return 0;
 	}
 
-	if (dscp & 0x1c)
-		return 0;
 	return dscp >> 5;
 }
 
-- 
1.5.6.2

