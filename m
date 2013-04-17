Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp07.msg.oleane.net ([62.161.4.7]:53705 "EHLO
	smtp07.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965719Ab3DQJbK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 05:31:10 -0400
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: "'Thomas Pedersen'" <thomas@cozybit.com>
Cc: <linux-wireless@vger.kernel.org>,
	"'open11s'" <devel@lists.open80211s.org>
References: <000601ce39de$b26e2950$174a7bf0$@acksys.fr> <CAG6hwVNbQ4uJynkcOGi+Pqi7c2tbExyuJENBogLwnJKOwBDtFw@mail.gmail.com>
In-Reply-To: <CAG6hwVNbQ4uJynkcOGi+Pqi7c2tbExyuJENBogLwnJKOwBDtFw@mail.gmail.com>
Subject: RE: mesh questions/suggestion about airtime metric and device constant in mesh_hwmp.c
Date: Wed, 17 Apr 2013 11:31:05 +0200
Message-ID: <000001ce3b4e$48dec550$da9c4ff0$@acksys.fr> (sfid-20130417_113116_195023_D95F13F6)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Thomas,

> -----Message d'origine-----
> De : Thomas Pedersen [mailto:thomas@cozybit.com]
> Envoyé : mardi 16 avril 2013 14:26
> On Mon, Apr 15, 2013 at 3:39 PM, Jean-Pierre Tosoni
> <jp.tosoni@acksys.fr> wrote:
> >
> > The 'device_constant' variable is given the constant value
> > '1<<ARITH_SHIFT', which means 1 microsecond if I am correct. 
> 
> The airtime is in units of 0.01TU, so a device_constant of 1 is more like
> 10us.

Then the code is wrong, because the airtime is never converted to 0.01TU ?
The comment says 'units of 100kbps' (which is true, I checked in
cfg80211_calculate_bitrate()), after that the code applies a 10 factor to
convert to units of 1Mbps, so the unit of tx_time is 1us, so device_constant
is in us as well.

> 
> > duration for the PPDU header is 20 microseconds in non-HT or 24 us in
> > HT, as shown in section 20.3.2
> >
> > For the test frame of 8192 bits, say at 300Mbps (MCS15), Bt/r = the
> > currently computed airtime is 28 instead of 51, underevaluated by -45% !
> > Since the value accumulates on the mesh path, it may make a big
> > difference for the path selection.
> 
> Since O (channel access overhead) is constant, changing it just scales
> the metric equally across all links, so I'm not sure what difference
> this would make?

Two reasons:

1) If we want a path from A to C, and there are two paths A-B-C and A-C, and
the bitrates are A-C=100M A-B=300M B-C=300M, we might choose the longer path
A-B-C although the headers overhead occur twice and the A-C path is better,
even at a slower bitrate.

2) Interoperability. If we want a path from A to C, which can use
intermediaries B1 or B2, the datarate through B1 is worse than B2 but metric
does not include overhead, and B2 from a non-Linux provider includes
overhead, then A might choose the bad path A-B1-C instead of the good path
A-B2-C
 
> 
> Getting device_constant as a function of current protection parameters
> and channel type (ie. actual channel access overhead) however, makes
> sense.

I fully agree ! 

Jean-Pierre

