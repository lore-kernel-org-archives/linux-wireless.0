Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([60.250.210.242]:53272 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab1BICAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 21:00:07 -0500
From: =?gb2312?B?wO6zr8P3?= <chaoming_li@realsil.com.cn>
To: 'Stanislaw Gruszka' <sgruszka@redhat.com>,
	'Larry Finger' <Larry.Finger@lwfinger.net>
CC: 'John W Linville' <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	=?gb2312?B?J7frtLrR4Cc=?= <amyfcy_feng@realsil.com.cn>,
	=?gb2312?B?J9DcueKwsic=?= <guangan_xiong@realsil.com.cn>
References: <4d4eec04.v8FQZqbn2LYPF8zs%Larry.Finger@lwfinger.net> <20110207151209.GG2319@redhat.com>
Subject: about Mac80211 scan issue
Date: Wed, 9 Feb 2011 09:58:46 +0800
Message-ID: <B84A4806C46340989E2A6AD2EB663300@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="gb2312"
In-Reply-To: <20110207151209.GG2319@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
Dear John:

	recently, I found some issues on mac80211 scan about null packet.
	
	Before we switch channel in scanning, we will send null packet to AP
to indicate that we will sleep.
	but at the same time there maybe lots of packets in HW tx buffer
witch are all ready to tx but with out 
	power save flag set to 1. if we send this null packet after these
tx buffer packets in a low priority, this will 
	cause follwing null packets fail because follwing check in
__ieee80211_tx:
		if (local->queue_stop_reasons[q] ||
		    (!txpending && !skb_queue_empty(&local->pending[q])))
			ret = IEEE80211_TX_PENDING;

	But if we send these null before there tx buffer packets packets in
a high priority, these packets will 
	be send after this null before switch channel. and switch channel
will cause RX packet from AP fail abruptly,
	this abruptly fail will cause DELETE BA for some AP like Belkin-8233
11N mode or dis-associate by some AP like Dir855 5G 11N mode
	when we  to test Throughput use chariot

	And I found that after power save  null packet have been sent, there
are lots packet send to driver from mac80211,
	should we stop all queues after we send power save  null packet  and
recover all queues after we send awake null packet.

	So, I don't kown if it's a mac80211's issue, Could you give some
help?

Thank you! 
Best regards!
lizhaoming




