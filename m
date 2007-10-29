Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:44269 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbXJ2Hv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 03:51:26 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1ImPPB-0000Nt-Ei
	for linux-wireless@vger.kernel.org; Mon, 29 Oct 2007 03:51:25 -0400
Subject: Re: iwl3945 lists supported rates backwards
From: Pavel Roskin <proski@gnu.org>
To: dragoran <drago01@gmail.com>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <4719BA96.3010609@gmail.com>
References: <1192832109.19766.14.camel@dv> <47192F84.1020101@lwfinger.net>
	 <20071020014040.40pq9hqkw0c4owc8@webmail.spamcop.net>
	 <4719BA96.3010609@gmail.com>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 03:51:21 -0400
Message-Id: <1193644281.27622.12.camel@dv> (sfid-20071029_075130_793419_DFA19205)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-10-20 at 10:21 +0200, dragoran wrote:

> > I don't know why iwl3945 composes the association request on its own 
> > and what happens to it later.  Besides, mac80211 10.0.0 is something 
> > heavily patched by Intel AFAIK.  I wanted to test the git version of 
> > Intel mac80211, but intellinuxwireless.org appears to be down or 
> > unreachable at the moment and I didn't have a recent clone.  The 
> > kernel mac80211 is definitely not the suspect.
> >
> > I was aware of "error 18", and when I noticed some activity about 
> > rates in wireless-2.6/everything, so I decided to see how that problem 
> > would be affected.
> >
> does loading the module with disable_hw_scan=1 helps?

Sorry for delay.  disable_hw_scan=1 makes no difference for association
requests.  However, it has the opposite effect on the probe requests.
With disable_hw_scan=1, probe requests have the same problem as the
association requests, namely they don't have CCK rates in the supported
rates:

IEEE 802.11
    Type/Subtype: Probe Request (0x04)
    Frame Control: 0x0040 (Normal)
        Version: 0
        Type: Management frame (0)
        Subtype: 4
        Flags: 0x0
            DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 0
    Destination address: Broadcast (ff:ff:ff:ff:ff:ff)
    Source address: IntelCor_c8:77:a3 (00:13:02:c8:77:a3)
    BSS Id: Broadcast (ff:ff:ff:ff:ff:ff)
    Fragment number: 0
    Sequence number: 5
    Frame check sequence: 0x53ed0507 [correct]
        [Good: True]
        [Bad: False]
IEEE 802.11 wireless LAN management frame
    Tagged parameters (23 bytes)
        SSID parameter set: "WTEST"
            Tag Number: 0 (SSID parameter set)
            Tag length: 5
            Tag interpretation: WTEST
        Supported Rates: 6.0 9.0 12.0 18.0 24.0 36.0 48.0 54.0 
            Tag Number: 1 (Supported Rates)
            Tag length: 8
            Tag interpretation: Supported rates: 6.0 9.0 12.0 18.0 24.0 36.0 48.0 54.0  [Mbit/sec]
        Extended Supported Rates: 1.0 2.0 5.5 11.0 
            Tag Number: 50 (Extended Supported Rates)
            Tag length: 4
            Tag interpretation: Supported rates: 1.0 2.0 5.5 11.0  [Mbit/sec]

What's even worse, the radiotap header (I'm capturing with the current
MadWifi) indicates that the probe request is sent at 6 Mbps.  Of course,
the AP doesn't reply, as it's 802.11b only.

Association requests are sent at 5.5 and 6 Mbps.  The association
response is sent, but it's still code 18.

I'm using current wireless-2.6/everything now (it identifies itself as
2.6.24-rc1) and the driver from the kernel to avoid any problems with
Intel's mac80211.

-- 
Regards,
Pavel Roskin

