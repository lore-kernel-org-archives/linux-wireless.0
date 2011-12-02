Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:57241 "HELO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753223Ab1LBJl0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 04:41:26 -0500
Date: Fri, 2 Dec 2011 15:11:25 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: nishants@marvell.com, linux-wireless@vger.kernel.org
Subject: Memory Leak in AMPDU
Message-ID: <20111202094123.GB5808@hertz.marvell.com> (sfid-20111202_104129_744336_CBA7657D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes, 

We have observed memory leaks because of ampdu tx pending queue not
being freed before destroying the station info. In
'__sta_info_destroy' when we attempt the destroy the ampdu sessions
in 'ieee80211_sta_tear_down_BA_sessions', the driver calls
'ieee80211_stop_tx_ba_cb_irqsafe' to delete the ampdu structures
(tid_tx) and splice the pending queues and this job gets queued in
sdata workqueue.

However, the sta entry can get destroyed before the above work gets
scheduled and hence the race. Purging the queues and freeing the
tid_tx would avoid the leak, but I wanted to get your thoughts before
attempting to fix this cleanly. 

Thanks
Yogesh
