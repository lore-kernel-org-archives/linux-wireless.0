Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f43.google.com ([209.85.128.43]:47334 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076Ab3D2OFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 10:05:38 -0400
Received: by mail-qe0-f43.google.com with SMTP id 1so382850qec.30
        for <linux-wireless@vger.kernel.org>; Mon, 29 Apr 2013 07:05:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9E150221@SC-VEXCH1.marvell.com>
References: <CAMLZHHSVd6GpmqTQyJmbsheH1utZh8mNW8d4zLtjwoONaGwbNA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E0579DB@SC-VEXCH1.marvell.com>
	<CAMLZHHQ=BNuD0UmcV8pv=6phW=W-C5C7Af6n8tLWTrzyuzPQow@mail.gmail.com>
	<CAMLZHHQXY3OuWKr_K1B9-NmZFwCcQFPNTBoOkpvT9kxWJ=ixqQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E14FF4C@SC-VEXCH1.marvell.com>
	<CAMLZHHSHG2ySmW0ac6+M-7fOgNFrqXBf7=SXFFkWDrhwGwYKXQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E150221@SC-VEXCH1.marvell.com>
Date: Mon, 29 Apr 2013 08:05:37 -0600
Message-ID: <CAMLZHHThUxB_Vj4eOjq+61osUQ3CQ5UGgvrgZXE33oDD1N=YtA@mail.gmail.com> (sfid-20130429_160558_923347_DA24018B)
Subject: Re: Memory leak in mwifiex_cfg80211_scan
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 26, 2013 at 12:28 PM, Bing Zhao <bzhao@marvell.com> wrote:
> Please find attached Amitkumar's patch that addresses this issue. I tested it on my Chromebook.
> If it works for you on XO-4 I will rebase both patches and resend to the list.

It makes me uneasy that you are prepping the driver to have this timer
still running after mwifiex_close() is called. Anyway, if you do want
to go this route, I think there is no need to add is_ndo_stop. You
should be able to query the net layer for its state. Maybe
netif_running() will do the trick.

I'll await your comments on that before testing.

Thanks
Daniel
