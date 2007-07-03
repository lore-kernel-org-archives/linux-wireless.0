Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38907
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbXGCRtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 13:49:13 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH RFC] mac80211: Make stop_queues() usable
Date: Tue, 3 Jul 2007 19:47:56 +0200
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200707022235.38791.mb@bu3sch.de> <200707031936.24084.mb@bu3sch.de> <200707031041.27895.flamingice@sourmilk.net>
In-Reply-To: <200707031041.27895.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200707031947.56602.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 03 July 2007 19:41:22 Michael Wu wrote:
> On Tuesday 03 July 2007 10:36, Michael Buesch wrote:
> > the _only_ place where it's sane to call stop_queues (to stop all queues)
> > is outside of the TX handler. Why would you stop all queues inside of
> > the TX path?
> isl38xx cards (p54) need the host to manage the memory that frames are copied 
> to before the card transmits. If the card's memory gets filled up, all queues 
> need to be stopped.

Ah, yeah. Well. I was mainly talking about modern cards with
modern DMA rings. ;) But Ok. This card may want to stop all
queues from the TX path.
On bcm43xx each queue is seperate and can run
concurrently, though.


-- 
Greetings Michael.
