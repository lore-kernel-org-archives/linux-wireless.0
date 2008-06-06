Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:20705 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbYFFTer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 15:34:47 -0400
Received: by ug-out-1314.google.com with SMTP id h2so764141ugf.16
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2008 12:34:44 -0700 (PDT)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [BUG] iwlwifi 3945 works only with disable_hw_scan=1
Date: Fri, 6 Jun 2008 22:34:40 +0300
Cc: ipw3945-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806062234.40572.maximlevitsky@gmail.com> (sfid-20080606_213451_485649_6B1609FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I recently bought an acer aspire 5720G, and wireless didn't work with
standard ubuntu 2.6.24 kernel.

I found that specifying the above option 'fixes' the driver
but I also noticed that list of available access points shrinks
to just one (the connected) point.

Moreover there is a trouble in changing a access point, it just hangs.
the button that toggles wireless does work, but doesn't blink.

I then installed latest -git kernel (~ 2.6.26-rc4) and got this:

* I still have to use disable_hw_scan=1
* Wireless led works thanks to acer-wmi
* If I disable wireless with the button, I _can't_ re-enable it unless
  I reload the module.

* List of access points doesn't shrink, and I can switch between those points.


When I omit disable_hw_scan=1, I get errors about REPLY_SCAN_CMD
I will send detailed debug info later.

Best regards,
	Maxim Levitsky
