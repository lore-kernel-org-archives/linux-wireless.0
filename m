Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:46924 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYLHScq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 13:32:46 -0500
Received: by nf-out-0910.google.com with SMTP id d3so610340nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 10:32:43 -0800 (PST)
To: "Lars Ericsson" <Lars_Ericsson@telia.com>
Subject: Re: Monitor number of packages sent and ACK'ed by AP
Date: Mon, 8 Dec 2008 19:32:40 +0100
Cc: "'Johannes Berg'" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <0161CC9B2A3341A19CED21A365A90FE4@gotws1589>
In-Reply-To: <0161CC9B2A3341A19CED21A365A90FE4@gotws1589>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812081932.40499.IvDoorn@gmail.com> (sfid-20081208_193250_760506_C15E179C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 December 2008, Lars Ericsson wrote:
> > On Monday 08 December 2008, Lars Ericsson wrote:
> > > > 
> > > > On Mon, 2008-12-08 at 11:50 +0100, Lars Ericsson wrote:
> > > > > Hi Johannes,
> > > > > 
> > > > > I would like to monitor number of packages properly 
> > > > transmitted and ACK'ed
> > > > > by the AP.
> > > > > Is the a single point where this can be done ?
> > > > 
> > > > Not really, some drivers don't even give you that information,
> > > > unfortunately.
> > > > 
> > > > johannes
> > > > 
> > > 
> > > OK, thanks. 
> > > I just discovered that Ralink rt61 does filter all ACK frames.
> > > /Lars
> > 
> > Did you look during monitor mode?
> > When monitor mode is not enabled, the RX filter can be quite strict.
> > 
> > Ivo
> > 
> 
> Hi Ivo,
> 
> No, I did not used monitor mode. I do not know how-to do it.

iwconfig wlan0 mode monitor

> I have a problem when the STA picks up AP BEACONS (last_rx updated), 
> but the AP, due to other AP/STA communication, have problems picking up the
> STA traffic.
> 
> One idea was to monitor that I receive ACK frames, i.e. someone receives me.
> But the driver filter all ACK frames.

Right, because mac80211 doesn't send the control filter to the driver by default,
it does when using monitor mode. (Not sure if it also does this when having
a secondary virtual interface running in monitor mode, but for full-monitor
mode it does).

After that all Ralink hardware send the ACK packets to the driver which sends them
to mac80211.

> Is there any other event generated from the driver to the mac layer that 
> can be used indicate bad communication?
>
> For instance large number of retries or low transmition speed.

The retry count is send to mac80211 after the frame was send to the hardware
(or if the hardware has given up on the transmission). The used retry rate is not
reported.
You could also check the 'iwconfig' statistic 'Link Quality' that is  calculated by
the driver and is based on the signal strength of the beacon from the AP, the
TX success count and the RX success count.

> PS:
> You remember the problem we discussed with the PID that did not work, 
> until I not forced HW antenna diversity?

Yes. It contained the recommendation was that you should force a feature on
a device when you don't know if the hardware is capable of that.
(Especially when the hardware explictely indicates that it shouldn't be used). ;)

> I have been monitoring that site for a while and the 2.6.26 driver works
> well.
> The WLAN is very interesting. It is a http://www.merunetworks.com WLAN where
> the STA associates with a virtual AP. The physical AP (radio) varies from
> time to 
> time depending on the STA location. The STA never noticed when the AP 
> is changed since all AP's  uses the same channel and the BSSID is always the
> same.

And how does this relate to the antenna setting?

Ivo
