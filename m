Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.225]:62543 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbYCGPl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 10:41:28 -0500
Received: by wx-out-0506.google.com with SMTP id h31so730427wxd.4
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2008 07:41:27 -0800 (PST)
Message-ID: <43e72e890803070741q1e2558c2odb0046f7e519fc07@mail.gmail.com> (sfid-20080307_154155_904402_9014709B)
Date: Fri, 7 Mar 2008 10:41:26 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "bruno randolf" <bruno@thinktube.com>
Subject: Re: [RFC] RCPI support in radiotap and in our wireless subsystems
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	radiotap@mail.ojctech.com,
	"Ivan Seskar" <Seskar@winlab.rutgers.edu>,
	"Haris Kremo" <harisk@winlab.rutgers.edu>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Simon Barber" <simon@devicescape.com>,
	"Dan Williams" <dcbw@redhat.com>,
	"Luis Carlos Cobo" <luisca@cozybit.com>,
	"Javier Cardona" <javier@cozybit.com>,
	"Sam Leffler" <sam@errno.com>, "Jean Tourrilhes" <jt@hpl.hp.com>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <200803071757.19302.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890803061238u50847f1fs587627c5fac028d6@mail.gmail.com>
	 <200803070932.51396.bruno@thinktube.com>
	 <43e72e890803061904h742df37fuaa12977c45e457a@mail.gmail.com>
	 <200803071757.19302.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 7, 2008 at 3:57 AM, bruno randolf <bruno@thinktube.com> wrote:
> On Friday 07 March 2008 12:04:24 Luis R. Rodriguez wrote:
>  > >  it could be changed to something like:
>  > >
>  > >   * @signal: signal strength in dBm above noise or RCPI according to flag
>  >
>  > As it stands I don't think all drivers could populate this field under
>  > that description. For example, ssi in b43 is set to some magical value
>  > we have no clue what it means.
>  >
>  > We *could* test this stuff and see if it matches RCPI for each device,
>  > or just try to figure out at least what RSSI is wrt to the observed
>  > signal through a spectrum analyser (and even jssi is for b43) but I
>  > wonder how this will change upon hw revisions.
>  >
>  > >   * @noise: PHY noise in dBm when receiving this frame
>  > >   (remove ssi)
>  >
>  > Again, the problem in clarifying this also puts a restriction on what
>  > driver developers may know about their hardware.
>
>  yes, but you suggested RCPI which is even more difficult to deliver. well - i
>  don't know *any* device which could...

Well I was hoping we could see if we *could* deliver it, at least
within Atheros hardware but from what you tell me we can't. And from
what I gather from a few other wireless cards we can't either. The
idea was to propose it for radiotap but I do think its pointless if we
don't have hardware yet which we can produce those results.

>  ok. what about 3 hw flags then?
>
>  something like:
>  _SIGNAL_RSSI_UNITLESS
>  _SIGNAL_RSSI_DBM
>  _SIGNAL_RCPI

Seems reasonable.

>  so mac80211 can fill in the right radiotap headers, and drivers can make it
>  clear what they support. it's clear that drivers should strive to deliver the
>  most exact when they can.

Sounds good!

So having IEEE80211_RADIOTAP_DBM_ANTSIGNAL is preferable than
IEEE80211_RADIOTAP_DB_ANTSIGNAL in drivers, for obvious reasons. I'll
deal with another question with respect to mac80211 in another e-mail.

>  we have the same problem with the rx timestamp. we made a definition and ath5k
>  for example can't deliver. but i think a clear definition and a clear note
>  where it cannot be delivered is better than no definition at all :)

Sure, we have to take into consideration what other drivers can deliver as well.

  Luis
