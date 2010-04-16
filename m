Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:33510 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab0DPHi7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 03:38:59 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3G7cP4D022511
	for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 10:38:56 +0300
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o3G7cZv1003637
	for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 10:38:35 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH] mac80211: sta_cleanup timer handling
Date: Fri, 16 Apr 2010 10:35:07 +0300
Message-Id: <1271403308-23416-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sta_cleanup timer is used to expire frames in the sta structure ps_tx_buf 
-list. To perform this, the timer is executed periodically.

The timer is executed periodically, regardless if there are frames in the
buffer or not. As a result, the system gets periodically woken up for no
reason at all, wasting precious resources.

This patch proposes a simple fix. It prevent rescheduling the sta_cleanup
timer if on the particular invocation the ps_tx_buf buffers for all sta's 
were empty. On the TX path, the timer is restarted upon queueing frames to
those buffers.

Due to the way checking is performed, this approach will "leak" a few 
unnecessary invocations of the timer handler, but in the big picture those
do not matter.

Comments are appreciated.

Juuso Oikarinen (1):
  mac80211: Prevent running sta_cleanup timer unnecessarily

 net/mac80211/sta_info.c |   13 ++++++++++---
 net/mac80211/tx.c       |    7 +++++++
 2 files changed, 17 insertions(+), 3 deletions(-)

