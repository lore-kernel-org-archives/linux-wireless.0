Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:59601 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291AbYHQUmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 16:42:31 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Ivo van Doorn'" <ivdoorn@gmail.com>
Cc: <hostap@lists.shmoo.com>, <linux-wireless@vger.kernel.org>,
	<rt2400-devel@lists.sourceforge.net>
Subject: RE: [Rt2400-devel] mac80211 / rt2x00 / rt61 and adhoc status
Date: Sun, 17 Aug 2008 22:42:38 +0200
Message-ID: <059801c900a9$c9eee740$0b3ca8c0@gotws1589> (sfid-20080817_224243_525733_146D8914)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <059401c90071$d71609e0$0b3ca8c0@gotws1589>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > > > Two tests cases, but same behaviour:
> > > > > 1) Linx.git: 2.6.26 and wpa_supplicant 0.5.9
> > > > > 2) rt2x00.git: Version 2.2.0 and wpa_supplicant 0.5.9
> > > > 
> > > > Are any beacons going out? Is there anything in the logs which
> > > > indicates what is happening?
> > > > 
> > > 
> > > As you can se in the trace below, the configuration 
> > proceeds and the adhoc
> > > is created.
> > > The warnon might give some clues.
> > 
> > So how about those beacons? are they getting out?
> > 
> 
> After patching the wpa_suplicant (0.5.9) adhoc works.
> When first started, as the only part in the adhoc net, the 
> driver just scans
> around for other adhoc members.
> This happen in mac80211 state 4 and no beacons are sent, as 
> far as I can
> tell. Only probe requests are sent.
> 
> When an other node (N2) shows up in the same adhoc net work, N2 starts
> sending beacons immediately.
> The RT61 catch that and merge that ibss, switch to state 5 
> and all is fine.
> At this time ping works in both directions.
> 
> When removing the second note, leaving the RT61 alone, RT61 
> starts sending
> beacons, still in state 5.

The reason for the above behaviour are timeouts.
- Mac80211 will create an ibss after 20 seconds probing for existing ibss.
- Wpa_supplicant will restart this timer every 5 second ....

Changing the wpa timer will make the rt61 start sending beacons even if no
other STA is available.

I think that wpa_supplicant 0.5.10 addresses this issue, I will check and
come back.

/Lars

