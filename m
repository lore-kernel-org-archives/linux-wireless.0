Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38753 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaJCVRC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2014 17:17:02 -0400
Message-ID: <542F124C.50406@candelatech.com> (sfid-20141003_231706_768880_34E4C3DE)
Date: Fri, 03 Oct 2014 14:17:00 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rmanohar@qti.qualcomm.com
Subject: 3.17 regression, ath9k: Summarize hw state per channel context
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Took a while, but I found the regression that has been bugging me.

This is on stock kernel, with hand-patched fixup from Felix that fixes
crash related to minstrel (patch made it upstream later, so that isn't
a current problem).

The test case is easily reproducible on my systems.  I'm not sure
all the details matter, but this happens to be my test case
at the moment:

32-bit Fedora OS, latest supplicant, etc.  ath9k NIC.

create wlan0 and sta0-4 (6 total), not sure how much that matters.
associate all 6 (works fine)
disconnect 5 of them, leaving sta0 up
Start trying to bring up the other 5 one at a time.  It will
fail, with iw events looking like this (in these logs, several
sta are trying to come up, but symptom is the same with just one)

2014-10-03 14:05:43.751  1.3:  sta2 (phy #0): scan finished: 2462, ""
2014-10-03 14:05:43.755  1.3:  sta1: new station 00:0e:8e:6f:40:49
2014-10-03 14:05:43.803  1.1:  vap0 (phy #1): mgmt TX status (cookie f3d5ce40): no ack
2014-10-03 14:05:43.978  1.1:  vap0 (phy #1): mgmt TX status (cookie f3d5ca80): no ack
2014-10-03 14:05:44.179  1.1:  vap0 (phy #1): mgmt TX status (cookie f3d5c900): no ack
2014-10-03 14:05:44.364  1.3:  sta1: del station 00:0e:8e:6f:40:49
2014-10-03 14:05:44.364  1.3:  sta1 (phy #0): auth: timed out
2014-10-03 14:05:45.647  1.3:  sta3 (phy #0): scan started
2014-10-03 14:05:45.659  1.1:  vap0 (phy #1): mgmt TX status (cookie f3d15000): no ack
2014-10-03 14:05:45.668  1.3:  sta3 (phy #0): scan finished: 2462, "ben-138"
2014-10-03 14:05:48.811  1.1:  vap0 (phy #1): mgmt TX status (cookie eaec63c0): no ack
2014-10-03 14:05:49.015  1.1:  vap0 (phy #1): mgmt TX status (cookie ef8cc540): no ack
2014-10-03 14:05:49.213  1.1:  vap0 (phy #1): mgmt TX status (cookie ef8cc540): no ack
2014-10-03 14:05:51.901  1.1:  vap0: del station 00:ab:cd:ef:01:01
2014-10-03 14:07:20.368  1.3:  wlan0 (phy #0): scan started

If I restart all interfaces on the radio, the will come up with no problem,
until I try to restart one again.


Bisect points at this patch:

9a9c4fbc3fcabc0d510600743204f890ebdbb141 is the first bad commit
commit 9a9c4fbc3fcabc0d510600743204f890ebdbb141
Author: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Date:   Wed Jun 11 16:18:03 2014 +0530

    ath9k: Summarize hw state per channel context

    Group and set hw state (opmode, primary_sta, beacon conf) per
    channel context instead of whole list of vifs. This would allow
    each channel context to run in different mode (STA/AP).

    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

:040000 040000 aa6eab9d17a0b3468075ff7c1abfee2ccfcb521e e15af8b46ce047c8b46177e2d4cf74a4590a2181 M	drivers

I will be happy to test patches if anyone has a suggested fix or needs
debug output...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

