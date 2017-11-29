Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47976 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751546AbdK2IUw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Nov 2017 03:20:52 -0500
Message-ID: <1511943649.4827.20.camel@coelho.fi> (sfid-20171129_092056_716493_020D7BF3)
From: Luca Coelho <luca@coelho.fi>
To: sedat.dilek@gmail.com
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        linuxwifi <linuxwifi@intel.com>
Date: Wed, 29 Nov 2017 10:20:49 +0200
In-Reply-To: <CA+icZUVPzwX6hyPZaUJWwn7zOGMaRAkQ7SA6haw6p0F-YX7kBw@mail.gmail.com>
References: <1511175768.4011.261.camel@coelho.fi>
         <CA+icZUVqhmH3dyMXkHKsHus5qyfMqQfcOctvHRDf4x=6+ndfPw@mail.gmail.com>
         <1511259055.4011.268.camel@coelho.fi>
         <CA+icZUVPzwX6hyPZaUJWwn7zOGMaRAkQ7SA6haw6p0F-YX7kBw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi 2017-11-19
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-11-29 at 08:51 +0100, Sedat Dilek wrote:
> On Tue, Nov 21, 2017 at 11:10 AM, Luca Coelho <luca@coelho.fi> wrote:
> > On Tue, 2017-11-21 at 10:30 +0100, Sedat Dilek wrote:
> > > On Mon, Nov 20, 2017 at 12:02 PM, Luca Coelho <luca@coelho.fi>
> > > wrote:
> > > [..]
> > > > -------------------------------------------------------------
> > > > ---
> > > > iwlwifi: first set of fixes for 4.15
> > > > 
> > > > * Support new FW API version of scan cmd (used in FW version
> > > > 34);
> > > 
> > > While seeing this...
> > > I have here a iwlwifi-8265 hardware and have seen a recently
> > > uploaded
> > > FW-version 34 in iwlwifi-firmware Git.
> > > Can you explain the dependence of iwlwifi firmware-version /
> > > Linux
> > > kernel-release and especially probing?
> > > Currently, I am using Linux v4.14 from Debian/experimental.
> > 
> > Mostly for backwards-compatibility, the driver is able to work with
> > a
> > range of firmware versions.  It only uses one of them at a time
> > (i.e.
> > the highest supported version it finds).
> > 
> > The driver in v4.14 support version 34 and below.  So it starts
> > looking
> > for that one and, if not found, falls back to the next lower
> > version
> > (i.e. 33) and so on, until it finds one.
> > 
> 
> Isn't Linux v4.14.3 (here: -rc1) minimum to completely support new
> features in v34 firmware?

Yes, it is.  But this was a bug and we can't go back and fix v4.14.0-2, 
right? So it's the best we can do and whoever is using v4.14, should
update to v4.14.3 when it comes out to be able to use version 34 of the
firmware.


--
Cheers,
Luca.
