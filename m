Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from danu.mythicnet.org ([69.36.14.47]:44540 "EHLO
	danu.mythicnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab1ARFPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 00:15:47 -0500
Received: from localhost (localhost [127.0.0.1])
	by danu.mythicnet.org (Postfix) with SMTP id 84E1178352
	for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 00:15:46 -0500 (EST)
Received: from [10.1.42.221] (cpe-184-57-88-200.columbus.res.rr.com [184.57.88.200])
	by danu.mythicnet.org (Postfix) with ESMTPSA id 1552378351
	for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 00:15:45 -0500 (EST)
Message-ID: <4D3521FD.9020001@mythicnet.org>
Date: Tue, 18 Jan 2011 00:15:41 -0500
From: Ilya Kogan <ikogan@mythicnet.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] Kernel Panic on Associate with brcm80211.
References: <4D334D00.4030604@mythicnet.org>
In-Reply-To: <4D334D00.4030604@mythicnet.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm going to admit I'm fairly new to this but after some reading, I 
couldn't quite understand why there is an assertion ensuring that the 
sk_buff being sent is not cloned. I was going to see what exploded if I 
removed it and to my surprise...nothing did. In fact, except for a few

[12014.013409] wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 
382/256 dur 3562/1504

things seem to work fine. I'll be doing some more testing with this over 
the next couple of days. What obvious thing does this break horribly?

-- Ilya Kogan

  drivers/staging/brcm80211/sys/wlc_mac80211.c |    1 -
  1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c 
b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index 1d5d01a..a130386 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -5126,7 +5126,6 @@ wlc_sendpkt_mac80211(struct wlc_info *wlc, struct 
sk_buff *sdu,
         fifo = prio2fifo[prio];

         ASSERT((uint) skb_headroom(sdu) >= TXOFF);
-       ASSERT(!(sdu->cloned));
         ASSERT(!(sdu->next));
         ASSERT(!(sdu->prev));
         ASSERT(fifo < NFIFO);


