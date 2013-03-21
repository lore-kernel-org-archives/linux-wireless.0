Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:51856 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab3CUWkB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 18:40:01 -0400
Received: from stuffed.shaftnet.org (localhost [127.0.0.1])
	by stuffed.shaftnet.org (8.14.5/8.14.5) with ESMTP id r2LMdwJb009185
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2013 18:39:58 -0400
Received: (from pizza@localhost)
	by stuffed.shaftnet.org (8.14.5/8.14.5/Submit) id r2LMdw9v009184
	for linux-wireless@vger.kernel.org; Thu, 21 Mar 2013 18:39:58 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Subject: RFCv5: ST-E CW1200 WLAN driver
Date: Thu, 21 Mar 2013 18:39:34 -0400
Message-Id: <1363905589-8350-1-git-send-email-pizza@shaftnet.org> (sfid-20130321_234008_150557_EEC26150)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In-Reply-To: 

It's been a little while, but here is the fifth patch series.  Changes 
from the last posting:

 * Stripped out compatibility code for older kernels
 * IBSS appears to work now!
 * Major rework of join logic
 * Improved 802.11g (ERP) coexistence
 * Many, many checkpatch-suggested cleanups
 * Respect RX Seqnum when setting TKIP & CCMP group keys
 * Fix OOPS when hot-unplugging a non-idle device
 * Eliminate callback structure
 * Simplify beacon filter configuration
 * Initial detection logic for CW1160/1260 chips
 * Greatly simplify bss loss detection logic
 * Moved Sagrad SDIO support into new module
 * Disable beacon filter only after association

There are still a pile of checkpatch warnings left (perhaps a quarter 
from the last submission), but most of them relate to 80-character lines 
and lingering camelcase in vendor definitions.  I can keep cleaning 
these up, but my main priority has been feature/stability fixes.

On that front, IBSS now functions properly, and joining and roaming is 
now far more stable.

The other major change I made was to split the hardwired support for the 
Sagrad SG901-1091/1098 modules (in their SDIO-mounted EVK form) into 
their own loadable module, which implements the 
cw1200_get_platform_data() call that would otherwise need to be 
implemented in the platform's board support files.

I'm satisfied with this driver from a functional standpoint (it handles 
everything I'm able throw at it) so I'd really like to kick this thing 
upstairs into wireless-next, assuming it passes muster.

As always, feedback is welcome.  

