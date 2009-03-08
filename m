Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:47395 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463AbZCHQ2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2009 12:28:53 -0400
To: Adam Baker <linux@baker-net.org.uk>
cc: Anders Eriksson <aeriksson@fastmail.fm>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] No ProbeResp == dead interface?
In-reply-to: <200902212123.21950.linux@baker-net.org.uk>
References: <20090218205849.5723293CD93@tippex.mynet.homeunix.org> <200902202307.34035.linux@baker-net.org.uk> <20090221145528.5B11B2C4090@tippex.mynet.homeunix.org> <200902212123.21950.linux@baker-net.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 08 Mar 2009 17:20:23 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20090308162023.BBD122C40D0@tippex.mynet.homeunix.org> (sfid-20090308_172857_136280_3E315708)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


So, 
Now it has happened again. :-(

I can conclude that a rmmod/modprobe cycle does not help. 

Some logs:

At around noon, there was some hickup, from which we recovered:
Mar  8 12:54:30 tippex wlan0: deauthenticated (Reason: 7)
Mar  8 12:54:31 tippex wlan0: direct probe to AP 00:18:39:c0:5f:50 try 1
Mar  8 12:54:31 tippex wlan0 direct probe responded
Mar  8 12:54:31 tippex wlan0: authenticate with AP 00:18:39:c0:5f:50
Mar  8 12:54:31 tippex wlan0: authenticated
Mar  8 12:54:31 tippex wlan0: associate with AP 00:18:39:c0:5f:50
Mar  8 12:54:31 tippex wlan0: RX ReassocResp from 00:18:39:c0:5f:50 (capab=0x431 status=0 aid=1)
Mar  8 12:54:31 tippex wlan0: associated


The, at 15:18, we got the dreaded "No ProbeResp" again. Now I have a debugfs 
dump for that time as well:
Mar  8 15:09:01 tippex cron[6326]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar  8 15:09:02 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar  8 15:09:02 tippex wlan_queue: 14   0       24      51143   23      0       0
Mar  8 15:09:02 tippex wlan_queue: 0    4233    24      0       9       9       0
Mar  8 15:09:02 tippex wlan_queue: 1    1356551 24      0       23      23      0
Mar  8 15:09:02 tippex wlan_queue: 16   0       1       0       0       0       0
Mar  8 15:09:02 tippex wlan_queue: 17   0       8       0       0       0       0
Mar  8 15:10:01 tippex cron[6334]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar  8 15:10:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar  8 15:10:01 tippex wlan_queue: 14   0       24      51854   14      0       0
Mar  8 15:10:01 tippex wlan_queue: 0    4235    24      0       11      11      0
Mar  8 15:10:01 tippex wlan_queue: 1    1356618 24      0       18      18      0
Mar  8 15:10:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar  8 15:10:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar  8 15:11:01 tippex cron[6362]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar  8 15:11:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar  8 15:11:01 tippex wlan_queue: 14   0       24      52586   2       0       0
Mar  8 15:11:01 tippex wlan_queue: 0    4236    24      0       12      12      0
Mar  8 15:11:01 tippex wlan_queue: 1    1356712 24      0       16      16      0
Mar  8 15:11:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar  8 15:11:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar  8 15:12:01 tippex cron[6379]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar  8 15:12:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar  8 15:12:01 tippex wlan_queue: 14   0       24      53363   11      0       0
Mar  8 15:12:01 tippex wlan_queue: 0    4237    24      0       13      13      0
Mar  8 15:12:01 tippex wlan_queue: 1    1356822 24      0       6       6       0
Mar  8 15:12:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar  8 15:12:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar  8 15:13:01 tippex cron[6386]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar  8 15:13:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar  8 15:13:01 tippex wlan_queue: 14   0       24      54037   13      0       0
Mar  8 15:13:01 tippex wlan_queue: 0    4238    24      0       14      14      0
Mar  8 15:13:01 tippex wlan_queue: 1    1356876 24      0       12      12      0
Mar  8 15:13:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar  8 15:13:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar  8 15:14:01 tippex cron[6392]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar  8 15:14:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar  8 15:14:01 tippex wlan_queue: 14   0       24      54762   18      0       0
Mar  8 15:14:01 tippex wlan_queue: 0    4239    24      0       15      15      0
Mar  8 15:14:01 tippex wlan_queue: 1    1356949 24      0       13      13      0
Mar  8 15:14:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar  8 15:14:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar  8 15:14:18 tippex wlan0: No ProbeResp from current AP 00:18:39:c0:5f:50 - assume out of range
Mar  8 15:15:01 tippex cron[6397]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar  8 15:15:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar  8 15:15:01 tippex wlan_queue: 14   0       24      55174   22      0       0
Mar  8 15:15:01 tippex wlan_queue: 0    4243    24      0       19      19      0
Mar  8 15:15:01 tippex wlan_queue: 1    1356953 24      0       17      17      0
Mar  8 15:15:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar  8 15:15:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar  8 15:16:01 tippex cron[6404]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar  8 15:16:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar  8 15:16:01 tippex wlan_queue: 14   0       24      55791   15      0       0
Mar  8 15:16:01 tippex wlan_queue: 0    4243    24      0       19      19      0
Mar  8 15:16:01 tippex wlan_queue: 1    1356953 24      0       17      17      0
Mar  8 15:16:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar  8 15:16:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar  8 15:17:01 tippex cron[6410]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar  8 15:17:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar  8 15:17:01 tippex wlan_queue: 14   0       24      56411   11      0       0
Mar  8 15:17:01 tippex wlan_queue: 0    4243    24      0       19      19      0
Mar  8 15:17:01 tippex wlan_queue: 1    1356953 24      0       17      17      0
Mar  8 15:17:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar  8 15:17:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar  8 15:18:01 tippex cron[6416]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar  8 15:18:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar  8 15:18:01 tippex wlan_queue: 14   0       24      57031   7       0       0
Mar  8 15:18:01 tippex wlan_queue: 0    4243    24      0       19      19      0
Mar  8 15:18:01 tippex wlan_queue: 1    1356953 24      0       17      17      0
Mar  8 15:18:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar  8 15:18:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar  8 15:19:01 tippex cron[6422]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar  8 15:19:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar  8 15:19:01 tippex wlan_queue: 14   0       24      57644   20      0       0
Mar  8 15:19:01 tippex wlan_queue: 0    4243    24      0       19      19      0
Mar  8 15:19:01 tippex wlan_queue: 1    1356953 24      0       17      17      0
Mar  8 15:19:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar  8 15:19:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar  8 15:20:01 tippex cron[6431]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar  8 15:20:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar  8 15:20:01 tippex wlan_queue: 14   0       24      58269   21      0       0
Mar  8 15:20:01 tippex wlan_queue: 0    4243    24      0       19      19      0
Mar  8 15:20:01 tippex wlan_queue: 1    1356953 24      0       17      17      0
Mar  8 15:20:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar  8 15:20:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar  8 15:21:01 tippex cron[6445]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar  8 15:21:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar  8 15:21:01 tippex wlan_queue: 14   0       24      58909   13      0       0
Mar  8 15:21:01 tippex wlan_queue: 0    4243    24      0       19      19      0
Mar  8 15:21:01 tippex wlan_queue: 1    1356953 24      0       17      17      0
Mar  8 15:21:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar  8 15:21:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar  8 15:22:01 tippex cron[6451]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar  8 15:22:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar  8 15:22:01 tippex wlan_queue: 14   0       24      59538   18      0       0
Mar  8 15:22:02 tippex wlan_queue: 0    4243    24      0       19      19      0
Mar  8 15:22:02 tippex wlan_queue: 1    1356953 24      0       17      17      0
Mar  8 15:22:02 tippex wlan_queue: 16   0       1       0       0       0       0
Mar  8 15:22:02 tippex wlan_queue: 17   0       8       0       0       0       0



Trying to rmmod/modprobe, I end up with:

ar  8 17:07:17 tippex ADDRCONF(NETDEV_UP): wlan0: link is not ready
Mar  8 17:07:18 tippex wlan0: authenticate with AP 00:18:39:c0:5f:50
Mar  8 17:07:18 tippex wlan0: authenticate with AP 00:18:39:c0:5f:50
Mar  8 17:07:18 tippex wlan0: authenticate with AP 00:18:39:c0:5f:50
Mar  8 17:07:18 tippex wlan0: authenticate with AP 00:18:39:c0:5f:50
Mar  8 17:07:18 tippex wlan0: authentication with AP 00:18:39:c0:5f:50 timed out
Mar  8 17:07:28 tippex /etc/init.d/net.wlan0[7602]: Failed to configure wireless for wlan0
Mar  8 17:07:28 tippex wlan0: direct probe to AP 00:18:39:c0:5f:50 try 1
Mar  8 17:07:28 tippex wlan0: direct probe to AP 00:18:39:c0:5f:50 try 1
Mar  8 17:07:28 tippex wlan0: deauthenticating by local choice (reason=3)
Mar  8 17:07:28 tippex /etc/init.d/net.wlan0[7487]: ERROR: net.wlan0 failed to start


The only way to get the interface back to operational status is to 
/sbin/reboot the machine.

Any ideas how this can be solved?
/Anders 


