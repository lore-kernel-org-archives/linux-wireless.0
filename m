Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:51551 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753548AbXHSThY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 15:37:24 -0400
Message-ID: <46C89BF1.5060306@lwfinger.net>
Date: Sun, 19 Aug 2007 14:37:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: ALERT: firmware change for b43
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Just in case you missed the details, the latest set of changes to b43 queued by Michael will require
a new version of fwcutter, now called b43-fwcutter, and a new extraction of your firmware.

There are several changes. Most notably, the firmware for b43 and b43legacy will reside in separate
directories under /lib/firmware, or whatever is appropriate for your distro. With the new directory
structure, there will be no name clashes for firmware for b43, b43legacy, and bcm43xx. The fwpostfix
option still exists, but it is no longer essential for operation. The firmware files have also been
renamed to reflect their usage. This is most obvious for the "initvals" files. A third change
restructures the firmware files to reduce their size.

It is recommended that you update fwcutter before these patches are merged. If your version of
fwcutter was obtained with subversion, a simple 'svn update' in the fwcutter directory will suffice.
If you are using a version provided by your distro, you will need to checkout the latest version
with the command 'svn checkout svn://svn.berlios.de/bcm43xx/trunk/fwcutter'. This will create the
directory fwcutter. You should 'cd fwcutter', followed by 'make'. You then use the newly made
b43-fwcutter to extract V4 firmware. If you have BCM4301 or BCM4306/2 devices, you should also use
b43-cutter to extract V3 firmware for b43legacy. The patch to include that driver in wireless-dev
will be submitted very soon.

Larry



