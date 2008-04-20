Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115AbYDTPhQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 11:37:16 -0400
Subject: Re: RE: iwl3945 problem with 2.6.25-rc9
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vincent C Jones <v.jones@networkingunlimited.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Brian Morrison <bdm@fenrir.org.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1208613091.26186.26.camel@johannes.berg>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>
	 <fu931e$k1b$1@ger.gmane.org>
	 <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com>
	 <1208555842.4848.56.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
	 <20080418232358.000fbdf7@peterson.fenrir.org.uk>
	 <1208558255.4848.60.camel@johannes.berg>
	 <1208558382.4848.63.camel@johannes.berg>
	 <1ba2fa240804181728u7a3440cajbba7dcc696d02909@mail.gmail.com>
	 <1208593973.26186.2.camel@johannes.berg>
	 <1208608786.3980.7.camel@X61.NetworkingUnlimited.com>
	 <1208610565.26186.17.camel@johannes.berg>
	 <1208612641.3980.31.camel@X61.NetworkingUnlimited.com>
	 <1208612902.26186.23.camel@johannes.berg>
	 (sfid-20080419_144855_272045_BB1CE2BE)  <1208613091.26186.26.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 20 Apr 2008 11:33:32 -0400
Message-Id: <1208705612.5036.18.camel@localhost.localdomain> (sfid-20080420_163731_643956_604EC0C4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-04-19 at 15:51 +0200, Johannes Berg wrote:
> > > I'll leave it up to you (collective you, not necessarily a personal
> > > you), how to best deal with associating with APs which are not
> > > broadcasting their SSIDs. I agree with you (personal you this time) that
> > > roaming around the country broadcasting those SSIDs does not seem
> > > particularly desirable. So how should the ability to connect to non SSID
> > > broadcasting APs be implemented? 
> > 
> > I would probably list, in network-manager, "I found (a) hidden
> > network(s)" and ask the user for an SSID to scan for actively at that
> > particular time, rather than trying to scan for all previously known
> > SSIDs even if those networks weren't hidden, as windows laptops (at
> > least those with Intel hardware but I haven't seen many others) seem to
> > do.
> 
> Or it could remember the BSSID and when it encounters the BSSID again
> scan it actively to see if it still has the same (albeit hidden) SSID.

That's what NM does; NM will cache the BSSIDs of previously associated
APs and use that to determine which APs to connect to automatically.

wpa_supplicant, unfortunately, doesn't use this trick when associating
(since it doesn't really store state at all), and therefore in the
hidden AP case, NM passes "ap_scan=1 + scan_ssid=1" to probe-scan the AP
that we want to connect to.  But that's still only _one_ AP being
probe-scanned, not 4...

There's likely some room for improvement in wpa_supplicant here, since
there's added latency waiting for the supplicant to do scans when NM
already knows exactly which AP/BSSID to connect to already, but we can't
push the exact SSID into the supplicant's config, because that would
cause the supplicant to only ever assocate with that AP (I _think_ so at
least) and therefore not roam correctly.

Dan

> My N810 behaves that way too, incidentally, it seems to first scan
> broadcast but if you then don't select a network quickly it starts
> scanning all networks directedly that it has previously saved.
> 
> johannes

