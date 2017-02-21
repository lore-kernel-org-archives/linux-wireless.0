Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59249 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751431AbdBUR7w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 12:59:52 -0500
Date: Tue, 21 Feb 2017 18:59:48 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH 1/2] firmware: add more flexible request_firmware_async
 function
Message-ID: <20170221175948.GK31264@wotan.suse.de> (sfid-20170221_190021_307866_002542EF)
References: <20170215222948.21030-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170215222948.21030-1-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 15, 2017 at 11:29:47PM +0100, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> So far we got only one function for loading firmware asynchronously:
> request_firmware_nowait. It didn't allow much customization of firmware
> loading process - there is only one bool uevent argument. Moreover this
> bool also controls user helper in an unclear way.
> 
> Resolve this problem by adding a one flexible function 

You've just taken under-the-hood flags and exposed them without considering and
enabling easy testing of any possible conflicts here.  Take for instance the
FW_OPT_NOCACHE feature -- not using caching functionality has implications for
driver developers -- they *must* resolve their own suspend/resume mishaps.
Another example, when we get firmware signing having just flags won't cut it
for optional parameters, we want a struct with the ability to specify custom
signing requirements. Exposing just flags will not cut it for us long term and
we'd have to then either add new export symbol or modify this one.

This is not as flexible nor as well documented as I want for future
functionality. Nor is there any series of battery of tests of all possible
options to ensure we do not regress. I've addressed this in the driver data
series.

> and making old
> request_firmware_nowait a simple inline using new solution. 

This I had not addressed in the driver data series but I will fold similar
strategy onto it.

> This
> implementation:
> 1) Modifies only single bits on existing code
> 2) Doesn't require adjusting / rewriting current drivers
> 3) Adds new function for drivers that need more control over loading a
>    firmware. Thanks to using flags more features can be added later.

As I noted in the driver data series -- we're passed using the firmware API for
non-firmware specific stuff, and as recent history shows regressions are are
easy, specially with the fallback mechanism. A new API which just gives us
2 calls: sync/async calls and shares a common set of optional parameters is
what we need, we need proper testing to ensure we also don't regress should
new features be introduced.

What I'll do is I'll integrate the feature you are asking for here and fold
this into the driver data series as what we need now is actual users of new
functionality, not just a test driver.

  Luis
