Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39471 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab2JVXsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 19:48:54 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q9MNmsoB001780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2012 16:48:54 -0700
Message-ID: <5085DB66.7020400@candelatech.com> (sfid-20121023_014858_488231_EE4955D4)
Date: Mon, 22 Oct 2012 16:48:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Add option to have more than one process listen for beacons per wiphy?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have been using one hostapd process per virtual AP interface.

With the commit below, this stopped working because the second hostapd would
fail to register as a beacon listener since the first was already registered.

commit 5e760230e42cf759bd923457ca2753aacf2e656e
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Nov 4 11:18:17 2011 +0100

     cfg80211: allow registering to beacons

     Add the ability to register to received beacon frames
     to allow implementing OLBC logic in userspace. The
     registration is per wiphy since there's no point in
     receiving the same frame multiple times.

     Signed-off-by: Johannes Berg <johannes.berg@intel.com>
     Signed-off-by: John W. Linville <linville@tuxdriver.com>


To me, this is a regression bug and worth fixing.

I would like to write up some patch that allows more than one
hostapd to run per wiphy interface (basically, one per VAP interface).

A simple means would be a fixed-length array of nlpids (with max of maybe
16 or so).  Or, could do a variable length array, or list, or some other
way to register more than one at a time.  If it were up to me, I'd choose
a fixed-length array just to keep the code simple.

Any opinions on this?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

