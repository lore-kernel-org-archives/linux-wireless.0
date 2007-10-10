Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbXJJPHL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 11:07:11 -0400
Subject: Re: mac80211/iwlwifi + hidden ssids
From: Dan Williams <dcbw@redhat.com>
To: dragoran <drago01@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <f6ca9fed0710100757gbcd364esdd94f114cfe1019@mail.gmail.com>
References: <470C9F28.1070803@gmail.com>
	 <20071010130653.GB5962@tuxdriver.com>
	 <1192026847.9739.4.camel@localhost.localdomain>
	 <f6ca9fed0710100757gbcd364esdd94f114cfe1019@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 10 Oct 2007 11:07:46 -0400
Message-Id: <1192028866.9739.32.camel@localhost.localdomain> (sfid-20071010_160716_424570_C9F68AD3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-10-10 at 16:57 +0200, dragoran wrote:
> On 10/10/07, Dan Williams <dcbw@redhat.com> wrote:
> >[..]
> > wpa_supplicant's support for hidden SSIDs sort of sucks; mainly because
> > the drivers implement this in different ways.  wpa_supplicant says you
> > must use "ap_scan=2" for hidden SSIDs (and possibly ssid_scan=1 to do
> > specific ssid probe requests), which causes wpa_supplicant to blast all
> > settings to the card directly and not try to be smart about AP scanning
> > and selection.  However, this doesn't work often because drivers are
> > inconsistent about this.
> >
> > The way it _should_ work is that if scan_ssid = 1 for a network,
> > wpa_supplicant should ask that the driver scan the specific ssid using
> > IW_SCAN_THIS_ESSID.  The card would then issue specific SSID scan
> > requests on each channel during the scan, and hopefully find the AP in
> > question.
> >
> > Unfortunately, most drivers don't support IW_SCAN_THIS_ESSID.  So the
> > best we can do is set AP_SCAN=2, let wpa_supplicant blow all the
> > settings to the card, and just _hope_ that the card/driver are smart
> > enough to find the hidden SSID on their own and associate.  Which is
> > less often than we'd hope.
> 
> so your are suggestion to use ap_scan=2 and add scan_ssid=1 to the
> network block?
> nm seems not to do this.

It should be doing this...

> btw shouldn't all mac80211 drivers either work or not work because the
> code for this is in mac80211 and not in the drivers?

Yeah, pretty much; but each driver/firmware may handle hidden ssids
slightly differently.  mac80211 should bring some sanity to this area,
but I wouldn't discount variation between even mac80211 based drivers.

Dan

> I will be able to test again this friday will try this and the
> ap_scan=1 if there are other suggestion feel free to say them so I can
> add them to my "totest" list ;)

