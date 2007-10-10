Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbXJJOgc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 10:36:32 -0400
Subject: Re: [RFC PATCH 2/2] mac80211: store SSID in sta_bss_list
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1192006959.12541.2.camel@johannes.berg>
References: <11919737992212-git-send-email-linville@tuxdriver.com>
	 <1191973799635-git-send-email-linville@tuxdriver.com>
	 (sfid-20071010_010921_998777_FA0E0694)  <1192006959.12541.2.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 10 Oct 2007 10:36:43 -0400
Message-Id: <1192027003.9739.7.camel@localhost.localdomain> (sfid-20071010_153637_050055_FF31AD68)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-10-10 at 11:02 +0200, Johannes Berg wrote:
> On Tue, 2007-10-09 at 19:49 -0400, John W. Linville wrote:
> > From: John W. Linville <linville@tuxdriver.com>
> > 
> > Some AP equipment "in the wild" services multiple SSIDs using the
> > same BSSID.  This patch changes the key of sta_bss_list to include
> > the SSID as well as the BSSID and the channel so as to prevent one
> > SSID from eclipsing another SSID with the same BSSID.

The "standard" (which is a stretch) was that only _one_ SSID can be
broadcast in beacons, and the rest of the supported SSIDs must be
hidden.  Is that the case?  Or is the AP you're referring to actually
pushing out multiple beacons with different not-hidden SSIDs and the
same BSSID?

Dan


