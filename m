Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:56058 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab2ECFIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 01:08:44 -0400
Message-ID: <4FA212D9.5020602@gtri.gatech.edu> (sfid-20120503_070848_327037_C46C0620)
Date: Thu, 3 May 2012 01:08:41 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [WIP] rtlwifi: rtl8192su subdriver
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I would like to submit the work I have done so far on a native mac80211 
driver for the RTL8192SU family of chips (91SU/88SU also).  It builds 
off of the rtlwifi driver, especially the rtl8192se subdriver, as well 
as the r8712u and the deleted rtl8192su staging drivers.

The first few patches are enhancements or bug fixes to the rtlwifi core 
which I would like to get pulled upstream after review.  The second to 
last patch is an ugly hack to allow subdrivers to register new/different 
features with mac80211 (hardware scanning, for instance).  And the last 
patch adds the work done so far on rtl8192su.

As of now, the rtl8192su subdriver can initialize the hardware, load the 
firmware, setup bulk communication, and configure the RF/BB/PHY.  There 
are a handful of FIXMEs scattered around the code, and many of the new 
FW commands still need to be implemented.  The site survey FW command 
works quite well and returns available BSSIDs in the area.  However, the 
firmware currently eats beacons and returns the scan results in a struct 
that will require some work to feed into mac80211.

(I'm too tired to setup git-send-email tonight, so please pardon the 
following manually sent patches which are not inlined.)

Joshua Roys

