Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51318 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751704AbdLSPOB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 10:14:01 -0500
Message-ID: <1513696434.4827.450.camel@coelho.fi> (sfid-20171219_161407_135309_F527FAFE)
From: Luca Coelho <luca@coelho.fi>
To: sedat.dilek@gmail.com
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        linuxwifi <linuxwifi@intel.com>
Date: Tue, 19 Dec 2017 17:13:54 +0200
In-Reply-To: <CA+icZUUuqoEuvwG9PE8LHT=3vFLf4FmkNUqMUOweE9s-1bcftg@mail.gmail.com>
References: <1511175768.4011.261.camel@coelho.fi>
         <CA+icZUVqhmH3dyMXkHKsHus5qyfMqQfcOctvHRDf4x=6+ndfPw@mail.gmail.com>
         <1511259055.4011.268.camel@coelho.fi>
         <CA+icZUVPzwX6hyPZaUJWwn7zOGMaRAkQ7SA6haw6p0F-YX7kBw@mail.gmail.com>
         <1511943649.4827.20.camel@coelho.fi>
         <CA+icZUUuqoEuvwG9PE8LHT=3vFLf4FmkNUqMUOweE9s-1bcftg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi 2017-11-19
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-12-19 at 14:52 +0100, Sedat Dilek wrote:
> On Wed, Nov 29, 2017 at 9:20 AM, Luca Coelho <luca@coelho.fi> wrote:
> > On Wed, 2017-11-29 at 08:51 +0100, Sedat Dilek wrote:
> > > On Tue, Nov 21, 2017 at 11:10 AM, Luca Coelho <luca@coelho.fi>
> > > wrote:
> > > > On Tue, 2017-11-21 at 10:30 +0100, Sedat Dilek wrote:
> > > > > On Mon, Nov 20, 2017 at 12:02 PM, Luca Coelho <luca@coelho.fi
> > > > > >
> > > > > wrote:
> > > > > [..]
> > > > > > ---------------------------------------------------------
> > > > > > ----
> > > > > > ---
> > > > > > iwlwifi: first set of fixes for 4.15
> > > > > > 
> > > > > > * Support new FW API version of scan cmd (used in FW
> > > > > > version
> > > > > > 34);
> > > > > 
> > > > > While seeing this...
> > > > > I have here a iwlwifi-8265 hardware and have seen a recently
> > > > > uploaded
> > > > > FW-version 34 in iwlwifi-firmware Git.
> > > > > Can you explain the dependence of iwlwifi firmware-version /
> > > > > Linux
> > > > > kernel-release and especially probing?
> > > > > Currently, I am using Linux v4.14 from Debian/experimental.
> > > > 
> > > > Mostly for backwards-compatibility, the driver is able to work
> > > > with
> > > > a
> > > > range of firmware versions.  It only uses one of them at a time
> > > > (i.e.
> > > > the highest supported version it finds).
> > > > 
> > > > The driver in v4.14 support version 34 and below.  So it starts
> > > > looking
> > > > for that one and, if not found, falls back to the next lower
> > > > version
> > > > (i.e. 33) and so on, until it finds one.
> > > > 
> > > 
> > > Isn't Linux v4.14.3 (here: -rc1) minimum to completely support
> > > new
> > > features in v34 firmware?
> > 
> > Yes, it is.  But this was a bug and we can't go back and fix
> > v4.14.0-2,
> > right? So it's the best we can do and whoever is using v4.14,
> > should
> > update to v4.14.3 when it comes out to be able to use version 34 of
> > the
> > firmware.
> > 
> 
> Thanks for the confirmation.
> 
> I have added the patch from v4.14.3 to latest Debian-kernel v4.14.2
> and rebuild the corresponding iwlwifi kernel-modules.
> v34 firmware works fine now.
> 
> # dmesg | egrep iwlwifi
> [   21.178769] iwlwifi: loading out-of-tree module taints kernel.
> [   21.184459] iwlwifi 0000:04:00.0: enabling device (0000 -> 0002)
> [   21.217170] iwlwifi 0000:04:00.0: firmware: direct-loading
> firmware
> iwlwifi-8265-34.ucode
> [   21.218061] iwlwifi 0000:04:00.0: loaded firmware version 34.0.1
> op_mode iwlmvm
> [   21.271000] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
> Wireless AC 8265, REV=0x230
> [   21.340242] iwlwifi 0000:04:00.0: base HW address:
> bc:a8:a6:d1:3f:49
> [   21.432118] iwlwifi 0000:04:00.0 wlp4s0: renamed from wlan0

Great! Thanks for confirming.

--
Luca.
