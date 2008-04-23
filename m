Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:57404 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717AbYDWQo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 12:44:59 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Dan Williams'" <dcbw@redhat.com>,
	"'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>, <hostap@lists.shmoo.com>
Subject: RE: Roaming problems
Date: Wed, 23 Apr 2008 18:44:31 +0200
Message-ID: <005401c8a561$4e27efb0$0b3ca8c0@gotws1589> (sfid-20080423_184536_891035_9978D2A9)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <1208967713.24395.4.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Lars mentioned that it sets the SSID first and then the BSSID, maybe 
> > the trivial fix would be to make it do that the other way around?
> 
> Maybe, but why should the driver care?  It should be 
> re-attempting association when either of SSID or BSSID gets 
> set, interrupting any current ongoing association to a different AP.
> 
> Dan
> 

Currently this is what happens most of the time, when all ioclts had been
issued from the driver, it drops current authentication/association atempts
and start with the new one. Most of the times that works fine.

But sometimes, when for any reason the 3 ioctls get delayed, the driver may
success to associate with the old BSSID (since that is still valid in the
driver). Then when all 3 ioctls has been received, including the new BSSID,
the driver re-starts the authentication/association sequence with the new
BSSID.

The problem is that the STA already have a valid association with the first
AP. In this case the new BSSID silently ignores any
authentication/association attempts. My believe is that it knows that the
STA already have a valid association.

Could the problem be that the wpa_supplicant not issue a BSSID
00:00:00:00:00:00 before start the configuration to the new BSSID ?

/Lars

