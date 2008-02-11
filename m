Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:41220 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbYBKFFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 00:05:48 -0500
Subject: Re: [PATCH 00/12] at76_usb mac80211 port
From: Pavel Roskin <proski@gnu.org>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080210145733.17592.61729.stgit@tikku>
References: <20080210145733.17592.61729.stgit@tikku>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 00:05:45 -0500
Message-Id: <1202706345.20836.26.camel@dv> (sfid-20080211_050554_119064_4EAAD3C6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-02-10 at 16:59 +0200, Kalle Valo wrote:
> Here's a patch series of my at76_usb mac80211 port. I'm sending them now 
> for comments. Currently open mode and WEP authentication are supported.

Kalle, thank you for your work!

I've put your patches on http://git.80211libre.org/at76_usb.git so that
they can be tested by more users.  I gave no promise about continuity of
the branch, so I'm ready to replace the patches.

I haven't looked at the code yet, but here are some testing results.

When trying to associate to an AP without security (MadWifi on a PC),
that's what I see in the logs:

wlan3: Initial auth_alg=0
wlan3: authenticate with AP 00:0b:6b:56:01:bf
wlan3: authenticate with AP 00:0b:6b:56:01:bf
wlan3: RX authentication from 00:0b:6b:56:01:bf (alg=0 transaction=2 status=0)
wlan3: authenticated
wlan3: associate with AP 00:0b:6b:56:01:bf
wlan3: authentication frame received from 00:0b:6b:56:01:bf, but not in authenticate state - ignored
wlan3: associate with AP 00:0b:6b:56:01:bf
wlan3: RX AssocResp from 00:0b:6b:56:01:bf (capab=0x421 status=0 aid=1)
wlan3: associated
wlan3: association frame received from 00:0b:6b:56:01:bf, but not in associate state - ignored

No pings come through.  I see on the AP that the AP is receiving ARP
requests and sending ARP replies, so it must be the receiving side in
at76_usb that is broken.

When trying to connect to the same AP with a WEP key, this appears in
the kernel log:

phy5: CMD_JOIN failed: 7<7>wlan3: CTS protection enabled
(BSSID=00:0b:6b:56:01:bf)
wlan3: CTS protection disabled (BSSID=00:0b:6b:56:01:bf)

You forgot end of line in the message (that's patch 05/12).  I'm totally
at loss why a positive value us printed.  When trying to set the key and
ESSID again, I get this:

wlan3: Initial auth_alg=0
wlan3: authenticate with AP 00:0b:6b:56:01:bf
wlan3: authenticate with AP 00:0b:6b:56:01:bf
wlan3: authenticate with AP 00:0b:6b:56:01:bf
wlan3: authentication with AP 00:0b:6b:56:01:bf timed out

Pings don't come through.  Everything is within one room.  Attenuation
shouldn't be an issue.

Another interesting problem - scan results show the channel two times
(not counting the "frequency" line).  Other mac80211 drivers do it once.
No idea why.

wlan3     Scan completed :
          Cell 01 - Address: 00:0B:6B:56:01:BF
                    ESSID:"Moody"
                    Mode:Master
                    Frequency:2.462 GHz (Channel 11)
                    Channel:11
                    Channel:11
                    Encryption key:on
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s
                    Extra:tsf=00000000159e489e

-- 
Regards,
Pavel Roskin
