Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:51528 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab0FIIfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 04:35:44 -0400
Received: from MSI-MTA.marvell.com (msi-mta.marvell.com [10.68.76.91]) by dakia2.marvell.com with ESMTP id a2mMstOpavwASCZd for <linux-wireless@vger.kernel.org>; Wed, 09 Jun 2010 01:35:44 -0700 (PDT)
From: Nishant Sarmukadam <nishants@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 9 Jun 2010 01:35:42 -0700
Subject: Possible leak in the ampdu aggregation code?
Message-ID: <EC64E4604C8024438259B683BB2514E1079C16BCC6@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


I wanted to get some views on a possible issue while using mac80211 ampdu support. 
skb's from pending queue for a TID are spliced onto the local pending queue when tearing down a block ack session.
If aggregation is stopped before the ampdu state becomes HT_AGG_STATE_OPERATIONAL say on addba timer expiry or if the addba request is declined, the state is changed to HT_AGG_STATE_REQ_STOP_BA_MSK |(initiator <<
HT_AGG_STATE_INITIATOR_SHIFT) in ___ieee80211_stop_tx_ba_session. 
After commit 416fbdff2137e8d8cc8f23f517bee3a26b11526f, the ampdu state needs to have HT_ADDBA_REQUESTED_MSK set, else the skb's are not spliced.
Since the ampdu state got changed in ___ieee80211_stop_tx_ba_session, this condition is not met due to which the skb's are not spliced.
tid_tx[tid] which has a pointer to the pending skb queue then gets freed leaving the skb's in the pending queue allocated forever resulting in a memory leak. Does this make sense? If yes, one way to fix the issue is modify the state in ___ieee80211_stop_tx_ba_session preserving the earlier state. This way HT_ADDBA_REQUESTED_MSK will be set and skb's will be spliced. Any other way to fix this issue? Thoughts?


Regards,
Nishant
