Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:36519 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbaBTH64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 02:58:56 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: RE: [PATCH v3 6/6] mac80211: Enable initiating radiation on indoor
 channels
Date: Thu, 20 Feb 2014 07:58:50 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A033383EED@HASMSX106.ger.corp.intel.com> (sfid-20140220_085900_017006_1D0CCB59)
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
 <1390818118-27261-7-git-send-email-ilan.peer@intel.com>
 <20140219001458.GF14296@garbanzo.do-not-panic.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A03338353E@HASMSX106.ger.corp.intel.com>
 <20140219160301.GH14296@garbanzo.do-not-panic.com>
In-Reply-To: <20140219160301.GH14296@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Wed, Feb 19, 2014 at 03:28:29PM +0000, Peer, Ilan wrote:
> > I'll abandon this change ...
> 
> Wait lets talk about this.
> 
> > > I don't see why being indoor should allow to override the NO-IR
> > > flag. I do see however why being indoor should enable to IR if you
> > > are IR if you have the indoor flag. Enabling to IR if you are indoor
> > > for all NO-IR channels is... pretty permissive I do not see the correlation.
> > >
> >
> > Make sense. I did not have such relaxations defined, just thought that
> > similar relaxations could also be used in cases of scanning etc. but I
> > guess this is not always true.
> 
> The original beacon hint mechanism is very expansive to all beacons on non 5
> GHz DFS channels and non 2.4 channel
> 12 or 13. If a vendor can possibly not like that beacon hint implementation as
> its too permissive (and I don't think it is) but they do want to trust beacon
> hints from APs in the case you are describing then you can enable a new
> feature flag to distinguish this. The beacon infrastructure code would then
> ignore the regular beacon hints on devices that don't have the old flag, but
> would trust this new form of beacon hint. If a device supported the old all
> inclusive flag they'd trust both. You'd have to update the kdocs for the old
> one, and likely add a new routine similar to regulatory_hint_found_beacon().
> 

This make sense (also got a direct answer from our regulatory folks on this ... finally ;))

> I'm not sure its worth it though, I'd rather push vendors to consider first using
> the regular becaon hint mechanism and trusting it. Maybe devices that want
> this new functionality you are trusting should implicate revising trusting
> beacon hint mechanism ?
> 

Our regulatory people said that a similar approach is WIP in the FCC where they are willing to use a similar relaxation as the beacons hints but with some limitations such as having at least a number of APs operating on the channel etc. 

If its ok with you I prefer to leave things as is for now.

Regards,

Ilan.

