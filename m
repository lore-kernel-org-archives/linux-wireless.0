Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbYHROcz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 10:32:55 -0400
Subject: RE: [Rt2400-devel] mac80211 / rt2x00 / rt61 and adhoc status
From: Dan Williams <dcbw@redhat.com>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: "'Ivo van Doorn'" <ivdoorn@gmail.com>, hostap@lists.shmoo.com,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <059801c900a9$c9eee740$0b3ca8c0@gotws1589>
References: <059801c900a9$c9eee740$0b3ca8c0@gotws1589>
Content-Type: text/plain; charset=utf-8
Date: Mon, 18 Aug 2008 10:34:08 -0400
Message-Id: <1219070048.5013.40.camel@localhost.localdomain> (sfid-20080818_163259_813183_9E7C447F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-08-17 at 22:42 +0200, Lars Ericsson wrote:
> > > > > > Two tests cases, but same behaviour:
> > > > > > 1) Linx.git: 2.6.26 and wpa_supplicant 0.5.9
> > > > > > 2) rt2x00.git: Version 2.2.0 and wpa_supplicant 0.5.9
> > > > >=20
> > > > > Are any beacons going out? Is there anything in the logs whic=
h
> > > > > indicates what is happening?
> > > > >=20
> > > >=20
> > > > As you can se in the trace below, the configuration=20
> > > proceeds and the adhoc
> > > > is created.
> > > > The warnon might give some clues.
> > >=20
> > > So how about those beacons? are they getting out?
> > >=20
> >=20
> > After patching the wpa_suplicant (0.5.9) adhoc works.
> > When first started, as the only part in the adhoc net, the=20
> > driver just scans
> > around for other adhoc members.
> > This happen in mac80211 state 4 and no beacons are sent, as=20
> > far as I can
> > tell. Only probe requests are sent.
> >=20
> > When an other node (N2) shows up in the same adhoc net work, N2 sta=
rts
> > sending beacons immediately.
> > The RT61 catch that and merge that ibss, switch to state 5=20
> > and all is fine.
> > At this time ping works in both directions.
> >=20
> > When removing the second note, leaving the RT61 alone, RT61=20
> > starts sending
> > beacons, still in state 5.
>=20
> The reason for the above behaviour are timeouts.
> - Mac80211 will create an ibss after 20 seconds probing for existing =
ibss.
> - Wpa_supplicant will restart this timer every 5 second ....
>=20
> Changing the wpa timer will make the rt61 start sending beacons even =
if no
> other STA is available.
>=20
> I think that wpa_supplicant 0.5.10 addresses this issue, I will check=
 and
> come back.

If fixed your issues about a month or two ago.  Either use
wpa_supplicant 0.6.4 and a 2.6.26 kernel, or else grab the following
patches and apply locally:

wpa_supplicant (committed to 0.6.x):
[PATCH] wpa_supplicant: give adhoc associations a bit more time
=EF=BB=BF[PATCH v2] wext: handle mode switches correctly for mac80211

kernel (SHA1s from wireless-testing.git, both in 2.6.26):
872ba53395b2a8be08c3ea2d39e225e5b4a8cb40 mac80211: decrease IBSS creati=
on latency
507b06d0622480f8026d49a94f86068bb0fd6ed6 mac80211: send association eve=
nt on IBSS create

You'd need to backport the wpa_supplicant patches to 0.5.x, or else pok=
e
Jouni and maybe he'll backport them for you.  I do want to get them int=
o
0.5.x as well.

Dan


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
