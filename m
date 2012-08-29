Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2219 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab2H2LdF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 07:33:05 -0400
Message-ID: <503DFDE4.5030102@broadcom.com> (sfid-20120829_133347_476645_D1610AA9)
Date: Wed, 29 Aug 2012 13:32:52 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: mac80211 flush callback
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hoi Johannes,

I ma currently looking into a long standing issue with flush callback in 
brcmsmac. After some debugging I found out that mac80211 keeps pushing 
packets to brcmsmac during the flush. Is that correct? Should brcmsmac 
(or any other driver) stop the mac80211 queues during the flush? My 
assumption was that mac80211 would not do transmits during the flush, 
but it probably comes from another worker thread.

Gr. AvS

