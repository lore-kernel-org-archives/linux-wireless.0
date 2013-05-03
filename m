Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f53.google.com ([209.85.128.53]:45472 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933901Ab3ECV6v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 17:58:51 -0400
Received: by mail-qe0-f53.google.com with SMTP id cz11so1168834qeb.12
        for <linux-wireless@vger.kernel.org>; Fri, 03 May 2013 14:58:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9E232E33@SC-VEXCH1.marvell.com>
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
Date: Fri, 3 May 2013 15:58:50 -0600
Message-ID: <CAMLZHHS7DOfRfpd-W2hVeJSvxVHNjm7SrxGXH=qLqaFt2sB+BA@mail.gmail.com> (sfid-20130503_235856_200642_69C983B5)
Subject: Re: Memory leak in mwifiex_cfg80211_scan
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 2, 2013 at 12:41 PM, Bing Zhao <bzhao@marvell.com> wrote:
> You are right, this crash also existed before the patch in "deferred scan" path.
> Please try attached patch address this issue.

I haven't tested it yet, but it doesn't look like a fix to me.

Surely the crash here is that the timer_fn is running and using data
that has been freed, like the netdev and the workqueue.

mwifiex_free_adapter() is called at the end of mwifiex_remove_card(),
after it has freed a whole load of that stuff. If you are trying to
stop the timer at this point, you are way too late.

Daniel
