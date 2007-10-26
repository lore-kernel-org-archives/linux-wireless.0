Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:50189 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbXJZUNc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 16:13:32 -0400
Received: from [82.171.216.234] (helo=[192.168.1.2])
	by smtp-out2.tiscali.nl with esmtp (Tiscali http://www.tiscali.nl)
	id 1IlVYh-0001CN-De
	for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2007 22:13:31 +0200
Message-ID: <47224A68.4040407@tiscali.nl> (sfid-20071026_211334_294089_1D34B9CA)
Date: Fri, 26 Oct 2007 22:13:28 +0200
From: Roel Kluin <12o3l@tiscali.nl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH split 4/8] fix 'and' typo's in wireless/p54common
References: <4722453E.2090801@tiscali.nl> <472248AC.7080201@tiscali.nl>
In-Reply-To: <472248AC.7080201@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

        Fix priority mistakes similar to '!x & y' in wireless/p54common
    
        Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
index 1437db0..8ee1453 100644
--- a/drivers/net/wireless/p54common.c
+++ b/drivers/net/wireless/p54common.c
@@ -374,7 +374,7 @@ static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
 				pad = entry_data->align[0];
 
-			if (!status.control.flags & IEEE80211_TXCTL_NO_ACK) {
+			if (!(status.control.flags & IEEE80211_TXCTL_NO_ACK)) {
 				if (!(payload->status & 0x01))
 					status.flags |= IEEE80211_TX_STATUS_ACK;
 				else
