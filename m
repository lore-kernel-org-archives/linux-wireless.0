Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25926 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbYKCA0C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 19:26:02 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 16:26:02 -0800
Date: Sun, 2 Nov 2008 16:25:59 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Tomas Winkler <tomasw@gmail.com>, Michael Buesch <mb@bu3sch.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: No ProbeResp - assume out of range
Message-ID: <20081103002558.GA14153@tesla> (sfid-20081103_012607_891466_03CCC8B6)
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com> <200811022303.54476.mb@bu3sch.de> <1ba2fa240811021442o178c98a1pa920b863b60d9293@mail.gmail.com> <43e72e890811021458h1444d350v33a5e5b984b76495@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <43e72e890811021458h1444d350v33a5e5b984b76495@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 02, 2008 at 02:58:49PM -0800, Luis R. Rodriguez wrote:
> On Sun, Nov 2, 2008 at 2:42 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> > On Mon, Nov 3, 2008 at 12:03 AM, Michael Buesch <mb@bu3sch.de> wrote:
> >> On Sunday 02 November 2008 22:05:56 Luis R. Rodriguez wrote:
> >>> I'm curious if others are getting this frequently as I am:
> >>>
> >>> No ProbeResp from current AP 00:DE:AD:BE:EE:FF - assume out of range
> >>>
> >>> I get this with ath5k and ath9k, can be triggered easily in ath5k by
> >>> doing a lot of consecutive:
> >>>
> >>> iwlist wlan0 scan
> >>>
> >>> I have to check if I can trigger this with ath9k by scanning too. We
> >>> were seeing this with ath9k but were thinking it was ath9k related as
> >>> it can be triggered on it after doing a large TX. Wondering if this is
> >>> more of a generic and mac80211 issue.
> >>
> >> IMO this is a mac80211 issue.
> >> mac80211 immediately assumes the connection is broken, if one probe-resp
> >> to a keekalife-proberequest is lost.
> >> So if you scan just after the request got sent, you'll never receive the response
> >> and mac80211 will terminate the connection.
> >> It should try a few times, instead, before blowing up things.
> >
> > I've seen this happening  in high traffic with some APs but it can be
> > also NIC issue. It needs to really investigate the sniffer capture I
> > wouldn't assume its only mac80211 issue.  Probe is issued only when RX
> > is not received for some time so there is some problem, nevertheless
> > monitoring beacons is a better approach from my experience.
> 
> Agreed if it can be NIC issue, but it seems to be a common issue now
> across a few drivers, not just ath5k/ath9k.
> 
> Hm, ieee80211_rx_mgmt_beacon() is not being hit with ath5k, something is fishy.

OK I found the issue with ath5k, no beacons were being passed at all, I'll post
a patch.

  Luis

