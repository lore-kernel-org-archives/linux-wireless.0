Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2556 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423250Ab2KOMtc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 07:49:32 -0500
Message-ID: <50A4E458.4090508@broadcom.com> (sfid-20121115_134935_797766_BEA7C99C)
Date: Thu, 15 Nov 2012 13:47:20 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: rework on .flush() callback
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

The brcmsmac driver still faces a lot of bug reports related to the 
.flush() callback (see [1] from Dave Jones).

Previously I had looked into this and found that during the flush the 
.tx callback still gets new frames. So I put ieee80211_stop_queues() in 
the flush and upon exit call ieee80211_wake_queues(). Due to issues 
still persisting we went a bit deeper in mac80211.

It turns out that mac80211 stops the netif queues for each interface 
(except monitor iftype) and not the internal queues during a scan. So it 
stops the netif queues, calls the flush(), and upon returning to the 
associated channel it wakes up the netif queues.

The problem here is that in brcmsmac the flush does the 
ieee80211_wake_queues() call, because that could also wakeup the netif 
queues. So doing it in the driver seems a bad idea. Any suggestion on 
how to solve this?

off topic question: boy or girl?

Gr. AvS

[1] http://codemonkey.org.uk/2012/11/09/brcmsmac-bugs/

