Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3519 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbXJJPjU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 11:39:20 -0400
Date: Wed, 10 Oct 2007 11:13:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] mac80211: store SSID in sta_bss_list
Message-ID: <20071010151319.GD5962@tuxdriver.com> (sfid-20071010_163932_166500_C10062A0)
References: <11919737992212-git-send-email-linville@tuxdriver.com> <1191973799635-git-send-email-linville@tuxdriver.com> <1192006959.12541.2.camel@johannes.berg> <1192027003.9739.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1192027003.9739.7.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 10, 2007 at 10:36:43AM -0400, Dan Williams wrote:
> On Wed, 2007-10-10 at 11:02 +0200, Johannes Berg wrote:
> > On Tue, 2007-10-09 at 19:49 -0400, John W. Linville wrote:
> > > From: John W. Linville <linville@tuxdriver.com>
> > > 
> > > Some AP equipment "in the wild" services multiple SSIDs using the
> > > same BSSID.  This patch changes the key of sta_bss_list to include
> > > the SSID as well as the BSSID and the channel so as to prevent one
> > > SSID from eclipsing another SSID with the same BSSID.
> 
> The "standard" (which is a stretch) was that only _one_ SSID can be
> broadcast in beacons, and the rest of the supported SSIDs must be
> hidden.  Is that the case?  Or is the AP you're referring to actually
> pushing out multiple beacons with different not-hidden SSIDs and the
> same BSSID?

My impression is that the standard is not particularly clear on this,
hence the variety of behaviors.  Can you cite specific wording?

My research indicates the existance of both "1 beacon, N-1 hidden"
and "N beacons" behaviors.  Either way, the sta_bss_list can be
populated not just from beacons but also from probe responses.
So even if N-1 SSIDs are hidden, we still need to be able to record
information about them.

Unfortunately I don't have any hardware that behaves in this fashion.
I discovered references to this behavior while researching the
preceding "same BSSID on different frequencies" patch.  Having become
aware of this behavior, I figured it was worth fixing at the same
time to avoid future bug reports.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
