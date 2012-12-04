Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40547 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab2LDWfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 17:35:08 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so2389064qcr.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Dec 2012 14:35:08 -0800 (PST)
Date: Tue, 4 Dec 2012 14:35:04 -0800
From: Jason Abele <jason@cozybit.com>
To: linux-wireless@vger.kernel.org
Subject: mac80211: tx timeout notification for mac80211 drivers?
Message-ID: <20121204223504.GD4428@liveoak> (sfid-20121204_233512_993448_A6658A5F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Perhaps I am missing something, but is there a way for mac80211 drivers
to be notified of timeouts on their tx queues, or does each have to
implement its own watchdog?

net_device_ops provides an ndo_tx_timeout hook for netdevices, but
mac80211 seems not to implement this hook.

Bob Copeland pointed me at some history that seems to indicate mac80211
dropped the ndo_tx_timeout functionality because net_device lacked
multi-queue support: http://marc.info/?l=linux-wireless&m=117449935910306

Looks like net_device has multi-queue support now, should we bring back
ieee80211_tx_timeout or something similar?

Thanks
Jason
