Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:11519 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759113AbXGFV0G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 17:26:06 -0400
Message-ID: <468EB36C.10508@linux.intel.com>
Date: Fri, 06 Jul 2007 14:26:04 -0700
From: mabbas <mabbas@linux.intel.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: repeat scanning could cause disassoc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi
If I keep repeating scanning for like 4 times in the raw, the mac80211 
can disassociated because No ProbeResp.
looking at the rx patch if we are scanning we wont pass 
ieee80211_rx_h_passive_scan which only will deliver
beacon and probe request, which what we want, except that we only update 
last_rx in the function
ieee80211_rx_h_sta_process which is two functions down rx handlers.
In iwlwifi we do perform hw scan, in this command if scan takes a long 
time, and we are associated, it will tunes to associated channel to
allow getting beacons for a period of time, then continue with scanning. 
we do receive beacons on the associated
channel but mac80211 never update last_rx causing the disassociation.
I wonder if we can move ieee80211_rx_h_sta_process before 
ieee80211_rx_h_passive_scan or at least the rx_last
update part.
Thanks
Mohamed
