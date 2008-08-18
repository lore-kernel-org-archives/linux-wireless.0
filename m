Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760372AbYHRTeT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 15:34:19 -0400
Subject: RE: [Rt2400-devel] mac80211 / rt2x00 / rt61 and adhoc status
From: Dan Williams <dcbw@redhat.com>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: "'Jouni Malinen'" <j@w1.fi>, "'Ivo van Doorn'" <ivdoorn@gmail.com>,
	hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <000001c90168$703248e0$0b3ca8c0@gotws1589>
References: <000001c90168$703248e0$0b3ca8c0@gotws1589>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 15:35:36 -0400
Message-Id: <1219088136.2154.11.camel@localhost.localdomain> (sfid-20080818_213435_451753_C387700D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-08-18 at 21:27 +0200, Lars Ericsson wrote:
> > -----Original Message-----
> > From: Dan Williams [mailto:dcbw@redhat.com] 
> > Sent: den 18 augusti 2008 16:34
> > To: Lars Ericsson
> > Cc: 'Ivo van Doorn'; hostap@lists.shmoo.com; 
> > linux-wireless@vger.kernel.org; rt2400-devel@lists.sourceforge.net
> > Subject: RE: [Rt2400-devel] mac80211 / rt2x00 / rt61 and adhoc status
> > 
> > On Sun, 2008-08-17 at 22:42 +0200, Lars Ericsson wrote:
> > > > > > > > Two tests cases, but same behaviour:
> > > > > > > > 1) Linx.git: 2.6.26 and wpa_supplicant 0.5.9
> > > > > > > > 2) rt2x00.git: Version 2.2.0 and wpa_supplicant 0.5.9
> > > > > > > 
> > > > > > > Are any beacons going out? Is there anything in the 
> > logs which
> > > > > > > indicates what is happening?
> > > > > > > 
> > > > > > 
> > > > > > As you can se in the trace below, the configuration 
> > > > > proceeds and the adhoc
> > > > > > is created.
> > > > > > The warnon might give some clues.
> > > > > 
> > > > > So how about those beacons? are they getting out?
> > > > > 
> > > > 
> > > > After patching the wpa_suplicant (0.5.9) adhoc works.
> > > > When first started, as the only part in the adhoc net, the 
> > > > driver just scans
> > > > around for other adhoc members.
> > > > This happen in mac80211 state 4 and no beacons are sent, as 
> > > > far as I can
> > > > tell. Only probe requests are sent.
> > > > 
> > > > When an other node (N2) shows up in the same adhoc net 
> > work, N2 starts
> > > > sending beacons immediately.
> > > > The RT61 catch that and merge that ibss, switch to state 5 
> > > > and all is fine.
> > > > At this time ping works in both directions.
> > > > 
> > > > When removing the second note, leaving the RT61 alone, RT61 
> > > > starts sending
> > > > beacons, still in state 5.
> > > 
> > > The reason for the above behaviour are timeouts.
> > > - Mac80211 will create an ibss after 20 seconds probing for 
> > existing ibss.
> > > - Wpa_supplicant will restart this timer every 5 second ....
> > > 
> > > Changing the wpa timer will make the rt61 start sending 
> > beacons even if no
> > > other STA is available.
> > > 
> > > I think that wpa_supplicant 0.5.10 addresses this issue, I 
> > will check and
> > > come back.
> > 
> > If fixed your issues about a month or two ago.  Either use
> > wpa_supplicant 0.6.4 and a 2.6.26 kernel, or else grab the following
> > patches and apply locally:
> > 
> > wpa_supplicant (committed to 0.6.x):
> > [PATCH] wpa_supplicant: give adhoc associations a bit more time
> > ?[PATCH v2] wext: handle mode switches correctly for mac80211
> > 
> > kernel (SHA1s from wireless-testing.git, both in 2.6.26):
> > 872ba53395b2a8be08c3ea2d39e225e5b4a8cb40 mac80211: decrease 
> > IBSS creation latency
> > 507b06d0622480f8026d49a94f86068bb0fd6ed6 mac80211: send 
> > association event on IBSS create
> > 
> > You'd need to backport the wpa_supplicant patches to 0.5.x, 
> > or else poke
> > Jouni and maybe he'll backport them for you.  I do want to 
> > get them into
> > 0.5.x as well.
> > 
> 
> OK, thanks for the commits and prompt reply.
> I did poke around before I started debugging but did not found any useful
> info.
> Sorry for asking already ready solved questions.
> 
> I have backported the patches to 0.5.9 and they works fine, as far as I can
> tell on 2.6.26.
> I can drop them here if they are of interest. I also vote for putting them
> into 0.5.x 
> 
> Jouni; would that be possible ?

Jouni, if you like I could run through current git HEAD and identify
some easy candidates for backporting to 0.5.x, and send the 0.6 commit
ids to the hostap lists for you along with what needs to be done to
backport the patch.

Dan


