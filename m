Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.238]:23753 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbXJJO5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 10:57:48 -0400
Received: by nz-out-0506.google.com with SMTP id s18so175919nze
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 07:57:47 -0700 (PDT)
Message-ID: <f6ca9fed0710100757gbcd364esdd94f114cfe1019@mail.gmail.com> (sfid-20071010_155751_463490_3A6EB76A)
Date: Wed, 10 Oct 2007 16:57:46 +0200
From: dragoran <drago01@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: mac80211/iwlwifi + hidden ssids
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1192026847.9739.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <470C9F28.1070803@gmail.com> <20071010130653.GB5962@tuxdriver.com>
	 <1192026847.9739.4.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/10/07, Dan Williams <dcbw@redhat.com> wrote:
>[..]
> wpa_supplicant's support for hidden SSIDs sort of sucks; mainly because
> the drivers implement this in different ways.  wpa_supplicant says you
> must use "ap_scan=2" for hidden SSIDs (and possibly ssid_scan=1 to do
> specific ssid probe requests), which causes wpa_supplicant to blast all
> settings to the card directly and not try to be smart about AP scanning
> and selection.  However, this doesn't work often because drivers are
> inconsistent about this.
>
> The way it _should_ work is that if scan_ssid = 1 for a network,
> wpa_supplicant should ask that the driver scan the specific ssid using
> IW_SCAN_THIS_ESSID.  The card would then issue specific SSID scan
> requests on each channel during the scan, and hopefully find the AP in
> question.
>
> Unfortunately, most drivers don't support IW_SCAN_THIS_ESSID.  So the
> best we can do is set AP_SCAN=2, let wpa_supplicant blow all the
> settings to the card, and just _hope_ that the card/driver are smart
> enough to find the hidden SSID on their own and associate.  Which is
> less often than we'd hope.

so your are suggestion to use ap_scan=2 and add scan_ssid=1 to the
network block?
nm seems not to do this.
btw shouldn't all mac80211 drivers either work or not work because the
code for this is in mac80211 and not in the drivers?

I will be able to test again this friday will try this and the
ap_scan=1 if there are other suggestion feel free to say them so I can
add them to my "totest" list ;)
