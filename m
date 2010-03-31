Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:52243 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab0CaPOO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 11:14:14 -0400
Received: by qyk9 with SMTP id 9so195313qyk.1
        for <linux-wireless@vger.kernel.org>; Wed, 31 Mar 2010 08:14:13 -0700 (PDT)
Message-ID: <4BB366C2.8010605@lwfinger.net>
Date: Wed, 31 Mar 2010 10:14:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	b43-dev@lists.infradead.org
Subject: Changes in specs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John Linville ran an MMIO dump on his Netbook while loading the wl
driver. From the output, it was clear that his device does indeed have
an SPROM, but it is in a different location than previous devices we
have encountered. With this information, it was not difficult to find
the test for this situation in the Broadcom code. The revised specs for
this condition are in the first paragraph of
http://bcm-v4.sipsolutions.net/SPROM. In a nutshell, the SPROM is at
offset 0x1000 for chipcommon revisions < 31, and at 0x0800 for revisions
>= 31.

I have also discovered what was wrong with the specs that described what
devices do not have an SPROM. The previous version only covers those
devices that are on a PCMCIA bus. The new version of those specs are at
http://bcm-v4.sipsolutions.net/802.11/IsSpromAvailable. As might be
expected, the chipcommon revision is again important for PCI devices.

My workaround for missing SPROM data remains viable, and I plan to
resubmit it as soon as the revised detection routine is ready. Does that
sound reasonable, or should I wait until such a device is found?

Larry
