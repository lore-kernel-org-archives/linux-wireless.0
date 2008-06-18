Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37392 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbYFRJ2e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 05:28:34 -0400
Subject: Re: More 4965 woes
From: Zhu Yi <yi.zhu@intel.com>
To: Mike Kershaw <dragorn@kismetwireless.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080617132401.GA8328@drd1813.lan>
References: <20080617132401.GA8328@drd1813.lan>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 17:28:14 +0800
Message-Id: <1213781294.2625.52.camel@debian.sh.intel.com> (sfid-20080618_112916_655110_530E72AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-06-17 at 09:24 -0400, Mike Kershaw wrote:
> 1 - Inability to associate to a network on 5ghz.  Same AP on 2.4ghz
>   works fine, scanning shows the AP fine.  Sniffing with an additional
>   card shows no frames at all being sent by the 4965. AP is on a
> channel
>   the 4965 should be able to talk to according to iwlist channel (logs
> attached)

>From the log, you are trying to use channel 56 which is under radar
detection. The card must hear from the AP first in order to send. Can
you try 36? 

> 3 - Making a monitor mode vap causes a deadlock.  No logs, because the
>   system locks hard, no caps lock LED, no sysreq.  Monitoring with
>   tcpdump works for about 3 seconds, then boom.

Did you create the monitor interface via 'iw' or 'iwconfig mode
monitor'?

Thanks,
-yi

