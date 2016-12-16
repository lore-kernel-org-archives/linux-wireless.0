Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.monom.org ([188.138.9.77]:42245 "EHLO mail.monom.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753742AbcLPHZy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 02:25:54 -0500
Subject: Re: wl1251 & mac address & calibration data
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Tom Gundersen <teg@jklm.no>,
        Johannes Berg <johannes@sipsolutions.net>,
        Ming Lei <ming.lei@canonical.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <201611111820.52072@pali> <201611241749.33681@pali>
 <20161124181138.4i6ehkpohjxfgpbn@earth> <201611241935.32796@pali>
 <87d1gtli57.fsf@purkki.adurom.net> <1481816017.2090.2.camel@Pali-Nokia-N900>
 <76365770-f5ba-9565-3fca-710518f64d81@broadcom.com>
 <CAB=NE6VHF+U7DzapENvLMKtN4Dgi9J0qMoeUJ8o4vSwc2-rRFQ@mail.gmail.com>
Cc: =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Michal Kazior <michal.kazior@tieto.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Takashi Iwai <tiwai@suse.de>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
From: Daniel Wagner <wagi@monom.org>
Message-ID: <07be7fc8-6c7f-6e03-379d-fa781b248259@monom.org> (sfid-20161216_082628_406283_25B640C5)
Date: Fri, 16 Dec 2016 08:25:44 +0100
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VHF+U7DzapENvLMKtN4Dgi9J0qMoeUJ8o4vSwc2-rRFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2016 03:03 AM, Luis R. Rodriguez wrote:
> For the new API a solution for "fallback mechanisms" should be clean
> though and I am looking to stay as far as possible from the existing
> mess. A solution to help both the old API and new API is possible for
> the "fallback mechanism" though -- but for that I can only refer you
> at this point to some of Daniel Wagner and Tom Gunderson's firmwared
> deamon prospect. It should help pave the way for a clean solution and
> help address other stupid issues.

The firmwared project is hosted here

https://github.com/teg/firmwared

As Luis pointed out, firmwared relies on FW_LOADER_USER_HELPER_FALLBACK, 
which is not enabled by default. I don't see any reason why firmwared 
should not also support loading calibration data. If we find a sound way 
to do this.

As you can see from the commit history it is a pretty young project and 
more ore less reanimation of the old udev firmware loader feature.  We 
are getting int into shape, adding integration tests etc.

The main motivation for this project is the get movement back in stuck 
discussion on the firmware loader API. Luis was very busy writing up all 
the details on the current situation and purely from the amount of 
documentation need to describe the API you can tell something is awry.

Thanks,
Daniel
