Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56251 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab0JDRWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 13:22:38 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o94HMcO5032403
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 4 Oct 2010 10:22:38 -0700
Message-ID: <4CAA0D5E.2090700@candelatech.com>
Date: Mon, 04 Oct 2010 10:22:38 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Putting APs into bridges?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I got a bug report from someone using my ath5k VAP patch.

It seems he put two VAPs into a bridge device, and got an
assert here (nevermind the printk, I just added that to
help debug the issue).

static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
				   enum queue_stop_reason reason)
{
	struct ieee80211_local *local = hw_to_local(hw);
	struct ieee80211_sub_if_data *sdata;

	trace_wake_queue(local, queue, reason);

	if (WARN_ON(queue >= hw->queues)) {
		printk(KERN_WARNING "%s:  queue: %i  hw->queues: %i\n",
		       sdata->name, queue, hw->queues);
		return;
	}


Before I try to reproduce this, it is valid to add APs to bridge
devices in the first place?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

