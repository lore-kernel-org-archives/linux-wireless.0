Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbXJJOdk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 10:33:40 -0400
Subject: Re: mac80211/iwlwifi + hidden ssids
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20071010130653.GB5962@tuxdriver.com>
References: <470C9F28.1070803@gmail.com>
	 <20071010130653.GB5962@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 10 Oct 2007 10:34:07 -0400
Message-Id: <1192026847.9739.4.camel@localhost.localdomain> (sfid-20071010_153345_569777_B4036F9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-10-10 at 09:06 -0400, John W. Linville wrote:
> On Wed, Oct 10, 2007 at 11:45:12AM +0200, dragoran wrote:
> > Hello,
> > I am unable to connect to a dynamic wep network with hidden ssid using 
> > iwl3945 and the lastest fedora 7 kernel (which should have very recent 
> > stuff). The problem is that the card never finds the ap. Running 
> > wpa_supplicant directly shows "Got scan results xxx bytes" (can't 
> > remeber the exact message).
> > While with ipw3945d + ieee80211 it works fine. (NetworkManager does not 
> > connect either see http://bugzilla.gnome.org/show_bug.cgi?id=464215 ).
> > I haven't tryed the suggestion there yet because I am not near the 
> > network right now.
> > Any idea whats wrong? Does it work for anybody (maybe with other 
> > mac80211 drivers)
> > Currently I am not sure whom to blame iwl3945 or mac80211 or both.
> 
> Fedora 7 kernels are a little behind (1-2 weeks behind wireless-2.6)
> ATM, so it might be best to handle this at bugzilla.kernel.org.
> 
> F7 _does_ have the kernel patch to probe for hidden SSIDs when
> associating.  What I've found with that patch is that manually
> invoking the wireless tools yields satisfactory results, but that NM
> (which afaik relies on wpa_supplicant) still tends to have problems.
> My hunch is that wpa_supplicant (at least how NM configures it)
> is doing something "too smart", but I really don't know.

wpa_supplicant's support for hidden SSIDs sort of sucks; mainly because
the drivers implement this in different ways.  wpa_supplicant says you
must use "ap_scan=2" for hidden SSIDs (and possibly ssid_scan=1 to do
specific ssid probe requests), which causes wpa_supplicant to blast all
settings to the card directly and not try to be smart about AP scanning
and selection.  However, this doesn't work often because drivers are
inconsistent about this.

The way it _should_ work is that if scan_ssid = 1 for a network,
wpa_supplicant should ask that the driver scan the specific ssid using
IW_SCAN_THIS_ESSID.  The card would then issue specific SSID scan
requests on each channel during the scan, and hopefully find the AP in
question.

Unfortunately, most drivers don't support IW_SCAN_THIS_ESSID.  So the
best we can do is set AP_SCAN=2, let wpa_supplicant blow all the
settings to the card, and just _hope_ that the card/driver are smart
enough to find the hidden SSID on their own and associate.  Which is
less often than we'd hope.

Dan

> Do you have control over the AP?  If so, can you temporarily try
> using static WEP or an open configuration so that you can test using
> iwconfig?
> 
> Thanks,
> 
> John

