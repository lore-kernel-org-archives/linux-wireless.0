Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:54435 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759312Ab3DYSaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Apr 2013 14:30:13 -0400
Received: by mail-qc0-f181.google.com with SMTP id a22so1708746qcs.12
        for <linux-wireless@vger.kernel.org>; Thu, 25 Apr 2013 11:30:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMLZHHQ=BNuD0UmcV8pv=6phW=W-C5C7Af6n8tLWTrzyuzPQow@mail.gmail.com>
References: <CAMLZHHSVd6GpmqTQyJmbsheH1utZh8mNW8d4zLtjwoONaGwbNA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E0579DB@SC-VEXCH1.marvell.com>
	<CAMLZHHQ=BNuD0UmcV8pv=6phW=W-C5C7Af6n8tLWTrzyuzPQow@mail.gmail.com>
Date: Thu, 25 Apr 2013 12:30:12 -0600
Message-ID: <CAMLZHHQXY3OuWKr_K1B9-NmZFwCcQFPNTBoOkpvT9kxWJ=ixqQ@mail.gmail.com> (sfid-20130425_203019_160165_8034143D)
Subject: Re: Memory leak in mwifiex_cfg80211_scan
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 24, 2013 at 4:48 PM, Daniel Drake <dsd@laptop.org> wrote:
> However, strangely, it seems to make a whole bunch of kmemleak reports
> *appear*, as if the struct netdev is not being destroyed, and more. I
> guess this could just be a kmemleak oddity but it is strange that it
> did not appear before this patch.

While I don't have an explanation for why kmemleak didn't detect this
before, I have confirmed with some simple printks that mwifiex does
not call free_netdev on the netdev that it allocates, at least when
using the test script posted earlier in this thread. So that is
another leak that must be fixed.

> Trying to look for possible causes (memory corruption?), I can't see
> any code that serializes scan_delay_timer_fn with mwifiex_close(), so
> mwifiex_close freeing the scan data while scan_delay_timer_fn is using
> it could cause badness to happen. However I haven't yet figured out
> how to trigger scan_delay_timer_fn to execute even once (any tips?).

I still haven't figured out how to make this code trigger, but I
looked again, and I do believe there is a potential crash waiting for
us here, because there is no serialization between mwifiex_close and
the possible running of this timer (which uses user_scan_cfg).

Also, I found another issue. Change the script to:

insmod mwifiex_sdio.ko
sleep 1
ifconfig eth0 up
iwlist eth0 scan &
sleep 0.1
ifconfig eth0 down

and add printk's in mwifiex_close (where user_scan_cfg is freed) and
in mwifiex_cfg80211_scan() (where user_cfg_cfg is used and also
freed). You can see that mwifiex_cfg80211_scan() executes at the same
time as mwifiex_close() (and several times after) and I can't see any
serialization here, so I think there are some other crashes here as
well (e.g. looks like it could race and we could double-free
user_scan_cfg).

Thanks
Daniel
