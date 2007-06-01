Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43392
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762980AbXFAUxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 16:53:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
Date: Fri, 1 Jun 2007 22:52:52 +0200
Cc: James Ketrenos <jketreno@linux.intel.com>,
	Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200706011129.12432.mb@bu3sch.de> <46605814.1090806@linux.intel.com> <200706011337.00087.flamingice@sourmilk.net>
In-Reply-To: <200706011337.00087.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200706012252.53086.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 01 June 2007 22:36:54 Michael Wu wrote:
> On Friday 01 June 2007 10:32, James Ketrenos wrote:
> > We definitely need to wake the queue outside of open/stop/tx.  If you stop
> > the queue due to the HW ring being full, you won't be able to wake the
> > queue until the HW has asynchronously freed a Tx slot.
> >
> Yeah, there are other safe (and correct) places like interrupt handlers. If 
> you're not seeing hard freezes with a lot of data transfer, 

It is actually pretty hard to trigger.
You need a _lot_ of traffic and you need to trigger the queue_stop
now and then. (I think we did it about every 30 seconds in bcm43xx)
With that setup it takes several minutes to trigger. (Up to about 5)

And _if_ it triggers it completely freezes the system (UP machine)
without any message. So it's pretty nasty to debug.

-- 
Greetings Michael.
