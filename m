Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:35889 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab3EGUPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 16:15:40 -0400
Received: by mail-qc0-f180.google.com with SMTP id a10so546095qcx.39
        for <linux-wireless@vger.kernel.org>; Tue, 07 May 2013 13:15:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430DD2C9FC92@SC-VEXCH1.marvell.com>
References: <CAMLZHHSVd6GpmqTQyJmbsheH1utZh8mNW8d4zLtjwoONaGwbNA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E0579DB@SC-VEXCH1.marvell.com>
	<CAMLZHHQ=BNuD0UmcV8pv=6phW=W-C5C7Af6n8tLWTrzyuzPQow@mail.gmail.com>
	<CAMLZHHQXY3OuWKr_K1B9-NmZFwCcQFPNTBoOkpvT9kxWJ=ixqQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E14FF4C@SC-VEXCH1.marvell.com>
	<CAMLZHHSHG2ySmW0ac6+M-7fOgNFrqXBf7=SXFFkWDrhwGwYKXQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E150221@SC-VEXCH1.marvell.com>
	<CAMLZHHThUxB_Vj4eOjq+61osUQ3CQ5UGgvrgZXE33oDD1N=YtA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E150A22@SC-VEXCH1.marvell.com>
	<CAMLZHHTNPBh3LDD0F2+zqSvUPmT6bhA8HLZvc1dTJmHGR8eVJg@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E232E33@SC-VEXCH1.marvell.com>
	<CAMLZHHS7DOfRfpd-W2hVeJSvxVHNjm7SrxGXH=qLqaFt2sB+BA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430DD2C9FC92@SC-VEXCH1.marvell.com>
Date: Tue, 7 May 2013 14:15:38 -0600
Message-ID: <CAMLZHHQdBuy=7bBsifA4i5ZKQcjnEhKZqVumRE=qu+Jkn3dZug@mail.gmail.com> (sfid-20130507_221544_868433_0C5A5D79)
Subject: Re: Memory leak in mwifiex_cfg80211_scan
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 6, 2013 at 12:42 PM, Bing Zhao <bzhao@marvell.com> wrote:
> There are two different static mwifiex_free_adapter() functions which cause confusion.
> The 1/2 patch renames the one in init.c to mwifiex_adapter_cleanup().

Thanks, that was confusing indeed.
With these patches I can't trigger any further crashes.

I think you should use del_timer_sync() though, for the SMP case where
the timer may be running on a different processor.

Daniel
