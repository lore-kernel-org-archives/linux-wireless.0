Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:29272 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760441AbXFASsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 14:48:00 -0400
Message-ID: <4660503C.9080309@linux.intel.com>
Date: Fri, 01 Jun 2007 09:58:36 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
References: <200706011129.12432.mb@bu3sch.de>
In-Reply-To: <200706011129.12432.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> This updates stop_queue(s) kdoc as currently there's
> a undocumented dependency.
> 
> Stopping the queue from anywhere else than the ops->tx()
> callback will result in a hard to debug deadlock and
> system freeze (on UP).
...
> --
> 
> I'd still prefer someone fixes the issue. I don't understand
> the code well enough to fix it.

Perhaps having ieee80211_stop_queue keep a mac80211 internal state flag that is checked within the Tx operation before the driver's Tx callback is made.  Then, if that bit is set, mac80211 can invoke the internal "deadlock if outside of Tx" queue stop action to halt Tx?  

In this way we are putting in a work around that doesn't result in an API change, and that can eventually (hopefully) be fixed the "right way" (whatever that may end up being)

James
