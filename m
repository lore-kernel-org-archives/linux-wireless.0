Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41427 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934492Ab2DLQTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 12:19:33 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q3CGJXGn010119
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 09:19:33 -0700
Message-ID: <4F870095.90207@candelatech.com> (sfid-20120412_181938_427029_29C9B5C5)
Date: Thu, 12 Apr 2012 09:19:33 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Splat in latest wireless-testing (3.4.0-rc2+)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a few patches applied, but likely nothing that affects
this particular bit of code.

------------[ cut here ]------------
WARNING: at /home/greearb/git/linux.wireless-testing/net/mac80211/iface.c:171 ieee80211_check_queues+0x)
Hardware name: To Be Filled By O.E.M.
Modules linked in: 8021q garp stp llc fuse macvlan pktgen w83627ehf hwmon_vid nfs lockd fscache auth_rp]
Pid: 2500, comm: hostapd Not tainted 3.4.0-rc2-wl+ #9
Call Trace:
  [<c04273e4>] warn_slowpath_common+0x65/0x7a
  [<f89e814e>] ? ieee80211_check_queues+0xab/0xe8 [mac80211]
  [<c0427408>] warn_slowpath_null+0xf/0x13
  [<f89e814e>] ieee80211_check_queues+0xab/0xe8 [mac80211]
  [<f89e8a5e>] ieee80211_do_open+0x2b9/0x509 [mac80211]
  [<f89e8d04>] ieee80211_open+0x56/0x60 [mac80211]
  [<c0719ff2>] __dev_open+0x80/0xae
  [<c07181a7>] __dev_change_flags+0xa1/0x116
  [<c0719f46>] dev_change_flags+0x13/0x3f
  [<c07647ea>] devinet_ioctl+0x220/0x4ac
  [<c05987d6>] ? copy_to_user+0x2f/0x105
  [<c0765ba1>] inet_ioctl+0x82/0x9b
  [<c070b5b6>] sock_ioctl+0x1c5/0x1e7
  [<c070b3f1>] ? kernel_sendmsg+0x37/0x37
  [<c04cc572>] do_vfs_ioctl+0x460/0x49f
  [<c04c7e44>] ? path_put+0x15/0x18
  [<c04cc5f2>] sys_ioctl+0x41/0x61
  [<c07bd118>] sysenter_do_call+0x12/0x28
---[ end trace dd414f1907cc9857 ]---

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

