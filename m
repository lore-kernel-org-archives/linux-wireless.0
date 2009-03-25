Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41201 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757171AbZCYPhE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 11:37:04 -0400
Subject: Re: Scan in compat-wireless
From: Dan Williams <dcbw@redhat.com>
To: Venkat Ch <venkatch@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <c1e027750903250043n1e6bfffdnd6a6a3889a1f68d6@mail.gmail.com>
References: <c1e027750903250041qfb28bb5g69bc219da57736c0@mail.gmail.com>
	 <c1e027750903250043n1e6bfffdnd6a6a3889a1f68d6@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 11:34:53 -0400
Message-Id: <1237995293.18896.12.camel@localhost.localdomain> (sfid-20090325_163708_346576_BD19C4B1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-03-25 at 13:13 +0530, Venkat Ch wrote:
> Hi All,
> 
>  Last week I have downloaded compat-wireless driver. I have installed
> the same into my laptop which has AR242x based WiFi card. Though the
> drivers are loaded correctly, the STA (my laptop) did not associate
> with the nearby AP. This used to happen well with madwifi driver.
> 
> With my past experience with the details of madwifi driver, I have
> browsed through the code base of compat-wireless driver. I observed
> that with madwifi driver when the device is made up, the scan process
> is kicked off. Where as the same is not happening in compat-wireless.
> Does not the scan process need to be kicked off at the end of
> ieee80211_open (net/mac80211/iface.c)?

A scan gets kicked off when you set either SSID or BSSID using iw or
iwconfig, so that the card has some idea of what you'd like to associate
with.  Kind of pointless to scan on dev open when the card doesn't have
any idea of what you want to associate to.  Might as well defer that
until you _have_ told the card what to do.

> Also for ath5k driver, both the hw_scan and sw_scan_start are not
> defined. These two functions are used in ieee80211_start_scan to start
> the scan process (net/mac80211/scan.c). I observed that the scan
> process is not started because the above two functions are not
> defined.

I believe only Intel Wifi Link cards implement hardware scanning.  The
rest of the cards use the mac80211 software scan functionality, which
works just fine.

Dan


