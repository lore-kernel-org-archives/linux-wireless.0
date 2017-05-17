Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40588 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753774AbdEQNFC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 09:05:02 -0400
Message-ID: <1495026290.2442.6.camel@sipsolutions.net> (sfid-20170517_150603_280747_7F8782CF)
Subject: Re: [PATCH 2/6] wl1251: Use request_firmware_prefer_user() for
 loading NVS calibration data
From: Johannes Berg <johannes@sipsolutions.net>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
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
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>
Date: Wed, 17 May 2017 15:04:50 +0200
In-Reply-To: <20170517125335.GG10015@pali> (sfid-20170517_145339_432681_02EC3F26)
References: <0fd90416-f33c-a6be-14fd-5e964583e9cb@broadcom.com>
         <20170515231339.GF17314@wotan.suse.de>
         <1495022766.2442.1.camel@sipsolutions.net> <20170517125335.GG10015@pali>
         (sfid-20170517_145339_432681_02EC3F26)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-05-17 at 14:53 +0200, Pali Rohár wrote:

> > In fact, why should the *driver* care either? IOW - why should
> > "request_firmware_prefer_user()" even exist?
> 
> There are default/example NVS data, which are stored in /lib/firmware
> and installed by linux-firmware package.
[...]

Oh, so you're saying you want this to invert the order ... Ok, that
makes some sense.

I still hope that all other requests will eventually fall back to user
loading though, I think that's important to system integration in
general.

johannes
