Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx73.mail.ru ([94.100.176.87]:42395 "EHLO mx73.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbZIJWDk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 18:03:40 -0400
Received: from mx39.mail.ru (mx39.mail.ru [94.100.176.53])
	by mx73.mail.ru (mPOP.Fallback_MX) with ESMTP id 9C7EA640882
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2009 02:03:38 +0400 (MSD)
Subject: Re: A station can't reconnect after it wakes up
From: Igor Perminov <igor.perminov@inbox.ru>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
	Jouni Malinen <j@w1.fi>, Artur Skawina <art.08.09@gmail.com>
In-Reply-To: <1249312925.8515.187.camel@sunlight>
References: <1248969930.29068.224.camel@sunlight>
	 <4A7318E6.3000004@gmail.com>  <1249312925.8515.187.camel@sunlight>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 02:03:04 +0400
Message-Id: <1252620184.26765.65.camel@sunlight>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 03/08/2009 at 19:22:05 +0400, Igor Perminov wrote:
> On Fri, 31/07/2009 at 18:16 +0200, Artur Skawina wrote:
> [linux-wireless added to cc list]
> > 
> > Igor Perminov wrote:
> > > I have an issue related to handling power-saving stations by hostapd
> > > and/or mac80211 stack. A station can't reconnect after it wakes up.
> > > 
> > > The problems looks similar to another one having been reported to this
> > > list earlier (STA can connect, but fails to reconnect within
> > > ap_max_inactivity):
> > > http://lists.shmoo.com/pipermail/hostap/2009-February/019192.html
> > > 
> > > AP: Linux box with D-Link DWA-110 USB Wi-Fi stick (rt73usb kernel
> > > driver), kernel 2.6.30 with some patches, hostapd 0.6.9.
> > > Station: Toshiba G900 PDA under Windows Mobile 6.0.
> > > 
> > > The environment is described in details here:
> > > http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=5&t=5486&start=10
> > > 
> > > Consider the following step-by-step:
> > > 1. A station authenticates and associates with the AP and exchanges
> > > traffic.
> > > 2. The station indicates to the AP that it is going to sleep.
> > > 3. The station device goes to the stand-by mode (not only its wi-fi
> > > card, but the device itself).
> > > 4. The station device wakes up and begins authentication with an
> > > Authentication management frame.
> > > 
> > > This is the behavior of my PDA.
> > > 
> > > The problem is the mac80211 stack at the point 4 "remembers" that the
> > > station has gone to sleep. So, the response frames from hostapd are
> > > buffered by mac80211.
> > > The station indicates in the Authentication frame that it isn't sleeping
> > > anymore. But the mac80211 stack analyzes sleep/wake transitions in
> > > _data_ frames only, but not in management ones. See
> > > ieee80211_rx_h_sta_process in net/mac80211/rx.c. A comment there notes:
> > > "Ignore doze->wake transitions that are indicated by non-data frames,
> > > the standard is unclear here".
> > > As the result, the station never receives the authentication response
> > > from the AP.
> > > 
> > > One solution against this problem could be implemented in hostapd: to
> > > force the mac80211 stack to "forget" the station just after receiving an
> > > authentication frame (the patch is below). After this change the station
> > > can reconnect successfully.
> > 
> > i just did a quick test and your hostapd patch does indeed fix my problem
> > too (p54+hostapd with a winmobile device that couldn't reconnect after
> > turning the wifi module off and on). 
> > 
> > > Another solution (in theory) would be to improve the mac80211
> > > implementation: to analyze not only data frames, but also
> > > management ones (or may be just some kinds of them) in
> > > ieee80211_rx_h_sta_process.
> > 
> > would seem to make sense, but having not read the spec i have no idea
> > if that's the right answer; hence the linux-wireless cc...
> > 
> > > I've asked this question to the linux-wireless mailing list few days
> > > ago, but nobody has answered still:
> > > http://marc.info/?l=linux-wireless&m=124879549212741&w=2
> > > 
> > > And what is your opinion, what is a better way: should this problem be
> > > fixed in hostapd or in mac80211?
> > > 
> > > === Begin diff ===
> > > --- a/hostapd/ieee802_11.c	2009-06-29 14:21:59.000000000 +0400
> > > +++ b/hostapd/ieee802_11.c	2009-07-21 16:28:17.000000000 +0400
> > > @@ -583,6 +583,13 @@
> > >  		goto fail;
> > >  	}
> > >  
> > > +	res = hostapd_sta_remove(hapd, mgmt->sa);
> > > +	if (res) {
> > > +		wpa_printf(MSG_DEBUG, "authentication: STA=" MACSTR
> > > +				", hostapd_sta_remove returned %d\n",
> > > +				MAC2STR(mgmt->sa), res);
> > > +	}
> > > +
> > >  	if (vlan_id > 0) {
> > >  		if (hostapd_get_vlan_id_ifname(hapd->conf->vlan,
> > >  					       sta->vlan_id) == NULL) {
> > > === End diff ===
> > 
> > Thanks for the cc, added this to my local hostapd patch set, until the
> > issue gets resolved one way or another.
> > 
> > artur
> 
> I've looked through the 802-11.2007 document and now I consider the
> source of the problem is misunderstanding by an AP and a STA states of
> each other. When the station tries to reconnect it considers itself
> non-authenticated. Whereas the AP considers the station both
> authenticated and associated.
> 
> I think it would be better to fix the problem in hostapd, because it's a
> hostapd's responsibility - to manage the state of a station being known
> to the AP. So, when hostapd receives an Auth frame from a station it
> should consider the station being non-authenticated and force removing
> the station from the underlying stack.
> 
> I'll submit a patch for hostapd in a nearest future.
> 
> Best regards,
> Igor

Hi,

I've submitted the hostapd patch mentioned above to the hostap mailing
list and have got a comment from Jouni Malinen (I haven't received a
e-mail from Jouni for an odd reason and have found his reply in the
mailing list archive by accident just now).

Remember, the patch forces mac80211 to "forget" the station just after
receiving an authentication frame. Jouni's comment can be found here:
http://lists.shmoo.com/pipermail/hostap/2009-August/020083.html
In general, Jouni has rejected the patch, because such "forgetting"
should not be done in number of cases (e.g., 802.11r).
So, the only place to recover from "misunderstanding" station's state is
mac80211.

Jouni suggests to not buffer Auth/Assoc frames at all, independently of
station's PS state. I think, it isn't enough, because an AP should send
a number of EAPOL Key frames after that, which are data frames and
therefore will be buffered anyway.

I think mac80211 in AP mode should reset WLAN_STA_PS flag of the station
(and purge frames having been buffered previously if any) on an event
indicating beginning of authentication.
The event may be one of the following:
A) An Auth frame being received from the station.
B) An Auth frame being sent to the station.
C) A special API call from an application (hostapd), when it is
receiving an Auth frame from the station and is beginning
authentication/association.

Johannes, what do you think of these approaches?

Regards,
Igor


