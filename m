Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbXJSGim (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 02:38:42 -0400
Subject: Re: realtek 8185
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Wade Berrier <wberrier@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071018174108.GC8510@tuxdriver.com>
References: <bbbeeccd0710160658p7f127bb9if2239287bee33d6c@mail.gmail.com>
	 <bbbeeccd0710162220u3b276506s68457b4220bec8ae@mail.gmail.com>
	 <bbbeeccd0710171552x37986f68m906a603e793c7996@mail.gmail.com>
	 <200710171938.48414.flamingice@sourmilk.net>
	 <bbbeeccd0710181013g6607423bobb31ca1e817f33c5@mail.gmail.com>
	 <20071018174108.GC8510@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 02:38:09 -0400
Message-Id: <1192775889.14897.29.camel@localhost.localdomain> (sfid-20071019_073852_159672_08DE3D9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-10-18 at 13:41 -0400, John W. Linville wrote:
> On Thu, Oct 18, 2007 at 11:13:00AM -0600, Wade Berrier wrote:
> > On 10/17/07, Michael Wu <flamingice@sourmilk.net> wrote:
> > > On Wednesday 17 October 2007 18:52:28 Wade Berrier wrote:
> > > > Another thing I'm noticing is that I can't connect to an 802.11b open
> > > > network with a hidden essid.
> > > >
> > > For those, you should specify the channel, and bssid in one iwconfig command,
> > > and then ssid in another command. Everything needs to be specified for hidden
> > > networks. Never tried connecting to hidden networks with network manager so I
> > > dunno if that's suppose to work.
> > 
> > I've been able to connect to this hidden network via network manager.
> > >From a users experience, I enter in the essid from the "Connect to
> > other wireless network" dialog, and it connects.  I'm not sure how
> > networkmanager makes the connection between the essid and the ap.
> 
> If anything, I usually find that I can connect to the hidden networks
> using iwconfig but _not_ with NetworkManager.  FWIW, mac80211 will
> send probe requests for unknown SSIDs when trying to associate.

NM always uses wpa_supplicant for connections, so whatever
wpa_supplicant is (not) doing is probably the culprit here.
wpa_supplicant does use IW_SCAN_THIS_ESSID, but only a few drivers
implement that.  I was also not able to consistently connect to a
non-broadcasting AP with plain wpa_supplicant and an ipw2200 (which
AFAIK does support IW_SCAN_THIS_ESSID).

What _should_ be happening here is that, if the SSID doesn't show up in
the scan list that wpa_supplicant has, it will ask the driver to scan
with the specific SSID it wants to connect to using IW_SCAN_THIS_ESSID.
The driver should then send out active probe requests on all channels
for that SSID.  If it gets a result it should notify userspace via
SIOCGIWSCAN events, but with only _one_ event after the entire scan is
complete.  If the SSID was found, wpa_supplicant will get the new scan
result and connect to the previously hidden SSID that is now known to
the driver.

FWIW, Bill Moss reports that disabling hardware scan on iwl3945 (with
the module parameter) lets NM connect to hidden networks with high
success.

Dan

> Unfortunately, I'm not really sure how this relates to the problem
> you are having.  Perhaps probe responses are being lost somehow?
> 
> John

