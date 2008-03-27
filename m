Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:7643 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754598AbYC0CIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 22:08:06 -0400
From: bruno randolf <bruno@thinktube.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] mac80211: use hardware flags for signal/noise units
Date: Thu, 27 Mar 2008 11:07:54 +0900
Cc: ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	flamingice@sourmilk.net, jbenc@suse.cz,
	"Ivan Seskar" <Seskar@winlab.rutgers.edu>,
	"Jean Tourrilhes" <jt@hpl.hp.com>,
	"Haris Kremo" <harisk@winlab.rutgers.edu>
References: <20080326123042.11233.80949.stgit@localhost> <43e72e890803261559keb944a1g48d93645db2f2e73@mail.gmail.com>
In-Reply-To: <43e72e890803261559keb944a1g48d93645db2f2e73@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803271107.54208.bruno@thinktube.com> (sfid-20080327_020813_454870_ACED71DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 27 March 2008 07:59:11 Luis R. Rodriguez wrote:
> >  + * @IEEE80211_HW_SIGNAL_UNSPEC:
> >  + *     Hardware can provide signal values but we don't know its units.
> > To be + *     able to standardize between different devices we would like
> > linear + *     values from 0-100. If possible please provide dB or dBm
> > instead. + *
> >  + * @IEEE80211_HW_SIGNAL_DB:
> >  + *     Hardware gives signal values in dB, decibel difference from an
> >  + *     arbitrary, fixed reference. If possible please provide dBm
> > instead. + *
>
> Signal should given in either be in dBm or an unspecified value. Since
> we have "unspecified" not sure why we would have the "db" value. Can
> you clarify what the difference between "unspecified" and "db" would
> be? I don't think it makes sense to refer to signal with a "db" value,
> unless we want "singal" here to be able to mean SNR.

the best thing to specify is dBm and all drivers should try to do that. it's 
the only absolute value which makes sense and can be compared between 
different drivers and devices.

however as we know some drivers simply cannot provide that. instead they have 
some form of RSSI - RSSI in general meaning nothing more than "received 
signal strength indication", which could be *anything*: voltage, any numbers, 
in dB or linear or whatever. RSSI does *not* in general mean SNR! for example 
you might remember the values of prism54, they were somewhere around 200. or 
prism2 cards which had something around 100 (it's been a while since i've 
touched them, so that might have changed). as jean noted the values don't 
even have to be linear - so i think we should remove that from the 
definition.

so in the "unspecified" case we really don't know much about the units, in the 
worst case we can't even assume that 1/2 the value will mean 1/2 of the 
received signal strength. it's very hard to work with this values, but it's 
better than nothing.

other cards might not have noise, so no absolute (dBm) measurement, but a form 
of RSSI which is measured in dB (that is a logarithmic difference). in this 
case we might not know which reference point the measurement is taken to, but 
we know how it behaves: -3 dB means half of the signal strength. if you add a 
6dB gain antenna you can expect to see the signal reading to increase by 6dB. 
it's not strictly SNR (because we don't know the noise) but quite close to 
it.

i think it's important to know the difference between this 3 cases i order to 
make some sense of the values in userspace gui, roaming agents, mesh link 
metrics, etc...

bruno
