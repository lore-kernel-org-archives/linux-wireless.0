Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:34283 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZA1QN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 11:13:58 -0500
Received: by wf-out-1314.google.com with SMTP id 27so8150312wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 08:13:57 -0800 (PST)
Date: Wed, 28 Jan 2009 21:33:32 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: kalle.valo@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: WARN_ON message hit on enabling power save.
Message-ID: <20090128160332.GA10883@myhost.users.atheros.com> (sfid-20090128_171402_155147_C597B1A1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle,

In the function 'ieee80211_master_start_xmit',
ieee80211_stop_queues_by_reason is called and a  ps_disable_work is
queued where wake_queues is called. Can you please clarify me on why the
queues are stopped and started. If at all that needs to be stopped,
wouldn't ieee80211_dynamic_ps_enable_work be a better place to do it?

The issue is  while this ps_disable_work is queued,
netif_subqueue_stopped() is checked in _ieee80211_tx which ultimately
results in a WARN_ON(info->flags & IEEE80211_TX_CTL_AMPDU) in
ieee80211_tx. Please see the code for clarification.

So, while I try to ping after enabling power save, the packets are
dropped due to this warning.
The warning message is not at all related to the issue and hence I feel
that this is an inappropriate place for that WARN_ON. 

The fix for the issue is to remove the stop/start queues if it is not
really needed or the better fix is to remove this inappropriate warning
message. Please clarify me if I'm wrong.


Thanks for your time,
Vivek.
