Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:44515 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbZCROy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 10:54:57 -0400
cc: Adam Baker <linux@baker-net.org.uk>,
	Anders Eriksson <aeriksson@fastmail.fm>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] No ProbeResp == dead interface?
Mime-Version: 1.0
from: aeriksson2@fastmail.fm
Content-Type: text/plain; charset=us-ascii
Date: Wed, 18 Mar 2009 15:45:54 +0100
Message-Id: <20090318144555.239CC2C40F9@tippex.mynet.homeunix.org> (sfid-20090318_155500_981213_0286A2B4)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Here's another trace of what happens due to lost ProbeResp. The "count" for 
queue 0 stops to increase after that, fwiw. rmmod/modprobe doesn't help. A 
reboot is necessary.

Anything else I can provide to help debug this?

/Anders





Mar 18 14:53:01 tippex cron[19345]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 14:53:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 14:53:01 tippex wlan_queue: 14   0       24      23740   4       0       0
Mar 18 14:53:01 tippex wlan_queue: 0    14023   24      0       7       7       0
Mar 18 14:53:01 tippex wlan_queue: 1    5229165 24      0       21      21      0
Mar 18 14:53:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 14:53:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 14:54:01 tippex cron[19351]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 14:54:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 14:54:01 tippex wlan_queue: 14   0       24      28180   4       0       0
Mar 18 14:54:01 tippex wlan_queue: 0    14024   24      0       8       8       0
Mar 18 14:54:01 tippex wlan_queue: 1    5230333 24      0       13      13      0
Mar 18 14:54:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 14:54:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 14:55:01 tippex cron[19356]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 14:55:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 14:55:01 tippex wlan_queue: 14   0       24      32780   20      0       0
Mar 18 14:55:01 tippex wlan_queue: 0    14025   24      0       9       9       0
Mar 18 14:55:01 tippex wlan_queue: 1    5231500 24      0       4       4       0
Mar 18 14:55:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 14:55:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 14:56:01 tippex cron[19360]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 14:56:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 14:56:01 tippex wlan_queue: 14   0       24      37455   15      0       0
Mar 18 14:56:01 tippex wlan_queue: 0    14026   24      0       10      10      0
Mar 18 14:56:01 tippex wlan_queue: 1    5232999 24      0       15      15      0
Mar 18 14:56:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 14:56:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 14:57:01 tippex cron[19365]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 14:57:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 14:57:01 tippex wlan_queue: 14   0       24      41898   18      0       0
Mar 18 14:57:01 tippex wlan_queue: 0    14027   24      0       11      11      0
Mar 18 14:57:01 tippex wlan_queue: 1    5234682 24      0       18      18      0
Mar 18 14:57:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 14:57:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 14:58:01 tippex cron[19371]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 14:58:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 14:58:01 tippex wlan_queue: 14   0       24      46364   20      0       0
Mar 18 14:58:01 tippex wlan_queue: 0    14028   24      0       12      12      0
Mar 18 14:58:01 tippex wlan_queue: 1    5236348 24      0       4       4       0
Mar 18 14:58:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 14:58:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 14:58:44 tippex wlan0: No ProbeResp from current AP 00:18:39:c0:5f:50 - assume out of range

