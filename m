Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39301 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194Ab1ESVnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 17:43:08 -0400
Received: by qwk3 with SMTP id 3so1582056qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 14:43:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4dd58d39.ev8WALmbdvCfJmAJ%Larry.Finger@lwfinger.net>
References: <4dd58d39.ev8WALmbdvCfJmAJ%Larry.Finger@lwfinger.net>
Date: Thu, 19 May 2011 23:43:06 +0200
Message-ID: <BANLkTinDciqW2yJLpwKemnSM=8_1Jy3Fxw@mail.gmail.com> (sfid-20110519_234312_596527_8D73AEB6)
Subject: Re: [PATCH] b43: Fix bogus compilation warning for phy_n
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/5/19 Larry Finger <Larry.Finger@lwfinger.net>:
> When cross-compiling the 2.6.39 wireless-testing source using GCC version
> (SUSE Linux) 4.3.2 [gcc-4_3-branch revision 141291] on an x86_64 system,
> the following warning is issued:
>
>  CC [M]  drivers/net/wireless/b43/phy_n.o
> drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_cal_tx_iq_lo’:
> drivers/net/wireless/b43/phy_n.c:3096: warning: ‘last’ may be used
>        uninitialized in this function
>
> A quick look at the code shows that the warning is bogus and a gcc bug,
> but to ensure clean compilation for all users, mark the offending variable
> as uninitialized.

Did you check for both "last" usages on this function? From my quick
review it seems "last" is set in case of
1) mphase_cal_phase_id > 2
xor
2) b43_nphy_tx_tone returning success

I'm not so sure if this patch is correct.

-- 
Rafał
