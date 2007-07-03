Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42954 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbXGCMcM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 08:32:12 -0400
Message-ID: <468A41A3.1020903@trash.net>
Date: Tue, 03 Jul 2007 14:31:31 +0200
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC] mac80211: Make stop_queues() usable
References: <200707022235.38791.mb@bu3sch.de> <200707022109.23527.flamingice@sourmilk.net> <200707031039.56710.mb@bu3sch.de>
In-Reply-To: <200707031039.56710.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Tuesday 03 July 2007 06:09:19 Michael Wu wrote:
> 
>>On Monday 02 July 2007 13:35, Michael Buesch wrote:
>>
>>>+	netif_tx_lock_bh(mdev);
>>> 	for (i = 0; i < hw->queues; i++)
>>> 		ieee80211_stop_queue(hw, i);
>>>+	netif_tx_unlock_bh(mdev);
>>
>>Well, looks like this will break stopping all tx queues from the tx handler by 
>>deadlocking. It may be useless for bcm43xx to call ieee80211_stop_queue, but 
>>there are other drivers which rely on it.


The wireless multiqueue handling should be replaced by the generic
implementation in net-2.6.23 (using prio, seperating out the wme
classifier and killing the broken scheduler). You don't need to
stop individual subqueues for a full shutdown with that implementation,
you can just stop the global queue. Not sure if that really helps for
this case though since I didn't look to deep into this code.

