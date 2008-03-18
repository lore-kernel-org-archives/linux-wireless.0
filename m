Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:43810 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbYCRIFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2008 04:05:17 -0400
Date: Tue, 18 Mar 2008 10:04:35 +0200
From: Jouni Malinen <j@w1.fi>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
Message-ID: <20080318080435.GA5308@jm.kir.nu> (sfid-20080318_080522_271401_F42CC8CF)
References: <1205751455.1614.25.camel@johannes.berg> <1ba2fa240803170540n2e6fb398p84abfb34e4124042@mail.gmail.com> <1205758276.1614.45.camel@johannes.berg> <1ba2fa240803170636t6158c0a8vb180f71352208548@mail.gmail.com> <1205761758.1614.79.camel@johannes.berg> <1ba2fa240803171212s36f85306i6f47ed9fa725b90@mail.gmail.com> <1205781593.16475.20.camel@johannes.berg> <1ba2fa240803171239l6b07ba4ch2b2aaca5e7fa0506@mail.gmail.com> <1205784255.16475.33.camel@johannes.berg> <1ba2fa240803171327r4c817228kc4f248abf0a0cea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240803171327r4c817228kc4f248abf0a0cea@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 17, 2008 at 10:27:53PM +0200, Tomas Winkler wrote:
> On Mon, Mar 17, 2008 at 10:04 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >  Well, you were suggesting the use of multiple SSIDs, which we don't
> >  support, we only support VLANs within a BSS/single SSID. Not that I've
> >  been able to test it, hostapd needs radius stuff set up for VLANs...
> 
> I think it's transparent since it's handled by MLME in hostapd so
> multiple SSID is supported
> Maybe we did some minor changes in mac to support that.. Will check again.
> I think it's always done by means of VLANs

At least the original d80211 design supported multiple SSIDs per BSS and
yes, as far as kernel code is concerned, this was done in the identical
way for both multi-SSID and dynamic-VLAN (RADIUS assigned). A new
virtual interface is added for both cases and STAs are bound to the
specific virtual interface based on MLME/RADIUS results.

However, I do not think I ever merged multi-SSID support into the open
source version of hostapd, so it is quite possible that only the
RADIUS-based VLAN assignment is currently used since multi-SSID support
is inferior to multi-BSS support for number of reasons. Anyway, that
does not change what mac80211 would support should one ever really want
to enable multi-SSID support with a single BSS. I don't see much need
for that, though, if one can use virtual BSSes.

-- 
Jouni Malinen                                            PGP id EFC895FA
