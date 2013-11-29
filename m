Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27065 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab3K2NzI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 08:55:08 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MX10037P2NU1X50@mailout3.w1.samsung.com> for
 linux-wireless@vger.kernel.org; Fri, 29 Nov 2013 13:55:06 +0000 (GMT)
Message-id: <52989CB9.3060108@samsung.com> (sfid-20131129_145512_935705_097D9797)
Date: Fri, 29 Nov 2013 17:55:05 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
MIME-version: 1.0
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: question about generalized way for RSSI notification
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear wireless subsystem maintainers,

I have a question regarding RSSI notification to the user space.
Right now this information available in /proc/net/wireless.
That generalized method is not depending on driver implementation, 
driver just need to provide wireless statistics.

I found 2 places in kernel which report about RSSI to user space eventually.
First place, it's wlan_rndis driver base implementation 
./drivers/net/wireless/rndis_wlan.c.
The second place, it's mac80211 driver - beacon frame handling.

Unfortunately wireless driver we're using isn't rndis based and isn't 
mac80211 based.
We don't want to depends on driver code.

What community think in this situation, is it possible to add notifier 
with following responsibility:
     send netlink notification in case of signal level changed according 
to predefined by user threshold?

Technically it will looks like rndis_wlan approach - timer function with 
predefined frequency.

This functionality is needed to reduce user space daemon activity which 
provides information to GUI wifi indicator.
Also such approach could decrease time reaction on signal level changes. 
Currently, some OSes has 1 second interval,
another one has 3 seconds for checking RSSI.

-- 
Best regards,
Alexey Perevalov
