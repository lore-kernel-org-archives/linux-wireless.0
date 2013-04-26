Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:58578 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab3DZR3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 13:29:54 -0400
Received: by mail-qa0-f46.google.com with SMTP id p6so287465qad.12
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2013 10:29:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9E14FF4C@SC-VEXCH1.marvell.com>
References: <CAMLZHHSVd6GpmqTQyJmbsheH1utZh8mNW8d4zLtjwoONaGwbNA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E0579DB@SC-VEXCH1.marvell.com>
	<CAMLZHHQ=BNuD0UmcV8pv=6phW=W-C5C7Af6n8tLWTrzyuzPQow@mail.gmail.com>
	<CAMLZHHQXY3OuWKr_K1B9-NmZFwCcQFPNTBoOkpvT9kxWJ=ixqQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E14FF4C@SC-VEXCH1.marvell.com>
Date: Fri, 26 Apr 2013 11:29:53 -0600
Message-ID: <CAMLZHHSHG2ySmW0ac6+M-7fOgNFrqXBf7=SXFFkWDrhwGwYKXQ@mail.gmail.com> (sfid-20130426_192959_049128_77C99D04)
Subject: Re: Memory leak in mwifiex_cfg80211_scan
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 25, 2013 at 4:50 PM, Bing Zhao <bzhao@marvell.com> wrote:
> Hi Daniel,
>
>> While I don't have an explanation for why kmemleak didn't detect this
>> before, I have confirmed with some simple printks that mwifiex does
>> not call free_netdev on the netdev that it allocates, at least when
>> using the test script posted earlier in this thread. So that is
>> another leak that must be fixed.
>
> Yes it is. Attached is a patch from Amitkumar Karwar to fix it.

Thanks.  This seems to be working, and makes kmemleak happy.
So when we find a race-free way to free user_scan_cfg, we can probably
end this topic.

> One scan request from cfg80211 is split to multiple scan commands being sent from driver to firmware.
> If scan_request is cleared (e.g. mwifiex_close) during a scan command processing, all pending scan commands will be aborted after getting response of previous scan command, and scan_delay_timer is modified to fire in 50ms.
>
> With original script (mwifiex_sdio is removed), I don't see scan_delay_timer_fn() gets triggered either. My assumption is that the scan_pending_q has already been emptied, so we don't run into the same path as above.

So far I have not managed to get scan_delay_timer_fn() to execute at
all - even when I am not using that script. But I have not really
diagnosed why. I was wondering if there's anything obvious I might be
missing.

Thanks
Daniel
