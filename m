Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49738 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab3GIFkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 01:40:47 -0400
From: "Peer, Ilan" <ilan.peer@intel.com>
To: Jouni Malinen <j@w1.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@do-not-panic.com" <mcgrof@do-not-panic.com>,
	"Spinadel, David" <david.spinadel@intel.com>
Subject: RE: [PATCH 3/3] [RFC] cfg80211: Enable GO operation on additional
 channels
Date: Tue, 9 Jul 2013 05:40:30 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A01AD2D097@HASMSX106.ger.corp.intel.com> (sfid-20130709_074054_595799_55B07B59)
References: <1372768095-26053-1-git-send-email-ilan.peer@intel.com>
 <1372768095-26053-4-git-send-email-ilan.peer@intel.com>
 <20130708100418.GA10670@w1.fi>
In-Reply-To: <20130708100418.GA10670@w1.fi>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Jouni Malinen [mailto:j@w1.fi]
> Sent: Monday, July 08, 2013 13:04
> To: Peer, Ilan
> Cc: linux-wireless@vger.kernel.org; mcgrof@do-not-panic.com; Spinadel, David
> Subject: Re: [PATCH 3/3] [RFC] cfg80211: Enable GO operation on additional
> channels
> 
> On Tue, Jul 02, 2013 at 03:28:15PM +0300, Ilan Peer wrote:
> > Allow GO operation on a channel marked with
> IEEE80211_CHAN_INDOOR_ONLY
> > or IEEE80211_CHAN_GO_CONCURRENT iff there is an active station
> > interface that is associated to an AP operating on this channel.
> >
> > Note that this is a permissive approach to the FCC definitions, that
> > require a clear assessment that either the platform device is an
> > indoor device, or the device operating the AP is an indoor device,
> > i.e., AC powered.
> > It is assumed that these restrictions are enforced by user space.
> 
> The introduction in 0/3 mentioned DFS, but I did not see it being addressed in
> any of the actual changes. Is this only for indoors vs.
> outdoors?
>

The DFS was mentioned in 0/3 in the context of an example for a case where a device can support WFD on bands where an authorized master is operating. The example assumes that the master has radar detection capabilities and is able to evacuate its operating channel if needed (which must be followed by the device also evicting the WFD operation from this channel). 

The purpose of this patch was to allow the instantiation of a GO on channels marked as indoor/Concurrent GO assuming some conditions are met, ignoring the NO_IBSS and PASSIVE channels. I intend to implement to full restriction logic in the wpa_supplicant (based on the device type etc.), and also handle the actual indication that this channel can no longer be used, eviction and new channel selection in the wpa_supplicant.

> > Furthermore, it is assumed, that if the conditions that allowed for
> > the operation of the GO on such a channel change, it is the
> > responsibility of user space to evacuate the GO from the channel.
> 
> Do you have plans or changes to address this? I'd assume wpa_supplicant could
> stop the group on channel list changes, but I don't think it does that currently.

Yes. This is currently WIP :)
