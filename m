Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47444 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbZCZUML (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 16:12:11 -0400
Subject: Re: Scan in compat-wireless
From: Dan Williams <dcbw@redhat.com>
To: Venkat Ch <venkatch@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <c1e027750903261121i2958b705ldeb33eb036a4ebeb@mail.gmail.com>
References: <c1e027750903250041qfb28bb5g69bc219da57736c0@mail.gmail.com>
	 <c1e027750903250043n1e6bfffdnd6a6a3889a1f68d6@mail.gmail.com>
	 <1237995293.18896.12.camel@localhost.localdomain>
	 <c1e027750903261121i2958b705ldeb33eb036a4ebeb@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 16:09:58 -0400
Message-Id: <1238098198.3254.4.camel@localhost.localdomain> (sfid-20090326_211229_483330_67147170)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-03-26 at 23:51 +0530, Venkat Ch wrote:
> Hi Dan,
>    You have a valid point. Please see my reply inline.
> 
> On Wed, Mar 25, 2009 at 9:04 PM, Dan Williams <dcbw@redhat.com> wrote:
> >
> > On Wed, 2009-03-25 at 13:13 +0530, Venkat Ch wrote:
> > > Hi All,
> > >
> > >  Last week I have downloaded compat-wireless driver. I have installed
> > > the same into my laptop which has AR242x based WiFi card. Though the
> > > drivers are loaded correctly, the STA (my laptop) did not associate
> > > with the nearby AP. This used to happen well with madwifi driver.
> > >
> > > With my past experience with the details of madwifi driver, I have
> > > browsed through the code base of compat-wireless driver. I observed
> > > that with madwifi driver when the device is made up, the scan process
> > > is kicked off. Where as the same is not happening in compat-wireless.
> > > Does not the scan process need to be kicked off at the end of
> > > ieee80211_open (net/mac80211/iface.c)?
> >
> > A scan gets kicked off when you set either SSID or BSSID using iw or
> > iwconfig, so that the card has some idea of what you'd like to associate
> > with.  Kind of pointless to scan on dev open when the card doesn't have
> > any idea of what you want to associate to.  Might as well defer that
> > until you _have_ told the card what to do.
> 
> I see two issues with this policy.  Sorry if they are already
> discussed in the mailing list. I have searched in Google and have not
> seen any discussion on these.
> 
> 1.  It effects mobility. Every time the user moves to a new network
> the SSID or BSS needs to be set manually.

Correct: if you're in an area with many access points, how is the driver
supposed to know which APs are allowed and which are not?  Certainly
connecting to any random SSID that the driver sees is a security risk,
and should not be done.

What you want is to use wpa_supplicant (or NetworkManager or something)
in userspace to control driver roaming.  Populate the wpa_supplicant
config with the list of allowed SSIDs, and then roaming works just fine.

> 2.  On a similar note the upcoming standards 802.11u and 802.21 need
> proactive scanning, which is not supported with the current
> implementation.

Again, the userspace daemon that controls roaming and/or policy
(wpa_supplicant or NetworkManager) would be triggering the proactive
scanning, then applying policy to the list of returned access points,
before choosing the "best" AP to associate with.

Dan

> I have verified this  with a small test in our WLAN. It is not exactly
> a mobility scenario. But can be considered as a sub case of mobility
> requirement.
> 
> 1. Set the essid to that of the AP is using. (iwconfig wlan0 ssid
> "blllllll"). The STA is associated with the AP now.
> 2. Switch-off AP for few minutes until the  link between STA and AP is
> broken. (Verify this using iwconfig command)
> 3. Switch on the AP. The STA wont associate with the AP until you
> specify, again the SSID or BSSID of the AP at the STA using iwconfig
> command.
> 
> Thanks & Regards
> Venkat
> 
> 
> >
> > > Also for ath5k driver, both the hw_scan and sw_scan_start are not
> > > defined. These two functions are used in ieee80211_start_scan to start
> > > the scan process (net/mac80211/scan.c). I observed that the scan
> > > process is not started because the above two functions are not
> > > defined.
> >
> > I believe only Intel Wifi Link cards implement hardware scanning.  The
> > rest of the cards use the mac80211 software scan functionality, which
> > works just fine.
> >
> > Dan
> >
> >
> 
> 
> 
> --
> Peace is its own reward
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

