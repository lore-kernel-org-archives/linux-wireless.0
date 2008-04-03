Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:58979 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYDCQos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 12:44:48 -0400
Date: Thu, 3 Apr 2008 19:43:30 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Javier Cardona <javier@cozybit.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	Bill Moss <bmoss@CLEMSON.EDU>, Daniel Drake <dsd@gentoo.org>,
	Dan Williams <dcbw@redhat.com>, Vladimir Koutny <vlado@ksp.sk>,
	Tomas Winkler <tomasw@gmail.com>,
	John Linville <linville@tuxdriver.com>
Subject: Re: mac80211 MLME scanning - BSS list trouble
Message-ID: <20080403164330.GH2025@jm.kir.nu> (sfid-20080403_174453_066657_D1EB282C)
References: <1206865999.22530.187.camel@johannes.berg> <20080331150423.GQ14333@jm.kir.nu> <1207055773.5143.91.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1207055773.5143.91.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 01, 2008 at 03:16:13PM +0200, Johannes Berg wrote:

> Right. But in that case, a beacon frame we receive will update the
> <BSSID,""> BSS structure, not the <BSSID,actual SSID> structure because
> the update code will find only the former since the SSID is hidden.
> TheBSS structure w/o SSID won't actually be used.

The Beacon frames would probably need to update all <BSSID,*> entries
for the fields that we decide need to be updated based on Beacons, not
just the <BSSID,"">... Alternatively, we could change the BSS table to
have just one entry for each BSSID and a list of SSID entries for each
BSSID (with SSID, WPA/RSN IE, Privacy flag, etc. from ProbeResp). This
would be internal to kernel, though, and the scan result would likely
need to continue showing these as separate "BSSes" even though they have
the same BSSID.

> > One example of information that should not be overridden by Beacon
> > frames is WPA and RSN IE since these could differ based on the SSID in
> > multi-SSID configurations. An example of information that must be
> > updated from every Beacon frame would be ERP IE. Finally, there are also
> > more complex cases, like the Capability Information, which should
> > probably be handled separately for each subfield (e.g., Privacy could be
> > per-SSID and Short Slot Time for every SSID of the BSSID).
> 
> Right. But wouldn't that be covered by operating on different BSS
> structs?

It is next to impossible to figure out which SSID the Beacon frame is
based on in multi-SSID configuration and as such, it is difficult to say
which BSS structure would be updated.. I think there has to be support
for selective update of information based on Beacon frames, but there
are multiple ways of implementing this.

> > Any information that has to be same for all SSIDs in multi-SSID (single
> > BSSID) configuration can be updated based on Beacon frames since the
> > SSIDs for a specific SSID would not contain any different information
> > for these parts. However, fields that can be configured per-SSID, must
> > be handled separately in order to be able to support multi-SSID
> > configuration with different security policies per SSID. This would
> > mainly included Privacy flag in the capability field and security
> > related IEs (WPA IE, RSN IE), but there may be something else that would
> > benefit of similar handling.
> 
> It might help if there was code in hostapd to actually do run this
> scenario. *hint* *hint* :)

Yeah.. Well, the problem is that no one has asked (as far as I know) for
this for a real world use case after multi-BSS support was added. Sure,
this would be nice for testing purposes, but the changes needed for
multi-SSID support are somewhat complex and would not only require quite
a bit of work now, but also make long term maintenance take more
effort..

I'm not completely against doing this, but this is not exactly on top of
my to-do list ;-).

-- 
Jouni Malinen                                            PGP id EFC895FA
