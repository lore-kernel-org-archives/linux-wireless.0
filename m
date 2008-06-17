Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323AbYFQTDo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 15:03:44 -0400
Subject: Re: [PATCH] mac80211: remove shared key todo
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240806171141sda9c0eak747adbba3a6fe4db@mail.gmail.com>
References: <1213642529.3803.47.camel@johannes.berg>
	 <1213647566.18384.6.camel@localhost.localdomain>
	 <1213647709.3803.50.camel@johannes.berg>
	 <1213648729.18384.11.camel@localhost.localdomain>
	 <1213649176.3803.55.camel@johannes.berg>
	 <1213726378.30192.8.camel@localhost.localdomain>
	 <1ba2fa240806171141sda9c0eak747adbba3a6fe4db@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 17 Jun 2008 15:02:51 -0400
Message-Id: <1213729371.30192.26.camel@localhost.localdomain> (sfid-20080617_210349_682280_6A260158)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-06-17 at 21:41 +0300, Tomas Winkler wrote:
> On Tue, Jun 17, 2008 at 9:12 PM, Dan Williams <dcbw@redhat.com> wrote:
> > On Mon, 2008-06-16 at 22:46 +0200, Johannes Berg wrote:
> >> > > I have no idea. Usually, you don't even do open auth for IBSS, there's
> >> > > just no point. Unless you get into IBSS with encryption, but we don't
> >> > > really support that yet, and we probably never will actually support
> >> > > that without the userspace MLME in wpa supplicant.
> >> >
> >> > IBSS + WEP works at least for ipw2200 and other non-mac80211 cards; I
> >> > can check it out with mac80211 if you like.
> >>
> >> Yeah, no, +WEP should work. I haven't specifically tested it but I see
> >> no reason for it not to work.
> >>
> >> > Any particular reason IBSS would require a userspace MLME?  There
> >> > shouldn't be any rekeying of any kind with adhoc, since there's no
> >> > central station to coordinate the rekying.  AFAIK with IBSS you just use
> >> > the given PSK at creation time, and never change it.  That shouldn't be
> >> > too hard to handle, right?
> >>
> >> Well, I was really thinking of RSN/WPA, and last I checked
> >> wpa_supplicant didn't even support that with IBSS, and I think it
> >> requires userspace MLME because you have to do the auth/assoc sequence
> >> with each peer etc.
> >
> > wpa_supplicant _should_ support WPA-PSK with IBSS, you set
> > proto=WPA-NONE to do this and I assume it just sends the PSK to the
> > driver and never changes it.  I haven't tested it a long time though.
> >
> > Dan
> >
> #~ cat wpa_supplicant.conf
> # mode: IEEE 802.11 operation mode
> # 0 = infrastructure (Managed) mode, i.e., associate with an AP (default)
> # 1 = IBSS (ad-hoc, peer-to-peer)
> # Note: IBSS can only be used with key_mgmt NONE (plaintext and static WEP)
> # and key_mgmt=WPA-NONE (fixed group key TKIP/CCMP). In addition, ap_scan has
> # to be set to 2 for IBSS. WPA-None requires following network block options:
> # proto=WPA, key_mgmt=WPA-NONE, pairwise=NONE, group=TKIP (or CCMP, but not
> # both), and psk must also be set.

Yeah, key_mgmt=WPA-NONE, thanks for the correction.  Any idea if this
works already on iwlwifi?

Dan

