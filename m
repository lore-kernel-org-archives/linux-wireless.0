Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:42662 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab0DZQka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 12:40:30 -0400
Received: by pzk42 with SMTP id 42so8053346pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 09:40:29 -0700 (PDT)
Message-ID: <4BD5C1F9.4000701@lwfinger.net>
Date: Mon, 26 Apr 2010 11:40:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Michael Buesch <mb@bu3sch.de>
CC: b43-dev@lists.infradead.org,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Changes to b43/ssb specs
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In Kernel Bugzilla #15825, a netbook with an LP PHY device had symptoms
similar to John's box. The main difference is that the freezes on ssb
load were intermittent. From the instances that it works, we learned
that this box does have a SPROM at the normal location (0x1000). With
the help of the OP, we also learned that when it failed, it read the
first word of the SPROM as 0xFFFF, and then froze upon trying the
second. This behavior is the basis for my submission of "[RFC/RFT] ssb:
Avoid system hang when SPROM read fails". On the box at Bug #15825, that
patch eliminates the hangs. Of course, when the load fails with the
appropriate log entries, the wireless doesn't work.

In auditing the path that is involved in ssb registration, I noted a
variable named fast_pwrup_delay in struct ssb_chipcommon that gets
written to MMIO offset 0x6A8. When I looked for some variable like this
in the Broadcom driver, I found that it should be set to 7000 for the
BCM4312 LP-PHY device, but a test print showed it to be 0 with b43/ssb.

Resolving the discrepancy led to modifications in the specs at
http://bcm-v4.sipsolutions.net/802.11/Init. In particular, line 11 was
added. There are now two new pages at
http://bcm-v4.sipsolutions.net/802.11/ClkctlFastPwrupDelay, and
http://bcm-v4.sipsolutions.net/802.11/PmuFastPwrupDelay.

I hand coded the driver to write 7000, rather than zero, to the MMIO
offset 0x6A8. For my device, which already works, it made no difference.
I have sent such a trial patch to the OP at Bug #15825, but have not
gotten feedback.

Larry
