Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41653 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbbHTCQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 22:16:31 -0400
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: CT firmware beta-15 now has better monitor mode.
Message-ID: <55D5387D.9000509@candelatech.com> (sfid-20150820_041647_611370_0EE5A274)
Date: Wed, 19 Aug 2015 19:16:29 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is the changelog note.  This particular improvement does not require
any driver patches as far as I know.  I tested this on my 4.0.4+ kernel.

Should be useful for anyone doing sniffing with ath10k.

   *  Allow monitor mode to receive 'Association Request', block-ack action frames,
      nodata frames, TYPE-CTL frames.  Previously, these were not delivered to
      the WMI interface, and the kernel driver is configured to drop mgmt frames in
      the normal RX htt datapath, so host never saw them.

      This makes sniffing with ath10k a lot more useful.  When no monitor devices are
      active, the firmware reverts to the previous behaviour.  I guess the idea is that
      this is an optimization and keeps some un-needed frames off the host.

http://www.candelatech.com/ath10k.php

I'd be curious to know if anyone finds any bugs with this.  It is possible
that my changes could cause duplicate frames to be received in monitor mode,
so please keep an eye out for that.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

