Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout1-sn2.hy.skanova.net ([81.228.8.83]:50374 "EHLO
	pne-smtpout1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195AbYHQOCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 10:02:03 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Ivo van Doorn'" <ivdoorn@gmail.com>
Cc: <rt2400-devel@lists.sourceforge.net>,
	<linux-wireless@vger.kernel.org>, <hostap@lists.shmoo.com>
Subject: RE: [Rt2400-devel] mac80211 / rt2x00 / rt61 and adhoc status
Date: Sun, 17 Aug 2008 16:02:08 +0200
Message-ID: <059401c90071$d71609e0$0b3ca8c0@gotws1589> (sfid-20080817_160220_073906_5AA43DEB)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <200808171158.25501.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Sunday 17 August 2008, Lars Ericsson wrote:
> > > > 
> > > > Have tried using the wpa_supplicant and got the -EBUSY from
> > > > ieee80211_ioctl_siwmode().
> > > 
> > > As usual: The interface must be down when changing working mode.
> > > 

OK, I found the problem.
When the wpa_supplicant start it open the interface with mode=0.
wpa_driver_wext_set_mode() makes iwr.u.mode = mode ? IW_MODE_ADHOC :
IW_MODE_INFRA

When the mode, at a later time, is actually set with wpa_cli, the device is
open and will reject the setting.
This must be a BUG in the wpa_supplicant.

> > > > Two tests cases, but same behaviour:
> > > > 1) Linx.git: 2.6.26 and wpa_supplicant 0.5.9
> > > > 2) rt2x00.git: Version 2.2.0 and wpa_supplicant 0.5.9
> > > 
> > > Are any beacons going out? Is there anything in the logs which
> > > indicates what is happening?
> > > 
> > 
> > As you can se in the trace below, the configuration 
> proceeds and the adhoc
> > is created.
> > The warnon might give some clues.
> 
> So how about those beacons? are they getting out?
> 

After patching the wpa_suplicant (0.5.9) adhoc works.
When first started, as the only part in the adhoc net, the driver just scans
around for other adhoc members.
This happen in mac80211 state 4 and no beacons are sent, as far as I can
tell. Only probe requests are sent.

When an other node (N2) shows up in the same adhoc net work, N2 starts
sending beacons immediately.
The RT61 catch that and merge that ibss, switch to state 5 and all is fine.
At this time ping works in both directions.

When removing the second note, leaving the RT61 alone, RT61 starts sending
beacons, still in state 5.


/Lars

