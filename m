Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44342 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbZBIW2e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 17:28:34 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 14:28:34 -0800
Date: Mon, 9 Feb 2009 14:27:50 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Richard Farina <sidhayn@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
Subject: Re: [PATCH v6] mac80211: do not TX injected frames when not allowed
Message-ID: <20090209222750.GA31202@tesla> (sfid-20090209_232837_975711_66EC6D43)
References: <1233335309-28099-1-git-send-email-lrodriguez@atheros.com> <1233347900.4070.4.camel@johannes.local> <499055E5.6070701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <499055E5.6070701@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 09, 2009 at 08:12:21AM -0800, Richard Farina wrote:
> Johannes Berg wrote:
> > On Fri, 2009-01-30 at 09:08 -0800, Luis R. Rodriguez wrote:
> >
> >> Monitor mode is able to TX by using injected frames. We should
> >> not allow injected frames to be sent unless allowed by regulatory
> >> rules. Since AP mode uses a monitor interfaces to transmit
> >> management frames we have to take care to not break AP mode as
> >> well while resolving this. We can deal with this by allowing compliant
> >> APs solutions to inform mac80211 if their monitor interface is
> >> intended to be used for an AP by setting a cfg80211 flag for the
> >> monitor interface. hostapd, for example, currently does its own
> >> checks to ensure AP mode is not used on channels which require radar
> >> detection. Once such solutions are available it can can add this
> >> flag for monitor interfaces.
> >>
> >> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> >> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> >>
> Tested-by: Rick Farina <sidhayn@gmail.com>
> Nacked-by: Rick Farina <sidhayn@gmail.com>
> 
> Luis, when I requested this from you and you cranked out a patch in 30
> seconds what you gave me worked great, unfortunately this patch doesn't
> perform the intended function for me.  If I use this patch and mark,
> say, everything as "PASSIVE-SCAN NO-IBSS" I can still send raw packets
> out of my interface

Can you provide the output of 'iw list'? What channel are you tuning
your monitor interface to? Also can you elaborate on how you are testing
transmitting over an injected monitor interface exactly?

For example I just tested with two wireless cards, an ath9k and an iwlagn
in two separate frequencies, 2412 and 5320 provided iw list lists on both
interfaces:

* 2412 MHz [1] (14.0 dBm)
* 5320 MHz [64] (15.0 dBm) (passive scanning, no IBSS, radar detection)

I use this script to create the monitor interfaces:

---
#!/bin/bash
FREQ="2412"
#FREQ="5320"

# Create the monitor interfaces
sudo iw phy phy0 interface add mon-ath9k type monitor
sudo iw phy phy1 interface add mon-iwlagn type monitor

# Bring the interfaces up
sudo ip link set mon-ath9k up
sudo ip link set mon-iwlagn up

# Tunes to desired freq
sudo iw dev mon-ath9k set freq $FREQ
sudo iw dev mon-iwlagn set freq $FREQ
---

Then on two separate screens I compiled and ran packetspammer [1] from
Andy Green. Which BTW andy can you post the link the actual git tree? I had
to download each blob to download this, and couldn't find the git URL heh,
will like to update the URL on Documentation/networking/mac80211-injection.txt.

[1] http://git.warmcat.com/cgi-bin/cgit.cgi?url=packetspammer.git/

On ath9k on freq 2412:
-------------------------------------------------------------------------------
mcgrof@mosca ~/devel/packetspammer $ sudo ./packetspammer mon-ath9k
Packetspammer (c)2007 Andy Green <andy@warmcat.com>  GPL2
DLT_IEEE802_11_RADIO Encap
RX Filter applied
   (delay between packets 100000us)  
rtap: 0000: 00 00 0D 00 04 80 02 00 02 00 00 00 03           .............
RX: Rate:  1.0Mbps, Freq: 0.0GHz, Ant: 0, Flags: 0x0
0000: 50 61 63 6B 65 74 73 70 61 6D 6D 65 72 20 35 34  Packetspammer 54
0010: 62 72 6F 61 64 63 61 73 74 20 70 61 63 6B 65 74  broadcast packet
0020: 23 30 30 30 30 30 20 2D 2D 20 3A 2D 44 20 2D 2D  #00000 -- :-D --
0030: 6D 6F 73 63 61 20 2D 2D 2D 2D                    mosca ----
rtap: 0000: 00 00 0D 00 04 80 02 00 02 00 00 00 03           .............
RX: Rate:  1.0Mbps, Freq: 0.0GHz, Ant: 0, Flags: 0x0
0000: 50 61 63 6B 65 74 73 70 61 6D 6D 65 72 20 34 38  Packetspammer 48
0010: 62 72 6F 61 64 63 61 73 74 20 70 61 63 6B 65 74  broadcast packet
0020: 23 30 30 30 30 31 20 2D 2D 20 3A 2D 44 20 2D 2D  #00001 -- :-D --
0030: 6D 6F 73 63 61 20 2D 2D 2D 2D                    mosca ----
rtap: 0000: 00 00 0D 00 04 80 02 00 02 00 00 00 03           .............
RX: Rate:  1.0Mbps, Freq: 0.0GHz, Ant: 0, Flags: 0x0
0000: 50 61 63 6B 65 74 73 70 61 6D 6D 65 72 20 33 36  Packetspammer 36
0010: 62 72 6F 61 64 63 61 73 74 20 70 61 63 6B 65 74  broadcast packet
0020: 23 30 30 30 30 32 20 2D 2D 20 3A 2D 44 20 2D 2D  #00002 -- :-D --
0030: 6D 6F 73 63 61 20 2D 2D 2D 2D                    mosca ----

-------------------------------------------------------------------------------

On iwlagn it similar so won't bother posting it. If I try to use freq 5320 on either
I get

-------------------------------------------------------------------------------
mcgrof@mosca ~/devel/packetspammer $ sudo ./packetspammer mon-ath9k
Packetspammer (c)2007 Andy Green <andy@warmcat.com>  GPL2
DLT_IEEE802_11_RADIO Encap
RX Filter applied
   (delay between packets 100000us)
-------------------------------------------------------------------------------

And it sits there without doing anything.

  Luis
