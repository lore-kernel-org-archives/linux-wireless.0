Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:48775 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbYHRUhB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 16:37:01 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Dan Williams'" <dcbw@redhat.com>, "'Jouni Malinen'" <j@w1.fi>
Cc: "'Ivo van Doorn'" <ivdoorn@gmail.com>, <hostap@lists.shmoo.com>,
	<linux-wireless@vger.kernel.org>,
	<rt2400-devel@lists.sourceforge.net>
Subject: RE: [Rt2400-devel] mac80211 / rt2x00 / rt61 and adhoc status
Date: Mon, 18 Aug 2008 21:27:21 +0200
Message-ID: <000001c90168$703248e0$0b3ca8c0@gotws1589> (sfid-20080818_223707_671008_A06BB2F2)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <1219070048.5013.40.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Dan Williams [mailto:dcbw@redhat.com] 
> Sent: den 18 augusti 2008 16:34
> To: Lars Ericsson
> Cc: 'Ivo van Doorn'; hostap@lists.shmoo.com; 
> linux-wireless@vger.kernel.org; rt2400-devel@lists.sourceforge.net
> Subject: RE: [Rt2400-devel] mac80211 / rt2x00 / rt61 and adhoc status
> 
> On Sun, 2008-08-17 at 22:42 +0200, Lars Ericsson wrote:
> > > > > > > Two tests cases, but same behaviour:
> > > > > > > 1) Linx.git: 2.6.26 and wpa_supplicant 0.5.9
> > > > > > > 2) rt2x00.git: Version 2.2.0 and wpa_supplicant 0.5.9
> > > > > > 
> > > > > > Are any beacons going out? Is there anything in the 
> logs which
> > > > > > indicates what is happening?
> > > > > > 
> > > > > 
> > > > > As you can se in the trace below, the configuration 
> > > > proceeds and the adhoc
> > > > > is created.
> > > > > The warnon might give some clues.
> > > > 
> > > > So how about those beacons? are they getting out?
> > > > 
> > > 
> > > After patching the wpa_suplicant (0.5.9) adhoc works.
> > > When first started, as the only part in the adhoc net, the 
> > > driver just scans
> > > around for other adhoc members.
> > > This happen in mac80211 state 4 and no beacons are sent, as 
> > > far as I can
> > > tell. Only probe requests are sent.
> > > 
> > > When an other node (N2) shows up in the same adhoc net 
> work, N2 starts
> > > sending beacons immediately.
> > > The RT61 catch that and merge that ibss, switch to state 5 
> > > and all is fine.
> > > At this time ping works in both directions.
> > > 
> > > When removing the second note, leaving the RT61 alone, RT61 
> > > starts sending
> > > beacons, still in state 5.
> > 
> > The reason for the above behaviour are timeouts.
> > - Mac80211 will create an ibss after 20 seconds probing for 
> existing ibss.
> > - Wpa_supplicant will restart this timer every 5 second ....
> > 
> > Changing the wpa timer will make the rt61 start sending 
> beacons even if no
> > other STA is available.
> > 
> > I think that wpa_supplicant 0.5.10 addresses this issue, I 
> will check and
> > come back.
> 
> If fixed your issues about a month or two ago.  Either use
> wpa_supplicant 0.6.4 and a 2.6.26 kernel, or else grab the following
> patches and apply locally:
> 
> wpa_supplicant (committed to 0.6.x):
> [PATCH] wpa_supplicant: give adhoc associations a bit more time
> ?[PATCH v2] wext: handle mode switches correctly for mac80211
> 
> kernel (SHA1s from wireless-testing.git, both in 2.6.26):
> 872ba53395b2a8be08c3ea2d39e225e5b4a8cb40 mac80211: decrease 
> IBSS creation latency
> 507b06d0622480f8026d49a94f86068bb0fd6ed6 mac80211: send 
> association event on IBSS create
> 
> You'd need to backport the wpa_supplicant patches to 0.5.x, 
> or else poke
> Jouni and maybe he'll backport them for you.  I do want to 
> get them into
> 0.5.x as well.
> 

OK, thanks for the commits and prompt reply.
I did poke around before I started debugging but did not found any useful
info.
Sorry for asking already ready solved questions.

I have backported the patches to 0.5.9 and they works fine, as far as I can
tell on 2.6.26.
I can drop them here if they are of interest. I also vote for putting them
into 0.5.x 

Jouni; would that be possible ?

/Lars

