Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41498
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762026AbXFAUmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 16:42:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
Date: Fri, 1 Jun 2007 22:41:04 +0200
Cc: Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200706011129.12432.mb@bu3sch.de> <200706011204.23666.flamingice@sourmilk.net> <46605814.1090806@linux.intel.com>
In-Reply-To: <46605814.1090806@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706012241.05103.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 01 June 2007 19:32:04 James Ketrenos wrote:
> iwlwifi currently calls ieee80211_stop_queue from the Tx handler and calls ieee80211_stop_queues in the event the adapter is reset (due to HW error, RF kill transition, hw tear down, etc.) as it asynchronously brings re-initializes the hardware.

I think we do that in bcm43xx, too, and I think it is
indeed racy, too. So it may trigger the freeze, too.
A workaround might be to aquire the netdev_tx_lock around
the stop_queues call. But I'm not sure.


-- 
Greetings Michael.
