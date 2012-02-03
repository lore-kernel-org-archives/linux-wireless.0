Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60165 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2BCW2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 17:28:22 -0500
Date: Fri, 3 Feb 2012 16:28:18 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Scott Sanbar <scott.sanbar@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: BCM4331 fails to associate after suspend
Message-ID: <20120203222818.GA3749@ubuntu-mba> (sfid-20120203_232825_902465_2DFC7EC9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been looking into some association problems seen with a MacBook Pro
8,2 that has BCM4331 wireless, which I've confirmed still exist in
wireless-testing. The association failures reliably start appearing
after the machine is resumed from s3 without external power applied
(whether or not power is applied when the machine is suspended doesn't
matter).

When the association failures are happening the BCM4331 seems to be able
to receive packets okay, as it can scan successfully. Transmissions
don't work though; no frames from the BCM4331 are ever seen on the air,
as though the tx path is off. Reloading both the b43 and bcma drivers
gets things working again, but reloading just b43 does not.

I've been looking around a bit in the b43 and bcma drivers, but so far I
haven't found the reason why this happens. Any help would be
appreciated. Let me know if there's additional information I can
provide.

Thanks,
Seth
