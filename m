Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39869 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbZLNRVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 12:21:38 -0500
Received: by bwz27 with SMTP id 27so2201629bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 09:21:36 -0800 (PST)
Subject: mac80211 or ath9k? No connect to other band after resume
From: ASIC Felix <ic.felix@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain
Date: Mon, 14 Dec 2009 09:21:30 -0800
Message-Id: <1260811290.2612.21.camel@darkslate>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I found a suspend/resume bug.
Kernel 2.6.32-wl-45997-gf02c03a master-2009-12-07

To reproduce:
- connect to 2G network (my office)
- pm-suspend
- resume (at home, wpa_supplicant.conf only has 5G home network)
- laptop only scans 2G, never sees 5G AP
- workaround: 
    /etc/init.d/network stop
    rmmod bla bla bla
    modprobe ath9k
    /etc/init.d/network start
- now laptop reconnects


Thanks for your work folks!
Felix

