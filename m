Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:63805 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0EUKm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 06:42:27 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o4LAg0vH024584
	for <linux-wireless@vger.kernel.org>; Fri, 21 May 2010 13:42:24 +0300
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o4LAfxou017222
	for <linux-wireless@vger.kernel.org>; Fri, 21 May 2010 13:42:00 +0300
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 0/1] cfg80211: Fix user-space crda query stall
Date: Fri, 21 May 2010 13:42:18 +0300
Message-Id: <1274438539-11259-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the user-space crda daemon fails to respond to kernel queries, the kernel
crda subsystem will stall, refusing any further regulatory hints. Details are
in the description of the patch itself.

The patch proposes a fix to the problem by adding a timeout to the user-space
crda accesses, reverting to the 00 domain if user space fails to respond. This
seems safe assuming we don't know what the rules of the requested domain and
allows further regulatory hints to be processed again.

In my testing, this patch appears to function in the various scenarios I can 
produce (user hints and 11d hints.) My understanding of the crda subsystem is
still relatively shallow, so I'm asking for your thoughts on this approach.

Comments will be appreaciated!


Juuso Oikarinen (1):
  cfg80211: Fix user-space crda query stall

 net/wireless/reg.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

