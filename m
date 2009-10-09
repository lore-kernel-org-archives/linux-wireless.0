Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:54041 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760957AbZJIPRe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 11:17:34 -0400
Received: by fg-out-1718.google.com with SMTP id 22so337225fge.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2009 08:15:46 -0700 (PDT)
Message-ID: <4ACF539E.8070107@lwfinger.net>
Date: Fri, 09 Oct 2009 10:15:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	bcm43xx devel <Bcm43xx-dev@lists.berlios.de>
Subject: Broken patch for b43
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Unfortunately, my patch entitled "43: Fix PPC crash in rfkill polling
on unload" had more problems than a locking error. When you switch the
RF off, you cannot turn the radio back on without unloading/reloading
the module.

I have an alternative fix for the PPC that is now being tested;
however, it may just restrict the unload/load problem to older models.
To know whether that is a possibility, I need to know if anyone has a
G PHY device with PHY revision <= 2 that also has an RFKILL switch.
Note: LP PHYs (ID of 4315) will have such revisions, but they do not
count.

Thanks,

Larry
