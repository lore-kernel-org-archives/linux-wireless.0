Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52010 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932414AbcK1XwJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 18:52:09 -0500
Received: from [192.168.43.60] (unknown [172.56.42.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id EE73F40B24A
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2016 15:52:08 -0800 (PST)
Message-ID: <583CC3CF.1040101@candelatech.com> (sfid-20161129_005213_046862_FC8BD006)
Date: Mon, 28 Nov 2016 15:54:55 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: OOM with pktgen when transmitting on ath10k station in 4.7.10+ kernel
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I over-drive ath10k station using pktgen, system goes OOM quickly.  If I catch it in time
and stop pktgen, then memory is recovered over the next few seconds.  I assume that there is an
un-bounded queue somewhere.

But, I cannot find any queues in the mac80211 tx path that apply to ath10k (as far as I can tell).

The one possibility is the pending queues, but printing them out with debugfs shows  them all
zeros, and I have some code to bound them at 1000 pkts anyway.

I didn't see anything obvious in ath10k either, but I must be missing something...

pktgen transmits under the queue logic, so it will likely be ignoring any
queue-stopped signals from mac80211.

Are there any other places that pkts can be queued()?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
