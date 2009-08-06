Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:63334 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbZHFMzX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 08:55:23 -0400
Subject: Re: [PATCH] cfg80211: fix disassociation warning due to misuse of
 wdev->current_bss
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1249549574.4852.17.camel@johannes.local>
References: <20090806085242.23637.82992.stgit@ct.roinet.com>
	 <1249549574.4852.17.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 08:55:08 -0400
Message-Id: <1249563308.15613.9.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-06 at 11:06 +0200, Johannes Berg wrote:
> On Thu, 2009-08-06 at 04:52 -0400, Pavel Roskin wrote:
> > WARN_ON was triggered at mlme.c:213 when dissociating from an AP.
> > 
> > wdev->current_bss->pub.bssid should be used in place of
> > wdev->current_bss for BSSID comparison.
> 
> Oh wow, good catch, thanks.

Now that the check is fixed, it turn out there is a related problem in
the same function.  If the device is in the managed mode and disconnects
from an AP due to a low signal, attempts to reassociate by setting the
same ESSID fail:

Error for wireless request "Set ESSID" (8B1A) :
    SET failed on device wlan0 ; Operation already in progress.

It happens because wdev->auth_bsses[i] is not set to NULL.
cfg80211_sme_disassoc() can do it, but not if wdev->conn->state is
CFG80211_CONN_IDLE.

Either cfg80211_sme_disassoc() or __cfg80211_send_disassoc() should
unset wdev->auth_bsses[i] for the management mode.

-- 
Regards,
Pavel Roskin
