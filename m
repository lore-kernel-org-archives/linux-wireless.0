Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46638 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751772AbdKUKK7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 05:10:59 -0500
Message-ID: <1511259055.4011.268.camel@coelho.fi> (sfid-20171121_111103_852219_FDDE3BB1)
From: Luca Coelho <luca@coelho.fi>
To: sedat.dilek@gmail.com
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        linuxwifi <linuxwifi@intel.com>
Date: Tue, 21 Nov 2017 12:10:55 +0200
In-Reply-To: <CA+icZUVqhmH3dyMXkHKsHus5qyfMqQfcOctvHRDf4x=6+ndfPw@mail.gmail.com>
References: <1511175768.4011.261.camel@coelho.fi>
         <CA+icZUVqhmH3dyMXkHKsHus5qyfMqQfcOctvHRDf4x=6+ndfPw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi 2017-11-19
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-11-21 at 10:30 +0100, Sedat Dilek wrote:
> On Mon, Nov 20, 2017 at 12:02 PM, Luca Coelho <luca@coelho.fi> wrote:
> [..]
> > ----------------------------------------------------------------
> > iwlwifi: first set of fixes for 4.15
> > 
> > * Support new FW API version of scan cmd (used in FW version 34);
> 
> While seeing this...
> I have here a iwlwifi-8265 hardware and have seen a recently uploaded
> FW-version 34 in iwlwifi-firmware Git.
> Can you explain the dependence of iwlwifi firmware-version / Linux
> kernel-release and especially probing?
> Currently, I am using Linux v4.14 from Debian/experimental.

Mostly for backwards-compatibility, the driver is able to work with a
range of firmware versions.  It only uses one of them at a time (i.e.
the highest supported version it finds).

The driver in v4.14 support version 34 and below.  So it starts looking
for that one and, if not found, falls back to the next lower version
(i.e. 33) and so on, until it finds one.


> [   10.630285] iwlwifi 0000:04:00.0: firmware: failed to load
> iwlwifi-8265-34.ucode (-2)
> [   10.630331] iwlwifi 0000:04:00.0: Direct firmware load for
> iwlwifi-8265-34.ucode failed with error -2
> [   10.630454] iwlwifi 0000:04:00.0: firmware: failed to load
> iwlwifi-8265-33.ucode (-2)
> [   10.630479] iwlwifi 0000:04:00.0: Direct firmware load for
> iwlwifi-8265-33.ucode failed with error -2
> [   10.630486] iwlwifi 0000:04:00.0: firmware: failed to load
> iwlwifi-8265-32.ucode (-2)
> [   10.630510] iwlwifi 0000:04:00.0: Direct firmware load for
> iwlwifi-8265-32.ucode failed with error -2
> [   10.636423] iwlwifi 0000:04:00.0: firmware: direct-loading
> firmware
> iwlwifi-8265-31.ucode
> [   10.637463] iwlwifi 0000:04:00.0: loaded firmware version
> 31.532993.0 op_mode iwlmvm

This is an unfortunate side-effect of the way firmwares are loaded. 
There is currently no way to prevent these error messages by making
some files optional... But you can ignore them.  Or, even better,
upgrade your firmware to the latest version the driver supports. :)

--
Cheers,
Luca.
