Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:31468 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605AbYDBT1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 15:27:32 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1542543rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Apr 2008 12:27:32 -0700 (PDT)
Message-ID: <43e72e890804021227y520380f7j8ad25eb30f635d2b@mail.gmail.com> (sfid-20080402_202744_869699_8E996DF4)
Date: Wed, 2 Apr 2008 15:27:31 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "bruno randolf" <bruno@thinktube.com>
Subject: Re: [PATCH] mac80211: use hardware flags for signal/noise units
Cc: ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	flamingice@sourmilk.net, jbenc@suse.cz,
	"Ivan Seskar" <Seskar@winlab.rutgers.edu>,
	"Jean Tourrilhes" <jt@hpl.hp.com>,
	"Haris Kremo" <harisk@winlab.rutgers.edu>,
	"Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <200803271107.54208.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080326123042.11233.80949.stgit@localhost>
	 <43e72e890803261559keb944a1g48d93645db2f2e73@mail.gmail.com>
	 <200803271107.54208.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 26, 2008 at 10:07 PM, bruno randolf <bruno@thinktube.com> wrote:
> On Thursday 27 March 2008 07:59:11 Luis R. Rodriguez wrote:
>  > >  + * @IEEE80211_HW_SIGNAL_UNSPEC:
>  > >  + *     Hardware can provide signal values but we don't know its units.
>  > > To be + *     able to standardize between different devices we would like
>  > > linear + *     values from 0-100. If possible please provide dB or dBm
>  > > instead. + *
>  > >  + * @IEEE80211_HW_SIGNAL_DB:
>  > >  + *     Hardware gives signal values in dB, decibel difference from an
>  > >  + *     arbitrary, fixed reference. If possible please provide dBm
>  > > instead. + *
>  >
>  > Signal should given in either be in dBm or an unspecified value. Since
>  > we have "unspecified" not sure why we would have the "db" value. Can
>  > you clarify what the difference between "unspecified" and "db" would
>  > be? I don't think it makes sense to refer to signal with a "db" value,
>  > unless we want "singal" here to be able to mean SNR.
>
>  the best thing to specify is dBm and all drivers should try to do that. it's
>  the only absolute value which makes sense and can be compared between
>  different drivers and devices.
>
>  however as we know some drivers simply cannot provide that. instead they have
>  some form of RSSI - RSSI in general meaning nothing more than "received
>  signal strength indication", which could be *anything*: voltage, any numbers,
>  in dB or linear or whatever. RSSI does *not* in general mean SNR! for example
>  you might remember the values of prism54, they were somewhere around 200. or
>  prism2 cards which had something around 100 (it's been a while since i've
>  touched them, so that might have changed). as jean noted the values don't
>  even have to be linear - so i think we should remove that from the
>  definition.
>
>  so in the "unspecified" case we really don't know much about the units, in the
>  worst case we can't even assume that 1/2 the value will mean 1/2 of the
>  received signal strength. it's very hard to work with this values, but it's
>  better than nothing.
>
>  other cards might not have noise, so no absolute (dBm) measurement, but a form
>  of RSSI which is measured in dB (that is a logarithmic difference). in this
>  case we might not know which reference point the measurement is taken to, but
>  we know how it behaves: -3 dB means half of the signal strength. if you add a
>  6dB gain antenna you can expect to see the signal reading to increase by 6dB.
>  it's not strictly SNR (because we don't know the noise) but quite close to
>  it.
>
>  i think it's important to know the difference between this 3 cases i order to
>  make some sense of the values in userspace gui, roaming agents, mesh link
>  metrics, etc...

Agreed, but can you give me an example of a card which does provide
RSSI in db for values we don't know and that UNSPEC cannot handle? Is
this what is assumed of the rt2x00 cards?

  Luis
