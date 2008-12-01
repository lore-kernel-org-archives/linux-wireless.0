Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32530 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbYLAXxe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 18:53:34 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 15:53:34 -0800
Date: Mon, 1 Dec 2008 15:53:32 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vivek Natarajan <Vivek.Natarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@nokia.com>
Subject: Re: [RFC] mac80211: Enhancements to dynamic power save.
Message-ID: <20081201235331.GU5992@tesla> (sfid-20081202_005337_352115_A51A0172)
References: <20081202011754.GA9382@myhost.users.atheros.com> <1228132431.3478.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1228132431.3478.21.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2008 at 03:53:51AM -0800, Johannes Berg wrote:
> On Mon, 2008-12-01 at 17:17 -0800, Vivek Natarajan wrote:
> > This patch is based on Kalle's initial RFC patches on dynamic power save.
> > Since ath9k/ath5k,stlc45xx and b43 need the driver to send the null
> > frame, it is appropriate to do it from mac80211. 
> > This patch enables mac80211 to send a null frame and also to
> > check for tim in the beacon if power save is enabled.
> 
> Nice! Looks pretty much good to me, but could use some documentation
> (Kalle will hopefully add some too). For instance, a casual observer
> might wonder how the hardware can be saving power when the host software
> has to parse beacons -- obviously things will only fall into place once
> we support beacon miss offload.

BTW does broadcom hw support beacon miss stuff? We need to consider
carefully how we add beacon miss support because if we want to rely on
it *and* also disable say the beacon filter we will be missing out on
DFS channel switch announcements and HT channel badwidth changes from
the AP.

  Luis
