Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.232]:31012 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbXCZPlk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 11:41:40 -0400
Received: by nz-out-0506.google.com with SMTP id s1so2066616nze
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2007 08:41:39 -0700 (PDT)
Message-ID: <43e72e890703260841v56047559y90b7c25c9c458564@mail.gmail.com>
Date: Mon, 26 Mar 2007 11:41:38 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "David Young" <dyoung@pobox.com>
Subject: Re: RFC: radiotap discrepancy in Linux vs OpenBSD
Cc: "Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org,
	"Scott Raynel" <scottraynel@gmail.com>, radiotap@mail.ojctech.com
In-Reply-To: <20070326033839.GA24097@che.ojctech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <20070325232416.64xwkc0kw04oosg0@webmail.spamcop.net>
	 <20070326033839.GA24097@che.ojctech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CC'ing radiotap list, this time with your comments inline.

On 3/25/07, David Young <dyoung@pobox.com> wrote:
> On Sun, Mar 25, 2007 at 11:24:16PM -0400, Pavel Roskin wrote:
> > Hello!
>
> (Oops, this time cc'd radiotap.)
>
> The place to discuss this is the mailing list
> radiotap@ojctech.com, which I have cc'd.  Subscribe at
> <http://mail.ojctech.com/mailman/listinfo/radiotap>.  Please feel free
> to circulate the URL.
>
> > I have noticed two different incompatible changes to enum
> > ieee80211_radiotap_type in ieee80211_radiotap.h.
> >
> > One is found in the current wireless-2.6.git:
> >
> >         IEEE80211_RADIOTAP_RX_FLAGS = 14,
> >         IEEE80211_RADIOTAP_TX_FLAGS = 15,
> >         IEEE80211_RADIOTAP_RTS_RETRIES = 16,
> >         IEEE80211_RADIOTAP_DATA_RETRIES = 17,
>
> These fields are slated to become part of the standard, I just haven't got
> around to updating the manual page, yet.  I have time to do that tonight.
>
> > It was added together with Marvell Libertas USB driver.
>
> > Another set of the flags can be found in CVS OpenBSD:
> >
> >         IEEE80211_RADIOTAP_FCS = 14,
> >         IEEE80211_RADIOTAP_HWQUEUE = 15,
> >         IEEE80211_RADIOTAP_RSSI = 16,
>
> These fields are not part of the standard, and they will not become part
> of the standard with these numbers.  This is the first time I have ever
> heard of HWQUEUE and RSSI, actually.  What are they for?

RSSI is Received Signal Strength Indication. Its a measurement of the
received radio signal strength. Unfortunately though RSSI units used
are arbitrary and the maximum value differs amongst chipsets. From
wikipedia:

--
RSSI measurements will vary from 0 to 255 depending on the vendor. It
consists of a one byte integer value. A value of 1 will indicate the
minimum signal strength detectable by the wireless card, while 0
indicates no signal. The value has a maximum of RSSI_Max. For example,
Cisco Systems cards will return a RSSI of 0 to 100. In this case, the
RSSI_Max is 100. The Cisco card can report 101 distinct power levels.
Another popular Wi-Fi chipset is made by Atheros. An Atheros based
card will return a RSSI value of 0 to 60.
--

As Samuel Barber had recommended before, we should probably instead
adopt RCPI. Quoting from his e-mail:

---
Here is the full text of the definition from 802.11k draft 5.0:

received channel power indicator (RCPI): An indication of the total
channel power (signal, noise, and interference) of a received IEEE
802.11 frame measured on a single channel and at the antenna connector
used to receive the frame.

The RCPI indicator is a measure of the received RF power in the selected
channel for a received frame. This parameter shall be a measure by the
PHY sublayer of the received RF power in the channel measured over the
entire received frame or by other equivalent means which meet the
specified accuracy. RCPI shall be a monotonically increasing,
logarithmic function of the received power level defined in dBm. The
allowed values for the Received Channel Power Indicator (RCPI) parameter
shall be an 8 bit value in the range from 0 through 220, with indicated
values rounded to the nearest 0.5 dB as follows:

0: Power < -110 dBm
1: Power = -109.5 dBm
2: Power = -109.0 dBm

and so on where

RCPI = int{(Power in dBm +110)*2} for 0dbm > Power > -110dBm

220: Power > -0 dBm
221-254: reserved
255: Measurement not available

RCPI shall equal the received RF power within an accuracy of +/-5 dB
(95% confidence interval) within the specified dynamic range of the
receiver. The received RF power shall be determined assuming a receiver
noise equivalent bandwidth equal to the channel bandwidth multiplied by
1.1.
--
