Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:36333 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbZGaHQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 03:16:39 -0400
Received: by fxm17 with SMTP id 17so1203540fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 00:16:38 -0700 (PDT)
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 10:08:17 +0300
Message-Id: <1249024097.7653.6.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-29 at 14:32 -0700, Reinette Chatre wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
> 
> The connection monitor currently relies on probe requests paired
> with probe responses to ensure that a connection is alive. This is
> fragile in some environments where probe responses can get lost.
> When we receive beacons we can also consider the connection to be
> alive, so cancel connection poll instance when we receive a beacon.
> 
> The debug message "cancelling probereq poll due to a received beacon"
> is removed as part of this change as this case is hit very often after
> the above change and debug log receives significant number of these messages.

In my opinion this is the correct solution
I did plenty of wireless monitoring, and I see that nobody sends probe
requests at that rate (1 per second it seems). This is ridiculous.

According to the monitor on my iwl3945, (which might though be
incorrect), sometimes AP doesn't respond in time, but then later it
sends a storm (about 5 or so) probe responses at once (after the deauth)
I think that while wireless is fast most AP aren't, (mine is 150 Mhz
mips system for example), thus it can delay the response for more that
200 ms.

I think that the right solution is to send probes every minute or so,
and retry at last few times, before concluding that connection is lost.
(and if beacons are lost for a prolonged period it might make a sense to
send a probe earlier)

Best regards,
	Maxim Levitsky

