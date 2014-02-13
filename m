Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:58719 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaBMU1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 15:27:38 -0500
Date: Fri, 14 Feb 2014 07:27:16 +1100
From: James Cameron <quozl@laptop.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: libertas: probe responses with zero length SSID cause scan
 result loss
Message-ID: <20140213202715.GB2793@us.netrek.org> (sfid-20140213_214141_263214_9E698D0A)
References: <20140211063329.GO5487@us.netrek.org>
 <1392310868.18472.11.camel@dcbw.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392310868.18472.11.camel@dcbw.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 13, 2014 at 11:01:08AM -0600, Dan Williams wrote:
> On Tue, 2014-02-11 at 17:33 +1100, James Cameron wrote:
> > G'day,
> > 
> > I'd appreciate a sanity check, as I'm not sure what I am doing.
> > 
> > We saw for years that scan results for an OLPC XO-1 laptop would be
> > unreliable in large groups.  APs would not be easily found.  We
> > presumed other causes until recently.
> > 
> > Using monitor mode on another computer, and "iwlist eth0 scan" on the
> > XO-1, I found probe responses from an AP, and ACKs from the host to
> > the AP, but the output omitted the AP.
> > 
> > Further, the AP would be missing if there was a probe response from
> > another XO-1 running mesh, and an ACK from the host to that XO-1.
> > 
> > Enabling debugging, lbs_ret_scan was reporting "scan response: invalid
> > IE fmt" because the probe response had a zero length SSID IE.
> > 
> > Is a zero length SSID IE valid?  (We can't change the wireless firmware
> > at this stage.)
> 
> I think technically a zero-length IE would be valid, but I'm not sure
> about a zero-length *SSID* IE.  Is that zero length SSID IE coming from
> an AP, or from an XO?

Both.

There's one for every XO-1 in the room seen on monitor, but only the
usb8388 device passes it up to the host.  The sd8686 device does
not.

len = 38 00                         // start of a bss in scan response
bssid = 00 00 00 00 00 00
rssi = 00
tsf = 07 e6 7c 68 77 00 00 00
intvl = 90 01                       // 409.6ms beacon interval
capa = 00 00
ie = 00 00                          // SSID (zero length)
ie = 01 04 82 84 8b 96              // supported rates
ie = 03 01 01                       // channel
ie = 32 08 0c 12 18 24 30 48 60 6c
ie = dd 0e 00 50 43 04 00 00 00 00 00 04 6d 65 73 68

There's one for some of the hidden APs.  Both devices pass it up to
the host.  For example:

len = 6b 00                         // start of a bss in scan resp
bssid = 2e b0 5d a6 86 ec
rssi = 1e
tsf = 80 a3 0b 41 05 00 00 00
intvl = 64 00
capa = 11 04
ie = 00 00                          // SSID (zero length)
ie = 01 08 82 84 8b 96 0c 12 18 24  // supported rates
ie = 03 01 06                       // channel
ie = 05 04 00 02 00 00
ie = 07 06 41 55 20 01 0b 14        // country
...

In both monitor mode and scan results, some hidden APs respond to a
probe with a zero-length SSID IE, and some do not.  Whether they do or
not seems to be a characteristic of the AP firmware.

> If the scan was a passive scan, then a zero-length SSID IE *would*
> be valid, since the passive scans usually just listen for beacons,
> and hidden APs wouldn't report a real SSID.  So perhaps what's
> happening here is if there is a hidden AP, the firmware sometimes
> gets the beacon from the AP before the AP responds to the XO's probe
> request?

I don't think so.

I have infrequently seen beacons on monitor in the time between the
probe request for the first channel, and the probe request for the
second channel, but these don't end up in the scan results.  Only the
probe responses that the device ACKed end up in the scan results.

The tests I've made with kernel are only active scans.

Tests made with Open Firmware included both active and passive, and
passive scans also included the mesh and hidden APs if a beacon was
seen in the scan period.

> In any case, I think the patch is OK.

Thanks.  I shall resubmit with signoff.

-- 
James Cameron
http://quozl.linux.org.au/
