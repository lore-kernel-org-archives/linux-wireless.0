Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36107 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab3KRNzE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 08:55:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ViPI7-0002Fi-1C
	for linux-wireless@vger.kernel.org; Mon, 18 Nov 2013 14:55:03 +0100
Received: from 212-60-115-150.ip.cust.zensystems.net ([212.60.115.150])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 14:55:03 +0100
Received: from nilsson.troels by 212-60-115-150.ip.cust.zensystems.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 14:55:03 +0100
To: linux-wireless@vger.kernel.org
From: Troels Nilsson <nilsson.troels@gmail.com>
Subject: Roaming with libertas and =?utf-8?b?d3BhX3N1cHBsaWNhbnQ=?= not working
Date: Mon, 18 Nov 2013 13:50:09 +0000 (UTC)
Message-ID: <loom.20131118T143002-687@post.gmane.org> (sfid-20131118_145509_206573_37D8C413)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We are having a problem with a custom device which uses the libertas wifi
driver (on kernel 3.4.24) together with wpa_supplicant (0.7.3). More
specifically, whenever wpa_supplicant attempts to roam to a different access
point it gets a EALREADY error.

I have tracked down the problem to this check in sme.c:

        if (wdev->sme_state != CFG80211_SME_IDLE)
                return -EALREADY;

When we get to this check the sme_state is CFG80211_SME_CONNECTED, so
nothing gets done. Changing this check to only fail if sme_state is
CFG80211_SME_CONNECTING fixes the issue, but I guess this check is there for
a reason?

In any case I don't know enough about the wireless system to say if this is
a problem in the libertas driver or cfg80211 or maybe the way wpa_supplicant
is using the API. Any comments/help would be greatly appreciated :)

