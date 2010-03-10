Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:40575 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105Ab0CJD3h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 22:29:37 -0500
Subject: Re: building the rt2x00 drivers on compat-wireless
From: Pavel Roskin <proski@gnu.org>
To: Alastair McKinley <amckinley03@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <6c6bb6f91003091727p322c5589n117a7d774094b20c@mail.gmail.com>
References: <6c6bb6f91003091723t31972586uba80a0a849f3634@mail.gmail.com>
	 <6c6bb6f91003091727p322c5589n117a7d774094b20c@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 09 Mar 2010 22:29:36 -0500
Message-Id: <1268191776.10669.20.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-10 at 01:27 +0000, Alastair McKinley wrote:

> So my question is, how do you build rt2x00 and friends from
> compat-wireless, there doesn't seem to be an option in
> ./scripts/driver-select.

Just compile and install everything in compat-wireless.  If something
fails to compile, please report.  If some drivers fail symbol
verification, it's not a problem as long as you don't need those
drivers.

I checked the current compat-wireless on Linux 2.6.26, and following
modules have unresolved symbols:

b43.ko
b43legacy.ko
b44.ko
rt2800pci.ko
rt2800usb.ko
wl1271.ko

rt2800usb could be your device, but most likely your device is something
older and shouldn't be affected.

-- 
Regards,
Pavel Roskin
