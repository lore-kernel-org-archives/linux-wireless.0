Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:52837 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYCRKYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2008 06:24:25 -0400
Date: Tue, 18 Mar 2008 12:23:44 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
Message-ID: <20080318102344.GG5308@jm.kir.nu> (sfid-20080318_102428_310094_F3F260D7)
References: <1205758276.1614.45.camel@johannes.berg> <1ba2fa240803170636t6158c0a8vb180f71352208548@mail.gmail.com> <1205761758.1614.79.camel@johannes.berg> <1ba2fa240803171212s36f85306i6f47ed9fa725b90@mail.gmail.com> <1205781593.16475.20.camel@johannes.berg> <1ba2fa240803171239l6b07ba4ch2b2aaca5e7fa0506@mail.gmail.com> <1205784255.16475.33.camel@johannes.berg> <1ba2fa240803171327r4c817228kc4f248abf0a0cea@mail.gmail.com> <20080318080435.GA5308@jm.kir.nu> <1205831880.16475.43.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1205831880.16475.43.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 18, 2008 at 10:18:00AM +0100, Johannes Berg wrote:

> > At least the original d80211 design supported multiple SSIDs per BSS and
> > yes, as far as kernel code is concerned, this was done in the identical
> > way for both multi-SSID and dynamic-VLAN (RADIUS assigned). A new
> > virtual interface is added for both cases and STAs are bound to the
> > specific virtual interface based on MLME/RADIUS results.

> Ah. I guess that requires hiding the SSID though?

Not necessarily. The AP can advertise one SSID in Beacon frames and then
reply with Probe Response to multiple SSIDs (well, these other SSIDs
would of course be "hidden" in the sense that they are not broadcast in
Beacon frames). This works relatively well with most clients as long as
the security policy with the main SSID (the one advertised in the Beacon
frames) and the secondary ones (the ones that are only visible in Probe
Response frames) are identical. If they are different (e.g., open vs.
WPA), problems are to be expected with many client implementations since
this does not exactly match with the standard..

-- 
Jouni Malinen                                            PGP id EFC895FA
