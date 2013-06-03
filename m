Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1834 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758786Ab3FCRLu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 13:11:50 -0400
Message-ID: <51ACCDFE.5090003@broadcom.com> (sfid-20130603_191154_653389_12C01A92)
Date: Mon, 3 Jun 2013 19:10:22 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John Greene" <jogreene@redhat.com>
Subject: using ieee80211_restart_hw()
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

In brcmsmac a fatal error in the device results in calling 
ieee80211_restart_hw(). This was done under the assumption that mac80211 
would reconfigure everything doing .start(), .add_interface() etc, but 
looking at a log in redhat bugzilla makes me suspicious about that.

The only reason I could find in ieee80211_reconfig is that 
local->open_count would be zero, right?

At the time of the fatal error AMPDU packets were being transmitted so I 
assume local->open_count would *not* be zero as it seems to match the 
state of the netdev interface.

Regards,
Arend

---8<--------------------------------------------------------------
	/* everything else happens only if HW was up & running */
	if (!local->open_count)
		goto wake_up;

	/*
	 * Upon resume hardware can sometimes be goofy due to
	 * various platform / driver / bus issues, so restarting
	 * the device may at times not work immediately. Propagate
	 * the error.
	 */
	res = drv_start(local);


