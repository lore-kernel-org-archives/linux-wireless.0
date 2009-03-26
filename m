Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:40649 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbZCZSVJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 14:21:09 -0400
Received: by ey-out-2122.google.com with SMTP id 4so202516eyf.37
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 11:21:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237995293.18896.12.camel@localhost.localdomain>
References: <c1e027750903250041qfb28bb5g69bc219da57736c0@mail.gmail.com>
	 <c1e027750903250043n1e6bfffdnd6a6a3889a1f68d6@mail.gmail.com>
	 <1237995293.18896.12.camel@localhost.localdomain>
Date: Thu, 26 Mar 2009 23:51:05 +0530
Message-ID: <c1e027750903261121i2958b705ldeb33eb036a4ebeb@mail.gmail.com> (sfid-20090326_192114_120034_A58E79D6)
Subject: Re: Scan in compat-wireless
From: Venkat Ch <venkatch@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,
=A0=A0 You have a valid point. Please see my reply inline.

On Wed, Mar 25, 2009 at 9:04 PM, Dan Williams <dcbw@redhat.com> wrote:
>
> On Wed, 2009-03-25 at 13:13 +0530, Venkat Ch wrote:
> > Hi All,
> >
> > =A0Last week I have downloaded compat-wireless driver. I have insta=
lled
> > the same into my laptop which has AR242x based WiFi card. Though th=
e
> > drivers are loaded correctly, the STA (my laptop) did not associate
> > with the nearby AP. This used to happen well with madwifi driver.
> >
> > With my past experience with the details of madwifi driver, I have
> > browsed through the code base of compat-wireless driver. I observed
> > that with madwifi driver when the device is made up, the scan proce=
ss
> > is kicked off. Where as the same is not happening in compat-wireles=
s.
> > Does not the scan process need to be kicked off at the end of
> > ieee80211_open (net/mac80211/iface.c)?
>
> A scan gets kicked off when you set either SSID or BSSID using iw or
> iwconfig, so that the card has some idea of what you'd like to associ=
ate
> with. =A0Kind of pointless to scan on dev open when the card doesn't =
have
> any idea of what you want to associate to. =A0Might as well defer tha=
t
> until you _have_ told the card what to do.

I see two issues with this policy.=A0 Sorry if they are already
discussed in the mailing list. I have searched in Google and have not
seen any discussion on these.

1.=A0 It effects mobility. Every time the user moves to a new network
the SSID or BSS needs to be set manually.
2.=A0 On a similar note the upcoming standards 802.11u and 802.21 need
proactive scanning, which is not supported with the current
implementation.

I have verified this=A0 with a small test in our WLAN. It is not exactl=
y
a mobility scenario. But can be considered as a sub case of mobility
requirement.

1. Set the essid to that of the AP is using. (iwconfig wlan0 ssid
"blllllll"). The STA is associated with the AP now.
2. Switch-off AP for few minutes until the=A0 link between STA and AP i=
s
broken. (Verify this using iwconfig command)
3. Switch on the AP. The STA wont associate with the AP until you
specify, again the SSID or BSSID of the AP at the STA using iwconfig
command.

Thanks & Regards
Venkat


>
> > Also for ath5k driver, both the hw_scan and sw_scan_start are not
> > defined. These two functions are used in ieee80211_start_scan to st=
art
> > the scan process (net/mac80211/scan.c). I observed that the scan
> > process is not started because the above two functions are not
> > defined.
>
> I believe only Intel Wifi Link cards implement hardware scanning. =A0=
The
> rest of the cards use the mac80211 software scan functionality, which
> works just fine.
>
> Dan
>
>



--
Peace is its own reward
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
