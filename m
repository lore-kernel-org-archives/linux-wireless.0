Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from che.ojctech.com ([64.198.255.2]:54701 "EHLO che.ojctech.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbXCZQ7R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 12:59:17 -0400
Date: Mon, 26 Mar 2007 11:59:08 -0500
From: David Young <dyoung@pobox.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	Scott Raynel <scottraynel@gmail.com>, radiotap@mail.ojctech.com
Subject: Re: RFC: radiotap discrepancy in Linux vs OpenBSD
Message-ID: <20070326165908.GK31621@che.ojctech.com>
References: <20070325232416.64xwkc0kw04oosg0@webmail.spamcop.net> <20070326033839.GA24097@che.ojctech.com> <43e72e890703260841v56047559y90b7c25c9c458564@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890703260841v56047559y90b7c25c9c458564@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 26, 2007 at 11:41:38AM -0400, Luis R. Rodriguez wrote:
> CC'ing radiotap list, this time with your comments inline.
> 
> On 3/25/07, David Young <dyoung@pobox.com> wrote:
> >On Sun, Mar 25, 2007 at 11:24:16PM -0400, Pavel Roskin wrote:
> >> Hello!
> >
> >(Oops, this time cc'd radiotap.)
> >
> >The place to discuss this is the mailing list
> >radiotap@ojctech.com, which I have cc'd.  Subscribe at
> ><http://mail.ojctech.com/mailman/listinfo/radiotap>.  Please feel free
> >to circulate the URL.
> >
> >> I have noticed two different incompatible changes to enum
> >> ieee80211_radiotap_type in ieee80211_radiotap.h.
> >>
> >> One is found in the current wireless-2.6.git:
> >>
> >>         IEEE80211_RADIOTAP_RX_FLAGS = 14,
> >>         IEEE80211_RADIOTAP_TX_FLAGS = 15,
> >>         IEEE80211_RADIOTAP_RTS_RETRIES = 16,
> >>         IEEE80211_RADIOTAP_DATA_RETRIES = 17,
> >
> >These fields are slated to become part of the standard, I just haven't got
> >around to updating the manual page, yet.  I have time to do that tonight.
> >
> >> It was added together with Marvell Libertas USB driver.
> >
> >> Another set of the flags can be found in CVS OpenBSD:
> >>
> >>         IEEE80211_RADIOTAP_FCS = 14,
> >>         IEEE80211_RADIOTAP_HWQUEUE = 15,
> >>         IEEE80211_RADIOTAP_RSSI = 16,
> >
> >These fields are not part of the standard, and they will not become part
> >of the standard with these numbers.  This is the first time I have ever
> >heard of HWQUEUE and RSSI, actually.  What are they for?
> 
> RSSI is Received Signal Strength Indication. Its a measurement of the
> received radio signal strength. Unfortunately though RSSI units used
> are arbitrary and the maximum value differs amongst chipsets. From
> wikipedia:
> 
> --
> RSSI measurements will vary from 0 to 255 depending on the vendor. It
> consists of a one byte integer value. A value of 1 will indicate the
> minimum signal strength detectable by the wireless card, while 0
> indicates no signal. The value has a maximum of RSSI_Max. For example,
> Cisco Systems cards will return a RSSI of 0 to 100. In this case, the
> RSSI_Max is 100. The Cisco card can report 101 distinct power levels.
> Another popular Wi-Fi chipset is made by Atheros. An Atheros based
> card will return a RSSI value of 0 to 60.
> --
> 
> As Samuel Barber had recommended before, we should probably instead
> adopt RCPI. Quoting from his e-mail:

RCPI sounds desirable.  Let us avoid labeling a field RCPI if it isn't.
We may need both fields, RSSI (defined: uncalibrated, unsigned, unitless
signal strength, greater numbers -> greater strength) and RCPI (defined
per 802.11k draft 5.0).

Is 802.11k changing very rapidly, esp. the RCPI definition?

Dave

-- 
David Young             OJC Technologies
dyoung@ojctech.com      Urbana, IL * (217) 278-3933
