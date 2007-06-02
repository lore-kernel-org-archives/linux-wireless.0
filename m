Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:36063 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601AbXFBNR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2007 09:17:57 -0400
Received: by ug-out-1314.google.com with SMTP id j3so408684ugf
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jun 2007 06:17:55 -0700 (PDT)
Message-ID: <7b4bf7ff0706020617l4cf50359g8358e4aa2b359999@mail.gmail.com>
Date: Sat, 2 Jun 2007 15:17:55 +0200
From: "Olivier Cornu" <o.cornu@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200706012342.20592.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200706011129.12432.mb@bu3sch.de> <200706012242.52226.mb@bu3sch.de>
	 <7b4bf7ff0706011400g3d03afb6n18106773f18fade6@mail.gmail.com>
	 <200706012342.20592.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/6/1, Michael Buesch <mb@bu3sch.de>:
> On Friday 01 June 2007 23:00:16 Olivier Cornu wrote:
> > The only call to ieee80211_stop_queue() grep can find is in
> > bcm43xx_dma.c:1171, i.e. bcm43xx_dma_tx(). And bcm43xx_dma_tx() is
> > only called from bcm43xx_tx().
> > What did i miss?
>
> Periodic work. I removed that in my current tree.
> And I think we also call it when resetting the device. But I'm not sure.

I guess i see why we did not understand each other: these are calls to
ieee80211_stop_queues, not directly to ieee80211_stop_queue (even
though stop_queues ultimately calls stop_queue).
The difference is relevant because, if some kind of locking (for
example) was needed in the special contexts stop_queues only might be
called from, these locks would be held inside stop_queues, around its
stop_queue calls. :)

Is there any way to tell mac80211 the device is in a [temporary]
"non-functional" state (reset, association loss...) ?
