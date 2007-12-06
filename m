Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:1504 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbXLFTlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 14:41:08 -0500
Received: by py-out-1112.google.com with SMTP id u77so796208pyb
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2007 11:41:05 -0800 (PST)
Message-ID: <43e72e890712061141g735fe83ubbe56e4b5bd6036d@mail.gmail.com> (sfid-20071206_194118_433576_4647AF47)
Date: Thu, 6 Dec 2007 14:41:01 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [RFC] fixing the ap_scan and hidden SSID mess
Cc: linux-wireless@vger.kernel.org, drago01 <drago01@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Jean Tourrilhes" <jt@hpl.hp.com>
In-Reply-To: <1196889657.6677.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1196889657.6677.22.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 5, 2007 4:20 PM, Dan Williams <dcbw@redhat.com> wrote:

> ap_scan=2 just blows the settings to the driver via WEXT, and hopes the
> driver can do the right thing.

Can you elaborate here on how it just 'blows' the settings to the
driver via WEXT?

> However, userspace is f*cked because it can't figure out which one to
> use, and trying both is not an option because you get unacceptable
> latency for the user when trying to associate.  And special-casing based
> on the driver name is NOT an option.  Ever. At all.

Userspace has been fucked for many reasons. The right solution was to
abandon WE so we should not use it anymore for new features.

> Solution
> --------
>
> Drivers should advertise the ability to do specific SSID scans (which
> allows them to find hidden SSIDs).  As a requirement for supporting this
> capability, the driver _MUST_ implement the required bits in its
> SIOCSIWSCAN handler to scan for the requested SSID, or else the driver
> is in error.

Agreed.

> Userspace apps can then intelligently determine whether to use ap_scan=1
> or ap_scan=2 with wpa_supplicant.  If the driver is not fixed to
> advertise this capability, userspace can fall back to ap_scan=2 and the
> driver is clearly the problem in this case, and the responsible piece of
> code can be blamed and fixed.

Sure.

> The problem is that there isn't a nice, generic capabilities field in
> WEXT.  So we have to abuse an existing one, and I picked enc_capa.

This is what we keep doing and this is why WEXT has become a big pile
of hacks, and precisely for this reason is why we should abandon it.
Lets please not abuse it any further and instead help try to uplift
cfg80211 and nl80211.

> Obviously cfg80211/net80211 would be able to export this capability
> directly in the capability bits for each driver.  This issue is only a
> problem with WEXT (unless cfg80211 doesn't have this capability yet).

cfg80211/nl80211 (net80211 is FBS's wireless stack) doesn't export
this in any way yet.

> The patch below is just to show how this might be accomplished.
> Obviously mac80211 drivers have this capability.  So does ipw2200.
> ipw2100 does not have this capability, and therefore does not set the
> bit in enc_capa.
>
> Thoughts?  It's at the point where something just needs to be done to
> fix the situation.

I believe the right solution here is to ignore WE and instead focus on
cfg80211/nl80211. Since you are willing to modify drivers for this
capability lets instead add cfg80211_ops to those drivers which you
want to fix and add a new NL80211_CMD_GET_SCAN_CAP or the like. Its
probably a bit more effort but its in the right direction and will
help us advance and embrace new the new framework laid out for us.

As for compatibility -- I've added nl80211 now as part of the
compat-wireless-2.6 package, which means kernels >= 2.6.22 can reap
benefits from it

  Luis
