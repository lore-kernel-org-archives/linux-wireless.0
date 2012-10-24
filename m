Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55112 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422740Ab2JXWIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 18:08:18 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so668098pad.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 15:08:18 -0700 (PDT)
Date: Wed, 24 Oct 2012 15:08:13 -0700
From: Thomas Pedersen <thomas@cozybit.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [ath9k-devel] ath9k_htc and reported mactime
Message-ID: <20121024220813.GB6723@shredder> (sfid-20121025_000837_765851_BC1B205F)
References: <CAG6hwVP5YkBEN9vZPGGEHbK=9ow2wJJ1x_BvSQbDzUscTiOHTA@mail.gmail.com>
 <CAJ-Vmokr0293M-yqQ6LvM4WKC+P0w0N2mHjpKK+rSFFjAmhwfQ@mail.gmail.com>
 <20121024194547.GA19060@shredder>
 <CAJ-VmonEZbKiVqnu1SDDbNDTj3qeWB2QgTN=h3NHdiZrMp8LDA@mail.gmail.com>
 <CAJ-VmonzYsUsSOyr34Xj9=mTpsHEbGNUS2RoN=BenqthGfakVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-VmonzYsUsSOyr34Xj9=mTpsHEbGNUS2RoN=BenqthGfakVw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 24, 2012 at 02:26:05PM -0700, Adrian Chadd wrote:
> On 24 October 2012 14:22, Adrian Chadd <adrian@freebsd.org> wrote:
> > Hi,
> >
> > can you please repeat this experiment but dump the TSF32/TSF64 fields
> > there as hexadecimal, rather than decimal?
> >
> > I'd like to see if this is an example of "bad TSF32->TSF64 promotion".
> 
> Also, we should check to see whether the MAC is paying attention to
> any beacon frames

How? For mesh mode support we currently just reuse the WDS AP firmware vif
opmode.

> and updating _its_ timestamp using that beacon frame timer.  That's
> one of the mesh-and-sta-and-ap-at-the-same-time problems - in
> STA mode, the TSF gets fudged based on the AP TSF. In other modes this
> doesn't necessarily hold.

OK, but the TSF for AP shouldn't be automatically updated on other
beacons, right?

Thanks again,
Thomas
