Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:35889 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbZIAUL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 16:11:27 -0400
Received: from cldmz-nat-12-108-127-191.pittsburgh.intel-research.net (HELO [10.212.129.152]) (kaminsky@[12.108.127.191])
          (envelope-sender <kaminsky@csail.mit.edu>)
          by mail2.sea5.speakeasy.net (qmail-ldap-1.03) with AES256-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 1 Sep 2009 20:04:49 -0000
Message-ID: <4A9D7E79.6090000@csail.mit.edu>
Date: Tue, 01 Sep 2009 16:05:13 -0400
From: Michael Kaminsky <kaminsky@csail.mit.edu>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Jouni Malinen <jouni.malinen@atheros.com>
Subject: phy0: release an RX reorder frame due to timeout on earlier frames
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm running a git checkout of iwlwifi-2.6.git from around Aug. 10
(d229b68..).  I filed a bug report at

   http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2076

and I was asked to post my situation to this list.

I'm seeing regular "outages" when using 11n where no packets seem to go
through (card is an Intel 5300).  When this happens, I see the following
in my dmesg output:

   phy0: release an RX reorder frame due to timeout on earlier frames

(To see this message, you need to compile with CONFIG_MAC80211_HT_DEBUG.
The message comes from net/mac80211/rx.c.)

There's dmesg log attached to the above bug report which gives a
high-level picture (no extra debugging) of what happens.  I associate
(with HT), things work for a little while, and then this message is
printed out (at which point the network stops working).  If I manually
re-associate, things work again.  If I do nothing, eventually the driver
re-associates by itself, and things also work again.  Letting the driver
re-associate automatically, though, can take a while (e.g, sometimes
close to a minute).  Note that in my environment, there are multiple APs
serving the same ESSID.  This error seems to happen quite regularly.

Thanks,

Michael

