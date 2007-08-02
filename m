Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:36777 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbXHBPx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 11:53:26 -0400
Date: Thu, 02 Aug 2007 10:53:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC 0/10] Port of bcm43xx from softmac to mac80211
Message-ID: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver bcm43xx is being ported from using SoftMAC to mac80211. For rewiew,
this series of patches is being prepared; however, the final patch will be
a single entity so that compilation during bisection will not break.

The contents of the various pieces are as follows:

 1. Kconfig, Makefile and the main header file.
 2. bcm43xx_debugfs.c and bcm43xx_debugfs.h
 3. bcm43xx_dma.c and bcm43xx_dma.h
 4. bcm43xx_ilt.c, bcm43xx_ilt.h, bcm43xx_leds.c and bcm43xx_leds.h
 5. bcm43xx_main.c and bcm43xx_main.h
 6. bcm43xx_phy.c and bcm43xx_phy.h
 7. bcm43xx_pio.c and bcm43xx_pio.h
 8. bcm43xx_radio.c and bcm43xx_radio.h
 9. bcm43xx_sysfs.c and bcm43xx_sysfs.h
10: bcm43xx_xmit.c and bcm43xx_xmit.h

In general, this port consists of taking the files bcm43xx_phy and 
bcm43xx_radio from the softmac driver and converting them to work with
the files from the mac80211 version, which has been back-converted to 
use V3 firmware.

Larry

