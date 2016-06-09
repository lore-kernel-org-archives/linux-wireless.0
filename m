Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54509 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbcFIXp4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 19:45:56 -0400
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Any reason to allow MGT TID to be paused by power-save?
Message-ID: <5759FFAF.4040609@candelatech.com> (sfid-20160610_014613_099266_13AC418C)
Date: Thu, 9 Jun 2016 16:45:51 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to track down a tricky problem with a Mac book and power save
with my ath10k firmware.

At least part of the issue is that when the Mac sleeps, it goes into power-save
state as far as AP is concerned, and then it simply turns itself off.  When it wakes
up a short time later, it then tries to scan and re-associate.  But, if hostapd
hasn't timed out the station (due to longer idle timer), then STA still is treated
as being in power-save in the firmware.  It appears that this causes mgt-frames (probe responses)
not be sent back out of the firmware, so Mac gives up fairly quickly.

I fixed at least some of this by forcing a power-save wake on
receipt of probe requests and auth requests, but some issues remain
for one reason or another.

One thing that came to mind:  Is it *ever* a good idea to pause a mgt-tid due to
power-save?  A second non-pausable TID also exists in the firmware...maybe all
mgt frames should use that?  But if so, then why have a mgt tid at all?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

