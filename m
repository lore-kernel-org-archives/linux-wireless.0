Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39705 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbcFORjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2016 13:39:05 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 5964940A959
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2016 10:38:59 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: mac80211 splat with pktgen on hacked 4.4 kernel.
Message-ID: <576192B2.3000304@candelatech.com> (sfid-20160615_193933_002635_D0454F8B)
Date: Wed, 15 Jun 2016 10:38:58 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4.4.11 + local hacks, including fairly extensive pktgen changes....

When I overdrive transmit on a station with pktgen, I see this
splat hit below repeatedly.  Any ideas on what kinds of things
might cause this?

		while (!skb_queue_empty(&local->pending[i])) {
			struct sk_buff *skb = __skb_dequeue(&local->pending[i]);
			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);

			if (WARN_ON(!info->control.vif)) {
				ieee80211_free_txskb(&local->hw, skb);
				continue;
			}


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

