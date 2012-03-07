Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48831 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759166Ab2CGTkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:40:05 -0500
Received: from 64-126-113-183.dyn.everestkc.net ([64.126.113.183] helo=canonical.com)
	by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.71)
	(envelope-from <seth.forshee@canonical.com>)
	id 1S5MiR-00013O-2u
	for linux-wireless@vger.kernel.org; Wed, 07 Mar 2012 19:40:03 +0000
Date: Wed, 7 Mar 2012 13:40:01 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Subject: Problems with regulatory domain support and BCM43224
Message-ID: <20120307194001.GA2506@ubuntu-macmini> (sfid-20120307_204009_954096_8E0805AA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I set up an AP recently in the 5 GHz band and noticed that a MacBook Air
with BCM43224 wireless can't see it. iw shows that the 5260-5700 MHz
frequency range is disabled. I compared this to an Intel Centrino 6205
card which shows passive scanning is allowed in this range. Both show
that they're using the world regulatory domain, and I can get the
BCM43224 to see my AP when I force the domain to US.

I've been going through the regulatory code trying to understand what's
happening, and while I haven't fully grokked it yet it seems to me the
difference is that iwlwifi is setting WIPHY_FLAG_CUSTOM_REGULATORY and
brcmsmac is not. iwlwifi isn't supplying a regulatory hint, and mac80211
doesn't end up applying any regulatory settings due to the flag.
brcmsmac supplies a hint using the country code it reads from its srom,
"X0" (which Google tells me is an interim code that Apple uses while the
actual country code is unknown). Since this code is bogus the world
domain gets applied.

mac80211 doesn't appear to update the regulatory domain from the beacons
unless connected to an AP that happens to be providing the country IE,
so we're left in the unfortunate situation of being unable to scan
certain frequencies unless the user connects to such an AP or sets the
domain manually.

Am I understanding the situation correctly? If so, what can be done
about it? Should brcmsmac set WIPHY_FLAG_CUSTOM_REGULATORY when it reads
XO from its srom?

Thanks,
Seth

