Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46976 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2FLNL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 09:11:27 -0400
Received: by eeit10 with SMTP id t10so2208193eei.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 06:11:26 -0700 (PDT)
From: Lekensteyn <lekensteyn@gmail.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Why "iwlwifi: read multiple MAC addresses"?
Date: Tue, 12 Jun 2012 15:11:20 +0200
Message-ID: <3586963.qbQ3i1FPTG@penguin> (sfid-20120612_151131_759795_10C84786)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wey-Yi,

I wonder what the following commit is used for:
commit c6fa17ed3fadaf056173c409c0877df428a152ec
Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date:   Thu Jul 15 05:58:30 2010 -0700

    iwlwifi: read multiple MAC addresses

    Some devices may have multiple MAC
    addresses in their EEPROM, read them
    and advertise them to cfg80211.

I was trying to debug wireless issues, and noticed that I had two MAC 
addresses with only the last bit being different:

    $ cat /sys/class/ieee80211/phy0/addresses
    00:23:14:xx:xx:x8
    00:23:14:xx:xx:x9

Looking at a dump provided by /sys/kernel/debug/cfg80211/phy0/iwlwifi/data/nvm, 
I see that the 16-bit word at 0x98 contains the value 4. What does this mean? 
Can this break something?

If you are interested, the wireless card I own is a Centrino Advanced-N 6200 
(device ID 422c, rev 35). I can reproduce this behaviour on Linux 3.4.2, 3.5-
rc1 (the wireless testing tree from 2012-06-11) and 3.3.5.

Regards,
Peter
