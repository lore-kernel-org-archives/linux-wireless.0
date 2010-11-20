Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:57811 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752413Ab0KTL16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 06:27:58 -0500
Date: Sat, 20 Nov 2010 13:27:53 +0200
From: Jouni Malinen <j@w1.fi>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Linux Client vs. CISCO AP with band select
Message-ID: <20101120112753.GA12225@jm.kir.nu>
References: <4CE6EA98.3020300@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CE6EA98.3020300@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 19, 2010 at 10:22:32PM +0100, Wolfgang Breyha wrote:
> AFAIK "band select" tries to "convince" a client to prefer 5GHz channels
> by not answering to 2.4GHz probes at least two times (configurable with
> 2 as default) the same client asks. But the AP appears in scans since
> beacons are received as usual.

Huh.. This makes the AP completely non-compliant with IEEE Std
802.11-2007 and such madness should not really be encouraged in any way
or form. Please just disable it and request Cisco to provide a sane
solution that allows the stations to opt-in to whatever games the AP
want to play and not some non-standard hacks. If the AP wants to suggest
the station to move to another band, there better be documented,
publicly available specification describing a clear message that
stations can use as a clear input to BSS selection. Arbitrarily breaking
required standard functionality is not such a mechanism.

> In my case I see 10 BSSIDs for this SSID. 2 strong 2.4GHz APs and the
> first 5GHz AP appears on third position reception wise. wpa_supplicant
> starts authentication at the strongest. Then I see a probe request for
> the SSID in wireshark, but no response from the selected BSSID. No
> authentication packet is seen from wireshark.

OK, this is all expected thanks to the silly AP design.

> Authentication times out. And then the worst case scenario takes
> place... wpa_supplicant retries and retries the same AP with time outs
> and scans in between. Sometimes even 180 seconds is not enough to try an
> other AP.

This is not.. wpa_supplicant should use blacklist to block the BSSID
temporarily and try to find another BSS at that point.

> I can provide sample wpa_supplicant.log and wireshark traces if of interest.

Could you please send me those? Ideally, I would like to see
wpa_supplicant debug log with -ddt on the command line (i.e., timestamps
and verbose debugging) with -Dnl80211 and preferably, without using
NetworkManager to control it to avoid any extra timeouts etc. making the
log more confusing to interpret.

> Last but not least I tried with Windows. Windows is able to connected
> even to the 2.4GHz channels. I've monitored the channel with my linux
> machine while windows connected to the 2.4GHz AP. All I see are
> unanswered probes also, but Windows seems to simply send an
> authentication request afterwards and gets an answer then.

This is all driver/802.11 specific and it is not really same for all
Windows drivers or all Linux drivers. The AP is behaving incorrectly and
the station behavior in such a case is undefined..

> I can't figure out how CISCO hopes that a client behaves to cooperate
> well with this feature.

Neither can I.. Unfortunately, some enterprise AP vendors seem to be
coming up with load balancing designs that are based on some proprietary
hacks and hope that all stations behave in a specific way. There is no
sane way of implementing these things properly without depending on some
common standard that both the APs and stations can use to exchange
information about preferred BSS candidates. IEEE 802.11 was designed to
keep the station, not the AP, in control of roaming; that cannot be
changed unilaterally at the AP without breaking things badly.

-- 
Jouni Malinen                                            PGP id EFC895FA
