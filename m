Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:56706 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932274AbXCWRh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 13:37:56 -0400
Message-ID: <4604106F.7080003@lwfinger.net>
Date: Fri, 23 Mar 2007 12:37:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
CC: wireless <linux-wireless@vger.kernel.org>,
	bcm43xx devel <Bcm43xx-dev@lists.berlios.de>
Subject: RFC: Future plans for bcm43xx-softmac
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think we have a plan for the future of bcm43xx-softmac once the bcm43xx-mac80211 version goes into
mainline. Unfortunately it cannot just be abandoned as there will be no support for 802.11b-only
devices in bcm43xx-mac80211.

The steps to be done are as follows:

1. Change the namespace from bcm43xx to bcm4301. This will both reflect the purpose of the changed
driver as well as prevent namespace collisions with the bcm43xx-mac80211 version in case both are
built into the kernel.

2. Modify bcm4301 to use mac80211 rather than softmac. Although this process has the potential for
introducing bugs into what is currently the stable version, it does allow the abandonment of softmac
with its deficiencies, many of which are essentially uncorrectable.

3. The PCI-ids recognized by bcm4301-mac80211 will be restricted to the 802.11b-only devices and the
configuration information will be modified.

Step 1 will be completed very soon and the appropriate patches will be submitted to Linville's
wireless-dev tree.

I will be working on step 2 in the coming months and will submit those patches to the list for
comments and testing. When ready, they too will be submitted to Linville. Once bcm43xx-mac80211 goes
into mainline, the step 3 patches will be submitted.

Please comment on this plan.

Thanks,

Larry
