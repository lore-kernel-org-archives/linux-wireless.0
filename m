Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab1BIKzN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 05:55:13 -0500
Date: Wed, 9 Feb 2011 11:54:06 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>
Cc: "'Larry Finger'" <Larry.Finger@lwfinger.net>,
	"'John W Linville'" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	=?utf-8?B?J+WGr+aYpeeHlSc=?= <amyfcy_feng@realsil.com.cn>,
	=?utf-8?B?J+eGiuWFieWuiSc=?= <guangan_xiong@realsil.com.cn>
Subject: Re: about Mac80211 scan issue
Message-ID: <20110209105405.GB5528@redhat.com>
References: <4d4eec04.v8FQZqbn2LYPF8zs%Larry.Finger@lwfinger.net>
 <20110207151209.GG2319@redhat.com>
 <B84A4806C46340989E2A6AD2EB663300@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <B84A4806C46340989E2A6AD2EB663300@realsil.com.cn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 09, 2011 at 09:58:46AM +0800, 李朝明 wrote:
> 	recently, I found some issues on mac80211 scan about null packet.
> 	
> 	Before we switch channel in scanning, we will send null packet to AP
> to indicate that we will sleep.
> 	but at the same time there maybe lots of packets in HW tx buffer
> witch are all ready to tx but with out 
> 	power save flag set to 1. if we send this null packet after these
> tx buffer packets in a low priority,

We have ieee80211_ops->flush() method to send all pending tx frames from
hw before sending null frame. I see rtlwifi does not have it.

> this will 
> 	cause follwing null packets fail because follwing check in
> __ieee80211_tx:
> 		if (local->queue_stop_reasons[q] ||
> 		    (!txpending && !skb_queue_empty(&local->pending[q])))
> 			ret = IEEE80211_TX_PENDING;
> 
> 	But if we send these null before there tx buffer packets packets in
> a high priority, these packets will 
> 	be send after this null before switch channel. and switch channel
> will cause RX packet from AP fail abruptly,
> 	this abruptly fail will cause DELETE BA for some AP like Belkin-8233
> 11N mode or dis-associate by some AP like Dir855 5G 11N mode
> 	when we  to test Throughput use chariot
> 
> 	And I found that after power save  null packet have been sent, there
> are lots packet send to driver from mac80211,
> 	should we stop all queues after we send power save  null packet  and
> recover all queues after we send awake null packet.
> 
> 	So, I don't kown if it's a mac80211's issue, Could you give some
> help?

I'm not sure if I understand problem you described. Anyway, maybe is
enaugh to implement ->flush() in rtlwifi to solve the problem?

Stanislaw