Mar 18 14:59:01 tippex cron[19390]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 14:59:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 14:59:01 tippex wlan_queue: 14   0       24      49402   10      0       0
Mar 18 14:59:01 tippex wlan_queue: 0    14030   24      0       14      14      0
Mar 18 14:59:01 tippex wlan_queue: 1    5237206 24      0       22      22      0
Mar 18 14:59:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 14:59:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 15:00:02 tippex cron[19401]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 15:00:02 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 15:00:02 tippex wlan_queue: 14   0       24      50011   19      0       0
Mar 18 15:00:02 tippex wlan_queue: 0    14030   24      0       14      14      0
Mar 18 15:00:02 tippex wlan_queue: 1    5237206 24      0       22      22      0
Mar 18 15:00:02 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 15:00:02 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 15:01:01 tippex cron[19414]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 15:01:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 15:01:01 tippex wlan_queue: 14   0       24      50586   18      0       0
Mar 18 15:01:01 tippex wlan_queue: 0    14030   24      0       14      14      0
Mar 18 15:01:01 tippex wlan_queue: 1    5237206 24      0       22      22      0
Mar 18 15:01:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 15:01:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 15:02:01 tippex cron[19419]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 15:02:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 15:02:01 tippex wlan_queue: 14   0       24      51143   23      0       0
Mar 18 15:02:01 tippex wlan_queue: 0    14030   24      0       14      14      0
Mar 18 15:02:01 tippex wlan_queue: 1    5237206 24      0       22      22      0
Mar 18 15:02:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 15:02:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 15:03:01 tippex cron[19424]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 15:03:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 15:03:01 tippex wlan_queue: 14   0       24      51687   15      0       0
Mar 18 15:03:01 tippex wlan_queue: 0    14030   24      0       14      14      0
Mar 18 15:03:01 tippex wlan_queue: 1    5237206 24      0       22      22      0
Mar 18 15:03:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 15:03:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 15:04:01 tippex cron[19429]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 15:04:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 15:04:01 tippex wlan_queue: 14   0       24      52259   11      0       0
Mar 18 15:04:01 tippex wlan_queue: 0    14030   24      0       14      14      0
Mar 18 15:04:01 tippex wlan_queue: 1    5237206 24      0       22      22      0
Mar 18 15:04:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 15:04:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 15:05:01 tippex cron[19435]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 15:05:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 15:05:01 tippex wlan_queue: 14   0       24      52849   1       0       0
Mar 18 15:05:01 tippex wlan_queue: 0    14030   24      0       14      14      0
Mar 18 15:05:01 tippex wlan_queue: 1    5237206 24      0       22      22      0
Mar 18 15:05:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 15:05:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 15:06:01 tippex cron[19439]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 15:06:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 15:06:01 tippex wlan_queue: 14   0       24      53464   16      0       0
Mar 18 15:06:01 tippex wlan_queue: 0    14030   24      0       14      14      0
Mar 18 15:06:01 tippex wlan_queue: 1    5237206 24      0       22      22      0
Mar 18 15:06:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 15:06:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 15:07:01 tippex cron[19444]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 15:07:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 15:07:01 tippex wlan_queue: 14   0       24      54067   19      0       0
Mar 18 15:07:01 tippex wlan_queue: 0    14030   24      0       14      14      0
Mar 18 15:07:01 tippex wlan_queue: 1    5237206 24      0       22      22      0
Mar 18 15:07:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 15:07:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 15:08:01 tippex cron[19450]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 15:08:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 15:08:01 tippex wlan_queue: 14   0       24      54684   12      0       0
Mar 18 15:08:01 tippex wlan_queue: 0    14030   24      0       14      14      0
Mar 18 15:08:01 tippex wlan_queue: 1    5237206 24      0       22      22      0
Mar 18 15:08:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 15:08:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 15:09:01 tippex cron[19455]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 15:09:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 15:09:01 tippex wlan_queue: 14   0       24      55321   1       0       0
Mar 18 15:09:01 tippex wlan_queue: 0    14030   24      0       14      14      0
Mar 18 15:09:01 tippex wlan_queue: 1    5237206 24      0       22      22      0
Mar 18 15:09:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 15:09:01 tippex wlan_queue: 17   0       8       0       0       0       0
Mar 18 15:10:01 tippex cron[19465]: (root) CMD (cat  /debugfs/ieee80211/phy0/rt2500pci/queue/queue  | logger -t wlan_queue)
Mar 18 15:10:01 tippex wlan_queue: qid  count   limit   length  index   done    crypto
Mar 18 15:10:01 tippex wlan_queue: 14   0       24      55979   11      0       0
Mar 18 15:10:01 tippex wlan_queue: 0    14030   24      0       14      14      0
Mar 18 15:10:01 tippex wlan_queue: 1    5237206 24      0       22      22      0
Mar 18 15:10:01 tippex wlan_queue: 16   0       1       0       0       0       0
Mar 18 15:10:01 tippex wlan_queue: 17   0       8       0       0       0       0


