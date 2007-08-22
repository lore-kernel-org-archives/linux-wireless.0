Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:47772 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754871AbXHVRlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 13:41:49 -0400
Message-ID: <46CC755A.5030109@lwfinger.net>
Date: Wed, 22 Aug 2007 12:41:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH]  b43legacy: Initial port of new driver with bcm43xx PHY code  and ssb/mac80211 front end
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following message was just sent to John Linville with the patch attached. Because of the patch's 
length, it is not being sent to the lists. If you would like to obtain a copy, it is at 
ftp://lwfinger.dynalias.org/patches/port_to_b43legacy.

Larry
=============================

This patch ports the PHY and radio handling code of the softmac driver
to the mac80211 front end from b43. The resulting driver is known as
b43legacy.

This driver uses V3 firmware and supports 802.11b-only devices (BCM4301
and BCM4303). It also supports the BCM4306/2 802.11g model. This driver
is needed as these units are not supported by the V4 firmware used with
driver b43. Module ssb has been modified to select between b43 and
b43legacy depending on the revision of the 802.11 wireless core. As a
result the two versions can coexist on a system. The scheme whereby
the firmware is split into separate directories precludes any problems
with firmware names. Compilation with both drivers built into the
kernel confirms that there are no namespace collisions between b43 and
b43legacy.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

Because of the size of this patch, I have not sent it to the lists.
If this is a problem, please let me know. It is meant to apply to the
b43 branch of wireless-dev after the series of 6 patches queued by
Michael Buesch on Aug. 18.

This patch has been run through scripts/checkpatch.pl, and is reasonably
free of the defects found by that script.

The problem with performance on the BCM4306/2 has been fixed. It still
needs improvement, but it now works as well as it ever has.

Thanks,

Larry

