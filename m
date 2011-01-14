Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57530 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab1ANHNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 02:13:41 -0500
Received: from [71.112.48.101] (pool-71-112-48-101.sttlwa.dsl-w.verizon.net [71.112.48.101])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p0E7DeFk025113
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 13 Jan 2011 23:13:41 -0800
Message-ID: <4D2FF7A4.3070106@candelatech.com>
Date: Thu, 13 Jan 2011 23:13:40 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: No beacons generated when you bring ath9k AP interface down and up.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Been a long day, but I think I finally see the problem.

If you have an ath9k AP interface running with hostapd, and you
run:  ip link set vap0 down; ip link set vap0 up;
then it will disable beaconing.

One reason is that the ieee80211_do_open calls the
  ieee80211_bss_info_change_notify before it sets the RUNNING
flag, so it would disable beaconing.  A second is that
it doesn't set the BEACON_CHANGED flag anyway, so even if you
hack things to set RUNNING first, it still doesn't work right.

I'm not sure where the problem actually lies:  Should ath9k
start beaconing automatically on VAP interface add?  Is
it up to hostapd to detect the ifdown/ifup and re-set everything
up properly?  Or maybe it's just a very bad idea to bounce
a VAP interface with 'ip link set'?

Thanks,
Ben

--
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
