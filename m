Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50433 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1LHR0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 12:26:31 -0500
Received: by iakc1 with SMTP id c1so2840623iak.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 09:26:31 -0800 (PST)
Message-ID: <4EE0F342.6040105@lwfinger.net> (sfid-20111208_182635_129754_B6B0DE89)
Date: Thu, 08 Dec 2011 11:26:26 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Philipp Dreimann <philipp@dreimann.net>,
	linux-wireless@vger.kernel.org, mikem@ring3k.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rtlwifi, rtl8192se bug soft-lockup
References: <CADYPuQ7W2B9HjR_TiV=dhD3vW-3pR4Y+s_9oJzTC-CdL+hr=9w@mail.gmail.com> <4ED44089.7010102@lwfinger.net> <CADYPuQ61D997MA2JCw1WD_xOosaKvaWK-_RHeBkLtabydDj2iw@mail.gmail.com> <4EDFA124.7010804@lwfinger.net> <CADYPuQ5io_nKkzqwY3uM5bre-bfUvrmH080MBpwqYpNeot5yHA@mail.gmail.com> <20111208095212.GB2402@redhat.com>
In-Reply-To: <20111208095212.GB2402@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/08/2011 03:52 AM, Stanislaw Gruszka wrote:
> On Wed, Dec 07, 2011 at 06:47:58PM -0200, Philipp Dreimann wrote:
>> No, this was not posted so far. I will try to debug the loop issue
>> soonish. The outlined idea above only prevents the issue without
>> knowing what is happening.
>
> I looked at it a bit more and realized that we can replace spinlock
> by mutex. This should fix remaining problems here, and hopefully do
> not introduce any others. Could you test two attached patches, and
> if they do not crash intermediately :-) retest again with
> CONFIG_LOCKDEP ?

After about 1 hour of testing, I see no problems and no lockdep warnings.

BTW, patch #2 did not apply to wireless-testing as your previous patch changing 
the locking in ps.c has already been applied. Fortunately, it was not much of a 
problem to get it applied using wiggle.

Larry

