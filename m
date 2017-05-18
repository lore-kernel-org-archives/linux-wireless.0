Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:35149 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753107AbdERAIt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 20:08:49 -0400
Received: by mail-qk0-f172.google.com with SMTP id a72so23711054qkj.2
        for <linux-wireless@vger.kernel.org>; Wed, 17 May 2017 17:08:49 -0700 (PDT)
Date: Wed, 17 May 2017 17:08:49 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Pali Roh?r <pali.rohar@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Pavel Machek <pavel@ucw.cz>, Daniel Wagner <wagi@monom.org>,
        Tom Gundersen <teg@jklm.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Takashi Iwai <tiwai@suse.de>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Micha?? Kazior <kazikcz@gmail.com>
Subject: Re: [PATCH 2/6] wl1251: Use request_firmware_prefer_user() for
 loading NVS calibration data
Message-ID: <20170518000848.GK12920@tuxbook> (sfid-20170518_020855_198922_13400843)
References: <0fd90416-f33c-a6be-14fd-5e964583e9cb@broadcom.com>
 <20170515231339.GF17314@wotan.suse.de>
 <1495022766.2442.1.camel@sipsolutions.net>
 <20170517125335.GG10015@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170517125335.GG10015@pali>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed 17 May 05:53 PDT 2017, Pali Roh?r wrote:

> On Wednesday 17 May 2017 14:06:06 Johannes Berg wrote:
> > On Tue, 2017-05-16 at 01:13 +0200, Luis R. Rodriguez wrote:
> > > > > Now for N900 case there is a similar scenario
> > > > > alhtough it has additional requirement to go to user-space due to
> > > > > need to use a proprietary library to obtain the NVS calibration
> > > > > data. My thought: Why should firmware_class care?
> > > 
> > > Agreed.
> > 
> > In fact, why should the *driver* care either? IOW - why should
> > "request_firmware_prefer_user()" even exist?
> 
> There are default/example NVS data, which are stored in /lib/firmware
> and installed by linux-firmware package. Those example calibration data
> should not be used for real usage, but Pavel told us that on N900 they
> are enough for working WIFI connection. They does not contain valid MAC
> address, so kernel should generate some (random?).
> 
> So kernel driver should get NVS calibration data from userspace (which
> know how where to get or how to prepare them) and in case userspace do
> not have it, then we can try fallback to those example data (as people
> reported us they can be useful instead of non-working WIFI).
> 

We're going to see a similar case with the Qualcomm DB410c WiFi soon,
where there is default calibration for the chip (wcn3620) but specific
calibration data for the particular board or product using this chip.

As with your case we expect to have a "generic" calibration file
integrated in linux-firmware, but providing means to supporting
device-specific calibration is probably going to be requested shortly.


We have however altered the reference design of picking the MAC address
from the calibration data and have the bootloader pass it via DT - so
our calibration data doesn't need to be specific to each unit.

Regards,
Bjorn
