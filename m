Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32951 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbaBTLIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 06:08:48 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v4 3/5] cfg80211: Enable GO operation on additional
 channels
Date: Thu, 20 Feb 2014 11:08:32 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A0333844C0@HASMSX106.ger.corp.intel.com> (sfid-20140220_120900_504560_AD9F75CD)
References: <1392824377-18254-1-git-send-email-ilan.peer@intel.com>
 <1392824377-18254-4-git-send-email-ilan.peer@intel.com>
 <20140219162410.GK14296@garbanzo.do-not-panic.com>
In-Reply-To: <20140219162410.GK14296@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Luis R. Rodriguez [mailto:mcgrof@gmail.com] On Behalf Of Luis R.
> Rodriguez
> Sent: Wednesday, February 19, 2014 18:24
> To: Peer, Ilan
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: [PATCH v4 3/5] cfg80211: Enable GO operation on additional
> channels
> 
> On Wed, Feb 19, 2014 at 05:39:35PM +0200, Ilan Peer wrote:
> > Allow GO operation on a channel marked with
> > IEEE80211_CHAN_GO_CONCURRENT iff there is an active station interface
> > that is associated to an AP operating on the same channel in the 2 GHz
> > band or the same UNII band (in the 5 GHz band). This relaxation is not
> > allowed if the channel is marked with IEEE80211_CHAN_RADAR.
> >
> > Note that this is a permissive approach to the FCC definitions, that
> > require a clear assessment that the device operating the AP is an
> > authorized master, i.e., with radar detection and DFS capabilities.
> 
> Come to think of it, do we want to make this an FCC specific thing only? If so
> then the dfs_region could be checked prior to enablement.

The direction is set by the FCC but other regulatory bodies take similar approach. For example see page 27 in this ETSI standard where the same frequency ranges are mentioned (without specifically calling them UNII) and the same concept of channel bundles is defined for testing.

http://www.etsi.org/deliver/etsi_en/301800_301899/301893/01.07.01_60/en_301893v010701p.pdf

> If the premise is that we'd trust to be associated to a non-GO type AP, that is
> a real AP, then we could likely consider a requirement that this real AP would
> be using a country IE as well. Please consider this.

Not sure that is needed. As I mentioned earlier it is the responsibility of user space to verify that this is not a GO, so it does not really make a difference if it tests for the P2P IEs or the country IE.

Regards,

Ilan.
