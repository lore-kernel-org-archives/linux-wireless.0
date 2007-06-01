Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:32859 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764949AbXFAUwk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 16:52:40 -0400
Received: by nf-out-0910.google.com with SMTP id g13so17128nfb
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jun 2007 13:52:38 -0700 (PDT)
Message-ID: <7b4bf7ff0706011352h767cc901l2636dfa60d3faaaa@mail.gmail.com>
Date: Fri, 1 Jun 2007 22:52:38 +0200
From: "Olivier Cornu" <o.cornu@gmail.com>
To: "James Ketrenos" <jketreno@linux.intel.com>
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	"Michael Buesch" <mb@bu3sch.de>, "Jiri Benc" <jbenc@suse.cz>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46605814.1090806@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200706011129.12432.mb@bu3sch.de>
	 <4660503C.9080309@linux.intel.com>
	 <200706011204.23666.flamingice@sourmilk.net>
	 <46605814.1090806@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/6/1, James Ketrenos <jketreno@linux.intel.com>:
> Michael Wu wrote:
> > A workaround could be implemented, but I currently don't see any cases where
> > stopping/waking the queue outside of open/stop/tx is necessary or correct.
>
> Is calling the ieee80211_stop_queue[s] from open/stop OK then?  The doc update said only in ops->tx.  Should the driver be calling it in the stop callback, or will the stack stop the queues for us?
>
> iwlwifi currently calls ieee80211_stop_queue from the Tx handler and calls ieee80211_stop_queues in the event the adapter is reset (due to HW error, RF kill transition, hw tear down, etc.) as it asynchronously brings re-initializes the hardware.

Out of pure "design intuition", there seems to be a real difference
between stop_queue and stop_queues. In other words, stop_queues should
not be seen as just a shortcut for multi-ring devices, as each should
actually be called from different contexts:
 - stop_queue will indeed stop one queue only, but stopping a single
queue seems to make sense only on tx (when a tx_ring gets full).
 - stop_queues on the other hand means stop all queues, and this
should only be needed on stop, reset, etc (why would you stop all
queues on tx?). In this regard, a single ring device should probably
still call stop_queues in these contexts.
(The same difference makes sense for the wake_... counterparts)

--
Olivier Cornu
