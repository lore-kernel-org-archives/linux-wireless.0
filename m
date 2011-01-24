Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49282 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab1AXDpC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 22:45:02 -0500
Received: by qyk12 with SMTP id 12so4042619qyk.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Jan 2011 19:45:01 -0800 (PST)
Message-ID: <4D3CF5E3.4060507@lwfinger.net>
Date: Sun, 23 Jan 2011 21:45:39 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Question about rate control
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to use a special rate-control algorithm. ATM, this is necessary
because I don't know how to get the retry info from the firmware. This setup
worked fine with rtl8192ce using a fixed name compiled in the rate_control_ops
struct. The problem is that this code is also used by a new USB driver named
rtl8192cu that shares the rtlwifi module with the PCIe driver. When both are
loaded, the second gets a duplicate name warhing. To fix this, I have set up
code that generates a unique name, but it doesn't work. To help debug, I added a
printk to dump the name used in every call to ieee80211_rate_control_register().
The result of that printk is shown below. The 3rd value listed is my new one and
all looks OK; however, the selected rate control is "minstrel_ht", not my
special one.

ops->name: minstrel
ops->name: minstrel_ht
--snip--
ops->name: rtl-rc-0
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'

Any thoughts on what might be wrong, or what values should be dumped for debugging?

Thanks,

Larry
