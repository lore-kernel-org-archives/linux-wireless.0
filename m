Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:16803 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbYBOBGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 20:06:39 -0500
Received: by py-out-1112.google.com with SMTP id u52so647468pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2008 17:06:38 -0800 (PST)
Message-ID: <43e72e890802141706v528489f5y8a46f13d87bebb62@mail.gmail.com> (sfid-20080215_010645_377741_8784F0B9)
Date: Thu, 14 Feb 2008 20:06:37 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "bruno randolf" <bruno@thinktube.com>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Cc: "Jouni Malinen" <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	"Kishore Ramachandran" <kishore@winlab.rutgers.edu>,
	"Ivan Seskar" <Seskar@winlab.rutgers.edu>
In-Reply-To: <200802121100.02259.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080118125252.6455.41047.stgit@one>
	 <20080207035813.GX1261@jm.kir.nu>
	 <43e72e890802080122x67a1fed1s7e6193eea0559f16@mail.gmail.com>
	 <200802121100.02259.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 11, 2008 at 9:00 PM, bruno randolf <bruno@thinktube.com> wrote:
>
> On Friday 08 February 2008 18:22:52 Luis R. Rodriguez wrote:
>  > On Feb 6, 2008 10:58 PM, Jouni Malinen <j@w1.fi> wrote:
>  > > On Wed, Feb 06, 2008 at 03:10:35PM -0500, John W. Linville wrote:
>  > > > FWIW, that wouldn't be the first time we (i.e. Linux) chose to do
>  > > > something that did not completely comply with a standard.  If it
>  > > > interoperates with other equipment and is good for users, I don't
>  > > > think picky standard compliance is worthwhile.
>  > >
>  > > Sure, there are cases where this is reasonable.
>  > >
>  > > > Please note that I am not really taking a stand in favor of this ATM,
>  > > > only asserting that blind standard compliance is not a good reason
>  > > > to NAK it IMHO.
>  > >
>  > > In this case, standard compliance is certainly not the only concern I
>  > > have. I'm worried about interoperability with non-mac80211
>  > > implementations. If mac80211 were to hardcoded the BSSID for IBSS and
>  > > refuse to change it no matter what (i.e., behave against the IEEE 802.11
>  > > standard), IBSS would not interoperate with any other implementation if
>  > > the other implementation happens to be the creator of the IBSS..
>  >
>  > OK so you're saying that some people might actually expect that when
>  > using the same SSID and same channel in close vicinity they'd get
>  > separate BSSIDs generated? If so I don't see why people would expect
>  > this functionality as a feature, I think this is more of a problem
>  > than an expected result of how the standard is designed.
>  >
>  > > Same issues shows up (but in somewhat less frequent form) in an IBSS
>  > > splitting up and re-joining. In order to allow the STAs using other
>  > > implementation (no BSSID hacks) to join the IBSS, mac80211 will need to
>  > > be prepared to change the BSSID (or use some much more questionable
>  > > hacks to make sure it is always the mac80211-STA that wins in the
>  > > selection of which BSSID will survive.. ;-).
>  >
>  > How would the IBSS be split up to generate a new BSSID? If you are
>  > part of an IBSS and you don't see anyone generate a beacon between the
>  > random backoff time you simply generate it, but the BSSID would still
>  > be the same.
>
>  i think the point here is that we still need to be prepared to merge IBSS
>  (i.e. switch to another BSSID when we receive a beacon with an older TSF) no
>  matter how we generate our own BSSID in the first place.

Well that is still possible.

>  using a hash of the BSSID and channel would reduce the necessity to merge IBSS
>  for mac80211 drivers but we still need to be able to join older IBSS from
>  other drivers.

Sure, how is it that this prevents that?

  Luis
