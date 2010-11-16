Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:56310 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107Ab0KPTcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 14:32:04 -0500
Date: Tue, 16 Nov 2010 21:31:56 +0200
From: Jouni Malinen <j@w1.fi>
To: Ben Greear <greearb@candelatech.com>
Cc: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC/PATCH:  Allow wpa_supplicant to share scan results.
Message-ID: <20101116193156.GA32723@jm.kir.nu>
References: <4CE1CEC6.2050103@candelatech.com>
 <20101116094512.GB21872@jm.kir.nu>
 <4CE2B953.9090509@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CE2B953.9090509@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 16, 2010 at 09:03:15AM -0800, Ben Greear wrote:
> It would be easy enough to save the phyname in the wpa_s struct so it
> doesn't need to be probed all the time.

phyname sounds like a Linux/mac80211/cfg80211 specific thing and
probably does not belong in wpa_s.. But yes, some kind of identifier for
interfaces sharing the same radio there or in the private driver wrapper
data would be fine (if it within driver_nl80211.c, phyname would be
perfectly valid thing to store at initialization).

> As for the logic that actually propagates scan results to all of the
> peer VIFS, do you mean you want that moved farther up into the driver
> as well?

I think I would be fine with either option as a starting point, i.e.,
driver_nl80211.c can maintain an internal list of interfaces and
propagate the scan complete event to each interface or there can be an
abstract radio identifier exposed by the driver wrapper to allow core
supplicant code to handle this. I'm assuming here that it is possible to
read the scan results from any vif in mac80211 regardless of which
generated the scan-completed event. Is that correct?

> It simple to know the phy-name for a particular VIF (on the latest kernel),
> so knowing parent-child and sibling relationships is also easy.  Older
> kernels don't have the phy-name available in sysfs, but they also didn't
> support multiple VIFS well anyway..so maybe just ignore them?

Yeah, I have no problems in ignoring old versions for this kind of new
functionality.

> I was afraid that one VIF might scan with one set of scan-options and another
> a different set.  However, I have no real understanding of how wpa_supplicant
> works, so if you think it can be always enabled, then I'm fine with that.

That can already happen even with a single vif when other applications
are requesting scans.. wpa_supplicant will have to handle it cleanly
anyway.

> Also, with it enabled, I can currently reliably crash ath9k.  This is a
> kernel bug that hopefully can be fixed soon, but it would be one small reason to
> keep the old behaviour available.

What exactly is the trigger for the crash? Multiple vifs? Or this type
of optimization for re-using scan results? Anyway, I don't think we
should care about that in the context of designing what should be added
into wpa_supplicant. If a kernel driver is buggy, it will be fixed, or
you better not try to use this feature ;-).

-- 
Jouni Malinen                                            PGP id EFC895FA
