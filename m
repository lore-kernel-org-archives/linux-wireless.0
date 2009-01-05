Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22121 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbZAESMy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 13:12:54 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2009 10:12:53 -0800
Date: Mon, 5 Jan 2009 10:12:50 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Joseph Cheek <joseph@cheek.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] 2.6.27 with compat-wireless-2008-12-31 stops
	transmitting every 2-3 minutes
Message-ID: <20090105181250.GD6834@tesla> (sfid-20090105_191258_220634_DED5BB45)
References: <495C7640.8060806@cheek.com> <20090105170432.GA6834@tesla> <49624B10.70400@cheek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <49624B10.70400@cheek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 05, 2009 at 10:01:52AM -0800, Joseph Cheek wrote:
> Thanks Luis!  Comments below...
> 
> Luis R. Rodriguez wrote:
> > On Wed, Dec 31, 2008 at 11:52:32PM -0800, Joseph Cheek wrote:
> >
> >> Hi all,
> >>
> >> Happy New Year!  It's about 2:30 AM here and I'm up debugging my shiny
> >> new DWA-552 <AR5416+AR2133> XtremeN Desktop Adapter.  Stock 2.6.28 gave
> >> me the dreaded "No ProbeResp from current AP" in syslog with a
> >> disconnect every few minutes, even after updating
> >> |IEEE80211_MONITORING_INTERVAL to (100 * HZ).  It's highly annoying.
> >>
> >
> > This should be due to the fact that the RX filter disabled beaconing from
> > the current AP and mac80211 expects beacons from the AP. This was fixed
> > in wireless-testing but I do not see this pushed out for 2.6.28.
> >
> > Greg, this was fixed in Linus' tree via ffb826767bffda61426d964a8fc24a216a14b0bd,
> > merged by John on Fri, 21 Nov 2008, the patch is titled:
> > "ath9k: enable RXing of beacons on STA/IBSS". Just in case I've
> > provided the hunk below. Without this patch users will face this disconnect
> > issue on noisy environments where the beacons don't reach mac80211 within
> > a certain time frame dicated by mac80211.
> >
> >
> >> I thought compat-wireless might help.
> >>
> >
> > It should resolve the "No ProbeResp from current AP" in" issue at least.
> >
> 
> I haven't been getting that message in syslog recently (since the 2nd).
> I moved back to 2.6.27 with compat-wireless-12-31 as that seems the most
> stable with the highest speeds.  I also specified the AP on the iwconfig
> command line, thinking that perhaps that would help.
> >> It seems to do a little bit better
> >> but that's subjective.  I still get a disconnect every few minutes.
> >> iwconfig and my DIR-655 show plenty of signal strength but it doesn't
> >> respond to pings and my ssh sessions all get stuck in limbo.
> >>
> >> What can I do to debug this?  This is an old Athlon XP 2000+ box running
> >> Gentoo (if it helps).  I've seen a few other probs on this list recently
> >> but they don't seem similar to mine enough to warrant tacking this msg
> >> on to an existing thread.
> >>
> >
> > That may be due to a separate issue, but to review that we need more information,
> > such as the type of AP you are connecting to, encryption options used, mode
> > of operation (11n, 11b or 11a), your type of environment (noisy or a quiet home).
> > To review this issue you can remove stable@kernel.org from the To or Cc list.
> >
> 
> based on my recent observations, I believe you are correct - this is a
> separate issue.  I no longer get the noProbeResp error but I still get
> transmission problems every 2 minutes or so under heavy loads.  They
> don't result in actual disconnects - ifconfig shows the interface up and
> iwconfig shows it connected to the AP.  So the link is no longer being
> dropped.  But for about 30 seconds, I can neither ping nor ssh in or out
> of that box.  If leave the system up and don't cancel anything, the
> transmission resumes after the 30 seconds and then stalls again after 2
> minutes or so.
> 
> My AP is a D-Link DIR-655 running 1.21 firmware in g/n mode.  No
> encryption is enabled currently (I do have MAC filtering on, but nothing
> else).  The particular box with the problem is downstairs and there is
> some interference between it and AP, although the DIR-655 generally
> shows 60-80% signal and up to 81Mb/s connection speed.  It doesn't
> happen with light traffic, I have to be watching a streaming video or
> scp-ing a file across the network.  Then it is 100% repeatable.
> 
> If I restart the network (/etc/init.d/wlan0 restart) I can get a good
> connection/signal with good traffic without having to wait 30 seconds -
> for two minutes again 8-(.
> 
> This is at home and most of my neighbors have 80211g wireless set up.  I
> generally see at least two other APs from iwlist wlan0 scanning.  I
> haven't pinned either the AP or the NIC to a channel (6 is normal for US
> but they are connecting on 3).  Not sure if that makes a difference.
> 
> My laptop right next to the AP has no problems staying connected and
> transmitting and receiving with stock 2.6.27.  It's running a DWL-652
> (AR5416).
> 
> btw, when i do get good transmission, I only get about 1.25MB/s at the
> most.  I can get that from my old g card 8-(.

Thanks for the details, this seems to be related to noise and therefore
could be due to some issues with how we deal with ANI. We will have to
try to reproduce this ourselves now and try to fix it.

> I can try anything you need me to with respect to ath9k drivers or
> kernels.  does it matter if bluetooth and/or ipv6 is enabled?  both are
> enabled on this box but not on my laptop?

Anything communication on the same spectrum affects your 802.11 connection,
so using the microwave oven, using bluetooth, or a 2.4 GHz home phone should
affet your connection. Not sure the freq used by Xbox / PS3 controllers...
Bluetooth particularly should affect your 802.11 connection and we only recently
added bluetooth coexistance to help with this but this is only available for
more modern cards so your card does not have this feature.

If you are using bluetooth then it should affect your connection if using the
2.4 GHz spectrum on your wirless AP.

  Luis
