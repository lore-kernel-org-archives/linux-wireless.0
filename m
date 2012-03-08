Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53448 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2CHRlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 12:41:07 -0500
Date: Thu, 8 Mar 2012 11:41:02 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Problems with regulatory domain support and BCM43224
Message-ID: <20120308174101.GB28133@ubuntu-macmini> (sfid-20120308_184112_320907_2400F157)
References: <20120307194001.GA2506@ubuntu-macmini>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120307194001.GA2506@ubuntu-macmini>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding some Cc's.

On Wed, Mar 07, 2012 at 01:40:01PM -0600, Seth Forshee wrote:
> I set up an AP recently in the 5 GHz band and noticed that a MacBook Air
> with BCM43224 wireless can't see it. iw shows that the 5260-5700 MHz
> frequency range is disabled. I compared this to an Intel Centrino 6205
> card which shows passive scanning is allowed in this range. Both show
> that they're using the world regulatory domain, and I can get the
> BCM43224 to see my AP when I force the domain to US.
> 
> I've been going through the regulatory code trying to understand what's
> happening, and while I haven't fully grokked it yet it seems to me the
> difference is that iwlwifi is setting WIPHY_FLAG_CUSTOM_REGULATORY and
> brcmsmac is not. iwlwifi isn't supplying a regulatory hint, and mac80211
> doesn't end up applying any regulatory settings due to the flag.
> brcmsmac supplies a hint using the country code it reads from its srom,
> "X0" (which Google tells me is an interim code that Apple uses while the
> actual country code is unknown). Since this code is bogus the world
> domain gets applied.
> 
> mac80211 doesn't appear to update the regulatory domain from the beacons
> unless connected to an AP that happens to be providing the country IE,
> so we're left in the unfortunate situation of being unable to scan
> certain frequencies unless the user connects to such an AP or sets the
> domain manually.

As I understand it, the DFS channels aren't included in the world domain
because Linux does not yet fully support DFS. But I can then specify a
domain that's known to require DFS on these channels, and they are
enabled. This seems illogical. If passive scanning is okay when we know
DFS is required, why can't it be enabled in the world domain when we
simply don't know if it's required?

Thanks,
Seth

