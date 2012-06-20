Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44001 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab2FTMmj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 08:42:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ShKF3-0003nn-DR
	for linux-wireless@vger.kernel.org; Wed, 20 Jun 2012 14:42:37 +0200
Received: from frodo.informatik.rwth-aachen.de ([137.226.12.87])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 14:42:37 +0200
Received: from flottetotte by frodo.informatik.rwth-aachen.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 14:42:37 +0200
To: linux-wireless@vger.kernel.org
From: Torsten Zimmermann <flottetotte@googlemail.com>
Subject: Keep association context while switching channel with =?utf-8?b?Y2ZnODAyMTFfbWdkX3dleHRfc2l3ZnJlcQ==?=
Date: Wed, 20 Jun 2012 12:42:27 +0000 (UTC)
Message-ID: <loom.20120620T143831-633@post.gmane.org> (sfid-20120620_144243_289387_27B88EE5)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,i try to modify cfg80211_mgd_wext_siwfreq to 
allow for the following situation 
(just a test scenario) :
- client is associated with an ap on channel x
- client switches to channel y but keeps association context
- client switches back to channel x and communicates with ap again

by now, i just modified cfg80211_mgd_wext_siwfreq in order 
to switch the channel regardless of the state of the wdev. 
however, wext tools receive the EBUSY from the driver.
up to now, i could not figure out which part of the 
driver is responsible for this behaviour.

anyone has a hint or an idea what could be done to allow
the driver to accept the above situation ?
(at the moment, current tx or rx management, i.e. stopping 
queues or dropping packets is not yet considered).

regards,
torsten

