Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:12249 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab0CRRrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 13:47:10 -0400
Received: by fg-out-1718.google.com with SMTP id l26so2748394fgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Mar 2010 10:47:09 -0700 (PDT)
Message-ID: <4BA266FB.1080507@lwfinger.net>
Date: Thu, 18 Mar 2010 12:46:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: RFC: A workaround for BCM43XX devices with no on-board SPROM
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

I'm switching this discussion from the kernel Bugzilla to the lists.

As you know, but I'm restating for anyone that has not read our previous
discussions, the b43 driver needs to be changed to handle some of the newer
devices do not have an on-board SPROM. It would be trivial to incorporate the
data except for the need to have a unique, reproducible MAC.

I am proposing to solve this problem using the following steps:

(1) Modify b43-fwcutter to take data from an existing SPROM, modify the MAC by
replacing the last 3 octets with random numbers, and write the resulting file to
/lib/firmware/b43. Fortunately, all affected devices seem to have Revision 8
SPROMS, which makes preparation easier. All such devices will need to use the
calibration parameters of the device from which the prototype SPROM was copied,
but that should not be a serious problem. I have chosen to implement this in
fwcutter rather than ssb_sprom because the ordinary user will not have access to
ssb_sprom; however, they do have a version of fwcutter supplied by the distro.
Unconditionally writing an additional small file to the firmware directory when
extracting firmware is small overhead and it will be transparent to the user of
whatever mechanism the distro uses. The routines needed to calculate the CRC,
etc. have been copied into fwcutter from ssb_sprom. A version of this code is
already running.

(2) Use the steps in http://bcm-v4.sipsolutions.net/802.11/IsSpromAvailable to
determine if the device has an SPROM. If not, then use the kernel's firmware
loading mechanism to get the contents of the file prepared in step 1. This file
has an 8-bit CRC, thus the validity of the file can be tested even though the
test is not very robust.

It it reasonable to keep the vendor portion of the MAC and only replace the
"serial number", or would it be better to randomize all 6 octants?

Is there a better way to load a file into the kernel?

Thanks,

Larry
