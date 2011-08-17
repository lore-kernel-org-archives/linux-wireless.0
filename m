Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:52867 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754022Ab1HQWFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 18:05:51 -0400
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0LQ300ILZDBO5TB0@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Wed, 17 Aug 2011 23:35:48 +0200 (CEST)
Received: from hbook.dsl ([unknown] [77.180.174.198])
 by relay-auth-2.ms.rz.rwth-aachen.de
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec  9 2008))
 with ESMTPA id <0LQ3004MDDBNDR30@relay-auth-2.ms.rz.rwth-aachen.de> for
 linux-wireless@vger.kernel.org; Wed, 17 Aug 2011 23:35:48 +0200 (CEST)
From: Hanno Wirtz <hanno.wirtz@comsys.rwth-aachen.de>
Subject: Multiple virtual interfaces, ath9k
Date: Wed, 17 Aug 2011 23:35:47 +0200
Message-id: <6FA32078-B95C-47B6-98C8-17DE81CE5FE5@comsys.rwth-aachen.de> (sfid-20110818_000600_535801_B5F3930F)
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

I am having problems with the operation of multiple virtual interfaces. 
A short scenario description : 

I would like to provide two independent wifi networks at my device, both using a virtual AP interface. 
Furthermore, I would like to dynamically associate to (multiple) other networks using dynamically created STA interfaces. 
This results in two AP interfaces that are permanently active and at least one (up to 5) STA interface(s) that run(s) concurrently. 
I use Ubuntu kernel 3.1-rc2 with compat-wireless-3.1, the machine has an Atheros AR9285 wireless chip.

>From what I read, this should be possible, and in fact *some* combinations work, i.e. 2 AP interfaces, 1 AP + 1 STA and 2 STA interfaces. 
However, adding a STA interface or an AP interface respectively, causes the connections to all associated stations to be terminated in the case of AP interfaces.
In the case of STA interfaces, no working association to a network is possible. 
The debug output in /var/log/syslog and in /sys/kernel/debug/ieee80211/phy*/ath9k is rather inconclusive to me, as I only seem to find notifications and 
statistics. The only thing I found so far that could be the cause for such behavior is the "ieee80211_iface_combination" structure in compat-wireless, 
in which the number, types and allowed combination of virtual interfaces is set. 

I would be happy to work on the driver code itself, however I am a bit clueless where to start and what actual *errors* to search and fix.
If anyone could point me to something, that would help me a lot. If that helps, I can post complete syslog and debug traces tomorrow. 

Thanks a lot in advance, 

Hanno
