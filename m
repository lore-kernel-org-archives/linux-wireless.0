Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:41851 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab0EYGs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 02:48:57 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 0/1] cfg80211: Fix user-space crda query stall
Date: Tue, 25 May 2010 09:50:10 +0300
Message-Id: <1274770211-22710-1-git-send-email-juuso.oikarinen@nokia.com>
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

