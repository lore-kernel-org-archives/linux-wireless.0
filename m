Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:51504
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761172AbXFAVmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 17:42:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Olivier Cornu" <o.cornu@gmail.com>
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
Date: Fri, 1 Jun 2007 23:42:20 +0200
Cc: linux-wireless@vger.kernel.org
References: <200706011129.12432.mb@bu3sch.de> <200706012242.52226.mb@bu3sch.de> <7b4bf7ff0706011400g3d03afb6n18106773f18fade6@mail.gmail.com>
In-Reply-To: <7b4bf7ff0706011400g3d03afb6n18106773f18fade6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706012342.20592.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 01 June 2007 23:00:16 Olivier Cornu wrote:
> 2007/6/1, Michael Buesch <mb@bu3sch.de>:
> > On Friday 01 June 2007 13:55:31 Olivier Cornu wrote:
> > > Unless i missed something, stop_queue() isn't called outside of the tx
> > > handler in bcm43xx code...
> >
> > You missed something.
> 
> The only call to ieee80211_stop_queue() grep can find is in
> bcm43xx_dma.c:1171, i.e. bcm43xx_dma_tx(). And bcm43xx_dma_tx() is
> only called from bcm43xx_tx().
> What did i miss?

Periodic work. I removed that in my current tree.
And I think we also call it when resetting the device. But I'm not sure.

-- 
Greetings Michael.
